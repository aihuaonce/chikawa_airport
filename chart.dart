import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:drift/drift.dart' as drift;
import 'data/db/app_database.dart';

class DailyVisitsChartPage extends StatefulWidget {
  const DailyVisitsChartPage({Key? key}) : super(key: key);

  @override
  State<DailyVisitsChartPage> createState() => _DailyVisitsChartPageState();
}

class _DailyVisitsChartPageState extends State<DailyVisitsChartPage> {
  List<DailyVisitCount> dailyData = [];
  bool isLoading = true;
  int selectedDays = 7;
  
  // 【新增/修改】統計結果變數，改用 double
  late List<ChartCategory> categories;
  int selectedCategoryIndex = 0;
  double totalValue = 0.0;
  double averageValue = 0.0;
  DailyVisitCount? maxDay;

  @override
  void initState() {
    super.initState();
    _initCategories();
    loadDailyVisitsData();
  }

  /// 初始化分類選項
  void _initCategories() {
    categories = <ChartCategory>[
      // 費用類 (MedicalCosts/AmbulanceRecords)
      ChartCategory(label: '初診單數', field: 'count'), // 特別統計：數量
      ChartCategory(label: '出診費', field: 'visitFee'), // MedicalCosts
      ChartCategory(label: '免換後的台幣', field: 'convertedTwdAmount'), // MedicalCosts
      ChartCategory(label: '救護車費用', field: 'ambulanceFee'), // AmbulanceRecords: staffFee + oxygenFee
      ChartCategory(label: '總費用', field: 'totalFee'), // AmbulanceRecords
      
      // 身體檢查/數值類 (Treatments)
      ChartCategory(label: '右睫孔尺寸', field: 'rightPupilSize'), // Treatments
      ChartCategory(label: '左睫孔尺寸', field: 'leftPupilSize'), // Treatments
      ChartCategory(label: 'GCS', field: 'gcs'), // Treatments: E+V+M
      
      // 個人/時間類 (PatientProfiles/AccidentRecords/Visits)
      ChartCategory(label: '年齡', field: 'age'), // PatientProfiles
      ChartCategory(label: '國籍（數量）', field: 'nationality'), // PatientProfiles: 簡單統計有國籍的數量
      ChartCategory(label: '總花費分鐘數', field: 'cost'), // AccidentRecords: cost (分秒) -> 分
    ];
  }

  /// 從資料庫載入每日統計數據 (根據選定的分類欄位)
  Future<void> loadDailyVisitsData() async {
    setState(() => isLoading = true);

    try {
      final db = AppDatabase();
      final endDate = DateTime.now();
      final startDate = endDate.subtract(Duration(days: selectedDays - 1));

      final category = categories[selectedCategoryIndex];
      final categoryField = category.field;
      
      // 【修改】統計值使用 double
      final Map<String, double> dateValueMap = {}; 
      
      // 初始化所有日期為 0
      for (int i = 0; i < selectedDays; i++) {
        final date = startDate.add(Duration(days: i));
        final dateStr = DateFormat('yyyy-MM-dd').format(date);
        dateValueMap[dateStr] = 0.0;
      }

      // 根據欄位判斷需要 Join 哪個表 (Field -> Table/Column)
      final tableInfo = _getTableInfo(categoryField);

      // 進行 Left Join 查詢
      final query = db.select(db.visits).join(
        [
          if (tableInfo.tableName == 'MedicalCosts')
            drift.leftOuterJoin(
              db.medicalCosts,
              db.medicalCosts.visitId.equalsExp(db.visits.visitId),
            ),
          if (tableInfo.tableName == 'Treatments')
            drift.leftOuterJoin(
              db.treatments,
              db.treatments.visitId.equalsExp(db.visits.visitId),
            ),
          if (tableInfo.tableName == 'PatientProfiles')
            drift.leftOuterJoin(
              db.patientProfiles,
              db.patientProfiles.visitId.equalsExp(db.visits.visitId),
            ),
          if (tableInfo.tableName == 'AmbulanceRecords')
            drift.leftOuterJoin(
              db.ambulanceRecords,
              db.ambulanceRecords.visitId.equalsExp(db.visits.visitId),
            ),
          if (tableInfo.tableName == 'AccidentRecords')
            drift.leftOuterJoin(
              db.accidentRecords,
              db.accidentRecords.visitId.equalsExp(db.visits.visitId),
            ),
        ],
      );

      // 篩選時間範圍
      query.where(db.visits.createdAt.isBetween(
        drift.Variable.withDateTime(startDate),
        drift.Variable.withDateTime(endDate),
      ));

      final results = await query.get();

      // 2. 根據選定的分類欄位進行統計
      for (final row in results) {
        final visit = row.readTable(db.visits);
        if (visit.createdAt == null) continue;

        final dateStr = DateFormat('yyyy-MM-dd').format(visit.createdAt!);
        double value = 0.0;

        // 取得欄位的值
        if (categoryField == 'count') {
          // 特別處理：統計初診單數量
          value = 1.0;
        } else {
          try {
            // 費用類 (MedicalCosts)
            if (tableInfo.tableName == 'MedicalCosts') {
              final cost = row.readTableOrNull(db.medicalCosts);
              if (cost != null) {
                if (categoryField == 'visitFee' && cost.visitFee != null) {
                  value = double.tryParse(cost.visitFee!) ?? 0.0;
                } else if (categoryField == 'convertedTwdAmount' && cost.convertedTwdAmount != null) {
                  value = double.tryParse(cost.convertedTwdAmount!) ?? 0.0;
                }
              }
            } 
            // 身體檢查類 (Treatments)
            else if (tableInfo.tableName == 'Treatments') {
              final treatment = row.readTableOrNull(db.treatments);
              if (treatment != null) {
                if (categoryField == 'leftPupilSize' && treatment.leftPupilSize != null) {
                  value = double.tryParse(treatment.leftPupilSize!) ?? 0.0;
                } else if (categoryField == 'rightPupilSize' && treatment.rightPupilSize != null) {
                  value = double.tryParse(treatment.rightPupilSize!) ?? 0.0;
                } else if (categoryField == 'gcs' && treatment.evmE != null && treatment.evmV != null && treatment.evmM != null) {
                  // GCS 欄位通常是 E(1-4)V(1-5)M(1-6) 三個值的和
                  final e = int.tryParse(treatment.evmE!) ?? 0;
                  final v = int.tryParse(treatment.evmV!) ?? 0;
                  final m = int.tryParse(treatment.evmM!) ?? 0;
                  value = (e + v + m).toDouble();
                }
              }
            }
            // 個人資料類 (PatientProfiles)
            else if (tableInfo.tableName == 'PatientProfiles') {
              final profile = row.readTableOrNull(db.patientProfiles);
              if (profile != null) {
                if (categoryField == 'age' && profile.age != null) {
                  value = profile.age!.toDouble();
                } else if (categoryField == 'nationality' && profile.nationality != null && profile.nationality!.isNotEmpty) {
                    // 國籍：簡單統計非空的數量
                    value = 1.0;
                }
              }
            }
            // 救護車/費用類 (AmbulanceRecords)
            else if (tableInfo.tableName == 'AmbulanceRecords') {
              final ambulance = row.readTableOrNull(db.ambulanceRecords);
              if (ambulance != null) {
                if (categoryField == 'totalFee' && ambulance.totalFee != null) {
                  value = ambulance.totalFee!.toDouble();
                } else if (categoryField == 'ambulanceFee' && ambulance.oxygenFee != null && ambulance.staffFee != null) {
                  // 這裡假設救護車費用是 oxygenFee + staffFee
                  value = (ambulance.oxygenFee! + ambulance.staffFee!).toDouble();
                }
              }
            }
            // 事故記錄類 (AccidentRecords)
            else if (tableInfo.tableName == 'AccidentRecords') {
              final accident = row.readTableOrNull(db.accidentRecords);
              if (accident != null) {
                if (categoryField == 'cost' && accident.cost != null) {
                  // 'cost' 是 '花費時間(分秒)'，假設格式是 'mm:ss'，我們只取分鐘數
                  final parts = accident.cost!.split(':');
                  if (parts.length == 2) {
                    value = double.tryParse(parts[0]) ?? 0.0;
                  }
                }
              }
            }
            
          } catch (e) {
            print('資料轉換錯誤: $e');
            value = 0.0;
          }
        }

        // 累積到每日總和
        dateValueMap[dateStr] = (dateValueMap[dateStr] ?? 0.0) + value;
      }

      dailyData = dateValueMap.entries
          .map((e) => DailyVisitCount(
                date: DateTime.parse(e.key),
                count: e.value,
              ))
          .toList()
        ..sort((a, b) => a.date.compareTo(b.date));
        
      // 計算總計、平均、最高
      totalValue = dailyData.fold<double>(0.0, (sum, item) => sum + item.count);
      averageValue = dailyData.isNotEmpty ? totalValue / dailyData.length : 0.0;
      if (dailyData.isNotEmpty) {
        maxDay = dailyData.reduce((a, b) => a.count > b.count ? a : b);
      } else {
        maxDay = null;
      }

      setState(() => isLoading = false);
    } catch (e) {
      print('載入資料錯誤: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('載入失敗: $e')),
        );
      }
      setState(() => isLoading = false);
    }
  }

  /// 輔助函式：根據欄位名稱判斷它所在的資料表
  ({String tableName, String columnName}) _getTableInfo(String field) {
    // MedicalCosts
    if (['visitFee', 'convertedTwdAmount'].contains(field)) {
      return (tableName: 'MedicalCosts', columnName: field);
    }
    // Treatments
    if (['leftPupilSize', 'rightPupilSize', 'gcs'].contains(field)) {
      return (tableName: 'Treatments', columnName: field);
    }
    // PatientProfiles
    if (['age', 'nationality'].contains(field)) {
      return (tableName: 'PatientProfiles', columnName: field);
    }
    // AmbulanceRecords
    if (['totalFee', 'ambulanceFee'].contains(field)) {
      return (tableName: 'AmbulanceRecords', columnName: field);
    }
    // AccidentRecords
    if (['cost'].contains(field)) {
      return (tableName: 'AccidentRecords', columnName: field);
    }
    // Visits/Count (預設或數量)
    return (tableName: 'Visits', columnName: field);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('每日統計'),
        actions: [
          PopupMenuButton<int>(
            icon: const Icon(Icons.date_range),
            onSelected: (days) {
              setState(() => selectedDays = days);
              loadDailyVisitsData();
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 7, child: Text('最近 7 天')),
              const PopupMenuItem(value: 14, child: Text('最近 14 天')),
              const PopupMenuItem(value: 30, child: Text('最近 30 天')),
              const PopupMenuItem(value: 60, child: Text('最近 60 天')),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // 【新增】分類選擇列表
          _buildCategorySelector(),
          
          // 主要內容
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : dailyData.isEmpty
                    ? Center(
                        child: Text(
                          '暫無資料 (${categories[selectedCategoryIndex].label})',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      )
                    : SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSummaryCard(),
                            const SizedBox(height: 24),
                            Text(
                              '每日${categories[selectedCategoryIndex].label}統計',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              height: 400,
                              child: _buildBarChart(),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              '詳細數據',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 16),
                            _buildDataTable(),
                          ],
                        ),
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: loadDailyVisitsData,
        tooltip: '重新載入',
        child: const Icon(Icons.refresh),
      ),
    );
  }

  /// 分類選擇器
  Widget _buildCategorySelector() {
    return Container(
      color: Colors.grey.shade100,
      padding: const EdgeInsets.all(12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            const Text('分類: ', style: TextStyle(fontWeight: FontWeight.w600)),
            ...List.generate(categories.length, (index) {
              final isSelected = index == selectedCategoryIndex;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: ChoiceChip(
                  label: Text(categories[index].label),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        selectedCategoryIndex = index;
                      });
                      loadDailyVisitsData();
                    }
                  },
                  selectedColor: const Color(0xFF274C4A),
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard() {
    // 【修改】使用計算好的變數
    final total = totalValue; 
    final average = averageValue; 
    final max = maxDay; 
    
    // 取得當前分類的單位名稱
    final unit = _getUnit(categories[selectedCategoryIndex].field);

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // 【修改】顯示格式
            _buildStatItem('總計', '${total.toStringAsFixed(1)} $unit', Icons.assignment), 
            _buildStatItem('平均', '${average.toStringAsFixed(1)} $unit/日', Icons.trending_up),
            if (max != null) // 檢查 max 是否為空
              _buildStatItem(
                '最高',
                '${max.count.toStringAsFixed(1)} $unit', // 顯示格式
                Icons.star,
                subtitle: DateFormat('M/d').format(max.date),
              ),
          ],
        ),
      ),
    );
  }

  /// 輔助函式：取得單位名稱
  String _getUnit(String field) {
    if (field == 'count' || field == 'nationality') return '筆';
    if (field == 'cost') return '分';
    if (field.contains('Fee') || field.contains('TwdAmount')) return '元';
    if (field.contains('PupilSize')) return 'mm';
    if (field == 'gcs') return '';
    if (field == 'age') return '歲';
    return '';
  }

  Widget _buildStatItem(String label, String value, IconData icon,
      {String? subtitle}) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFF274C4A), size: 32),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(color: Colors.grey)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        if (subtitle != null) ...[
          const SizedBox(height: 2),
          Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ],
    );
  }

  Widget _buildBarChart() {
    if (dailyData.isEmpty) return const SizedBox();

    final maxCount =
        dailyData.map((e) => e.count).reduce((a, b) => a > b ? a : b);
    final unit = _getUnit(categories[selectedCategoryIndex].field);

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: (maxCount * 1.2).ceilToDouble(),
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              final data = dailyData[group.x.toInt()];
              return BarTooltipItem(
                // 【修改】顯示格式，使用 toStringAsFixed(1)
                '${DateFormat('yyyy/MM/dd').format(data.date)}\n${data.count.toStringAsFixed(1)} $unit',
                const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 50,
              getTitlesWidget: (value, meta) {
                if (value.toInt() >= 0 && value.toInt() < dailyData.length) {
                  final date = dailyData[value.toInt()].date;
                  final showEvery = selectedDays > 30 ? 3 : (selectedDays > 14 ? 2 : 1);
                  if (value.toInt() % showEvery == 0) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Transform.rotate(
                        angle: -0.5,
                        child: Text(
                          DateFormat('M/d').format(date), // 顯示月/日
                          style: const TextStyle(fontSize: 9),
                        ),
                      ),
                    );
                  }
                }
                return const SizedBox();
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                return Text(
                  // Y 軸標籤顯示整數
                  value.toInt().toString(), 
                  style: const TextStyle(fontSize: 12),
                );
              },
            ),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
        ),
        borderData: FlBorderData(show: false),
        barGroups: List.generate(
          dailyData.length,
          (index) {
            final data = dailyData[index];
            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: data.count, // count 現在是 double
                  color: _getBarColor(data.count, maxCount),
                  width: selectedDays > 30 ? 8 : 16,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(4),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // 【修改】參數類型為 double
  Color _getBarColor(double count, double maxCount) {
    final ratio = maxCount == 0 ? 0 : count / maxCount;
    if (ratio > 0.8) return Colors.red;
    if (ratio > 0.5) return Colors.orange;
    if (ratio > 0.3) return const Color(0xFF274C4A);
    return Colors.blue.shade300;
  }

  Widget _buildDataTable() {
    final unit = _getUnit(categories[selectedCategoryIndex].field);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Expanded(flex: 2, child: Text('日期', style: TextStyle(fontWeight: FontWeight.bold))),
                  const Expanded(child: Text('星期', style: TextStyle(fontWeight: FontWeight.bold))),
                  Expanded(
                    child: Text(
                      '數量 ($unit)', // 顯示單位
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            ...dailyData.reversed.map((data) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(DateFormat('yyyy/MM/dd').format(data.date)),
                  ),
                  Expanded(
                    child: Text(_getWeekdayName(data.date)),
                  ),
                  Expanded(
                    child: Text(
                      // 【修改】顯示格式，使用 toStringAsFixed(1)
                      '${data.count.toStringAsFixed(1)}',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        // 【修改】比較條件
                        color: data.count > 0 ? const Color(0xFF274C4A) : Colors.grey, 
                      ),
                    ),
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }

  String _getWeekdayName(DateTime date) {
    const weekdays = ['週日', '週一', '週二', '週三', '週四', '週五', '週六'];
    return weekdays[date.weekday % 7];
  }
}

/// 分類資料模型
class ChartCategory {
  final String label;
  final String field;

  ChartCategory({required this.label, required this.field});
}

/// 每日統計資料模型
class DailyVisitCount {
  final DateTime date;
  // 【修改】將 count 類型從 int 改為 double
  final double count; 

  DailyVisitCount({required this.date, required this.count});
}