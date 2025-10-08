import 'dart:convert';
import 'package:chikawa_airport/nav3.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'AccidentRecord.dart';
import 'PersonalInformation.dart';
import 'data/models/patient_data.dart';
import 'data/db/daos.dart';
import 'providers/routes_config.dart';
import 'widgets/nav_common.dart';

mixin SavableStateMixin<T extends StatefulWidget> on State<T> {
  Future<void> saveData();
}

class Nav2Page extends StatefulWidget {
  final int visitId;
  final int initialIndex;

  const Nav2Page({super.key, required this.visitId, this.initialIndex = 0});

  @override
  State<Nav2Page> createState() => _Nav2PageState();
}

class _Nav2PageState extends State<Nav2Page> with WidgetsBindingObserver {
  late int currentIndex;
  final Map<int, GlobalKey> _pageKeys = {};
  final Map<int, Widget> _cachedPages = {};
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
    WidgetsBinding.instance.addObserver(this);

    // 初始化所有頁面的 GlobalKey
    _initializePageKeys();

    // 延遲建立頁面，確保 context 準備好
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _buildAllPages();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _initializePageKeys() {
    for (int i = 0; i < routeItems.length; i++) {
      // 雖然這裡 GlobalKey 仍然使用通用型別，但我們會在 _savePageByIndex 中處理型別轉換
      // 保持 GlobalKey<State> 的彈性是必要的，因為有些頁面可能沒有 Mixin
      // 但為了讓編譯器更友善，我們可以將其宣告為 GlobalKey<State>

      // 由於您使用了 Mixin，最穩妥的作法是保持 GlobalKey()，並在 _savePageByIndex 中處理。
      _pageKeys[i] = GlobalKey();
    }
  }

  void _buildAllPages() {
    if (!mounted) return;

    setState(() {
      for (int i = 0; i < routeItems.length; i++) {
        try {
          _cachedPages[i] = routeItems[i].builder(
            widget.visitId,
            _pageKeys[i]!,
          );
        } catch (e) {}
      }
    });
  }

  Future<void> _saveCurrentPage() async {
    if (_isSaving) return;

    final key = _pageKeys[currentIndex];
    if (key?.currentState == null) return;

    try {
      await _savePageByIndex(currentIndex);
    } catch (e) {}
  }

  Future<bool> _savePageByIndex(int index) async {
    final key = _pageKeys[index];
    final pageName = routeItems[index].label;

    if (key?.currentState == null) {
      return false;
    }

    try {
      final state = key!.currentState!;

      // 檢查是否有 SavableStateMixin
      if (state is SavableStateMixin) {
        // ✅ 關鍵修正：必須先轉型，才能呼叫 saveData()
        await (state as SavableStateMixin).saveData();
        return true;
      } else {
        return true;
      }
    } catch (e) {
      return false;
    }
  }

  Future<void> _saveAllPages() async {
    if (_isSaving) return;

    setState(() {
      _isSaving = true;
    });

    bool hasErrors = false;
    List<String> errorMessages = [];
    List<String> successMessages = [];

    try {
      // 首先確保所有頁面都已建立
      if (_cachedPages.length != routeItems.length) {
        _buildAllPages();
        // 等待頁面建立完成
        await Future.delayed(const Duration(milliseconds: 500));
      }

      // 遍歷所有頁面並儲存
      for (int i = 0; i < routeItems.length; i++) {
        final pageName = routeItems[i].label;

        try {
          bool success = await _savePageByIndex(i);
          if (success) {
            successMessages.add(pageName);
          } else {
            hasErrors = true;
            errorMessages.add('$pageName: 儲存失敗');
          }
        } catch (e) {
          hasErrors = true;
          errorMessages.add('$pageName: ${e.toString()}');
        }

        // 每個頁面之間稍作延遲
        await Future.delayed(const Duration(milliseconds: 100));
      }

      // 儲存公共資料
      try {
        await _saveCommonData();
        successMessages.add('公共資料');
      } catch (e) {
        hasErrors = true;
        errorMessages.add('公共資料: ${e.toString()}');
      }

      // ✅ 關鍵修改：儲存完成後，清除快取並重建所有頁面
      // 這樣下次切換到頁面時會重新執行 initState，從資料庫載入最新資料
      debugPrint("🔄 清除頁面快取並重建...");
      _cachedPages.clear();
      _pageKeys.clear();
      _initializePageKeys();

      // 延遲一下再重建，確保狀態已清除
      await Future.delayed(const Duration(milliseconds: 200));
      _buildAllPages();
    } catch (e) {
      hasErrors = true;
      errorMessages.add('系統錯誤: ${e.toString()}');
    }

    setState(() {
      _isSaving = false;
    });

    // 顯示結果
    if (!mounted) return;

    if (hasErrors) {
      _showErrorDialog(errorMessages, successMessages);
    } else {
      _showSuccessMessage();
      // 延遲一下再返回，讓用戶看到成功訊息
      await Future.delayed(const Duration(milliseconds: 1000));
      if (mounted) {
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    }
  }

  void _showErrorDialog(List<String> errors, List<String> successes) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('儲存結果'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (successes.isNotEmpty) ...[
                  const Text(
                    '成功儲存:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  ...successes.map((msg) => Text('✅ $msg')),
                  const SizedBox(height: 10),
                ],
                if (errors.isNotEmpty) ...[
                  const Text(
                    '儲存失敗:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  ...errors.map((msg) => Text('❌ $msg')),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('確定'),
            ),
            if (errors.isNotEmpty)
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  // 重試儲存
                  _saveAllPages();
                },
                child: const Text('重試'),
              ),
          ],
        );
      },
    );
  }

  void _showSuccessMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('所有頁面資料已成功儲存'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> _saveCommonData() async {
    final patientData = context.read<PatientData>();
    final patientDao = context.read<PatientProfilesDao>();
    final visitsDao = context.read<VisitsDao>();

    // 儲存 base64 照片
    final String? base64Photo = patientData.photoBase64;

    // 寫入 PatientProfiles
    await patientDao.upsertByVisitId(
      visitId: widget.visitId,
      birthday: patientData.birthday,
      gender: patientData.gender,
      reason: patientData.reason,
      nationality: patientData.nationality,
      idNumber: patientData.idNumber,
      address: patientData.address,
      phone: patientData.phone,
      photoPath: base64Photo,
    );

    // 同步回 Visits 主檔
    await visitsDao.updateVisitSummary(
      widget.visitId,
      gender: patientData.gender,
      nationality: patientData.nationality,
      note: patientData.note,
    );

    // 儲存完畢後清空 PatientData
    patientData.clear();
  }

  void _onPageChanged(int index) {
    if (index == currentIndex) return;

    // 在切換頁面前儲存當前頁面
    _saveCurrentPage().then((_) {
      if (mounted) {
        setState(() {
          currentIndex = index;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6F6FB),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: Column(
          children: [
            // 導航列
            Row(
              children: [
                // 左側導航按鈕
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: routeItems.asMap().entries.map((entry) {
                        final index = entry.key;
                        final item = entry.value;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: NavPillButton(
                            label: item.label,
                            active: currentIndex == index,
                            onTap: () => _onPageChanged(index),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // 右側儲存按鈕
                _isSaving
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : IconButton(
                        icon: const Icon(Icons.save),
                        tooltip: '儲存所有頁面',
                        onPressed: _saveAllPages,
                      ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(top: 12),
              child: Nav3Section(),
            ),
            // 頁面內容
            Expanded(
              child: _cachedPages.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : IndexedStack(
                      index: currentIndex,
                      children: List.generate(
                        routeItems.length,
                        (index) => _cachedPages[index] ?? Container(),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    // 當應用程式進入背景時自動儲存
    if (state == AppLifecycleState.paused) {
      _saveCurrentPage();
    }
  }
}
