import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../data/models/medical/nursing_record_view.dart';
import '../../data/models/medical/treatment_view.dart';
import '../../data/db/database.dart';
import '../widgets/staff_search_sheet.dart';
import '../widgets/signature_field.dart';

class NursingRecord extends StatefulWidget {
  final int medicalId;
  const NursingRecord({super.key, required this.medicalId});

  @override
  State<NursingRecord> createState() => _NursingRecordState();
}

class _NursingRecordState extends State<NursingRecord> {
  // 樣式定義
  static const Color primaryColor = Color(0xFF007A8A);
  static const Color textDark = Color(0xFF1E293B);
  static const Color textMuted = Color(0xFF64748B);
  static const Color borderColor = Color(0xFFE2E8F0);
  static const Color bgField = Color(0xFFF9FBFC);

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<NursingRecordViewModel>();
    final treatmentViewModel = context.watch<TreatmentViewModel>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 頂部：新增按鈕 (右對齊)
        Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            onPressed: () => _showAddRecordModal(viewModel, treatmentViewModel),
            icon: const Icon(Icons.add_circle_outline, size: 20),
            label: const Text(
              '新增護理記錄',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            style: TextButton.styleFrom(
              foregroundColor: primaryColor,
              backgroundColor: primaryColor.withValues(alpha: 0.05),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),

        const SizedBox(height: 16),

        // 內嵌式編輯表格
        _buildInlineTable(viewModel, treatmentViewModel, viewModel.records),

        const SizedBox(height: 60),
      ],
    );
  }

  // --- 1. 內嵌式表格 (參考健康評估表樣式) ---
  Widget _buildInlineTable(
    NursingRecordViewModel viewModel,
    TreatmentViewModel treatmentViewModel,
    List<NursingRecordData> records,
  ) {
    if (records.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor),
        ),
        child: const Center(
          child: Text('尚無護理記錄，請點擊新增', style: TextStyle(color: textMuted)),
        ),
      );
    }

    return Column(
      children: [
        // 表頭
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              Expanded(flex: 2, child: _buildTableLabel('記錄時間')),
              const SizedBox(width: 12),
              Expanded(flex: 5, child: _buildTableLabel('記錄內容')),
              const SizedBox(width: 12),
              SizedBox(width: 100, child: _buildTableLabel('護理師')),
              const SizedBox(width: 12),
              SizedBox(width: 40, child: _buildTableLabel('簽名')),
              const SizedBox(width: 40),
            ],
          ),
        ),
        // 資料行
        ...records.asMap().entries.map((entry) {
          var record = entry.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 記錄時間編輯
                Expanded(
                  flex: 2,
                  child: _buildInlineTextField(
                    initialValue: DateFormat(
                      'yyyy/MM/dd HH:mm:ss',
                    ).format(record.recordTime),
                    onChanged: (val) {
                      final dateTime = DateTime.tryParse(val);
                      if (dateTime != null) {
                        viewModel.updateRecordTime(record.recordId, dateTime);
                      }
                    },
                  ),
                ),
                const SizedBox(width: 12),
                // 內容編輯
                Expanded(
                  flex: 5,
                  child: _buildInlineTextField(
                    initialValue: record.content,
                    maxLines: null,
                    onChanged: (val) {
                      viewModel.updateRecordContent(record.recordId, val);
                    },
                  ),
                ),
                const SizedBox(width: 12),
                // 護理師選擇
                SizedBox(
                  width: 100,
                  child: _buildInlineStaffSelect(
                    viewModel: viewModel,
                    treatmentViewModel: treatmentViewModel,
                    nurseId: record.nurseId,
                    onChanged: (val) {
                      if (val != null) {
                        viewModel.updateRecordNurse(record.recordId, val);
                        final signature = viewModel.getNurseSignature(val);
                        if (signature != null) {
                          viewModel.addSignature(record.recordId, signature);
                        }
                      }
                    },
                  ),
                ),
                const SizedBox(width: 12),
                // 簽名狀態圖示 / 按鈕
                SizedBox(
                  width: 40,
                  height: 40,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: Icon(
                      record.signature != null
                          ? Icons.verified_user_rounded
                          : Icons.draw_outlined,
                      color: record.signature != null
                          ? primaryColor
                          : textMuted.withValues(alpha: 0.5),
                      size: 22,
                    ),
                    onPressed: () {
                      _showSignatureDialog(context, viewModel, record);
                    },
                  ),
                ),
                // 刪除按鈕
                IconButton(
                  onPressed: () => viewModel.deleteRecord(record.recordId),
                  icon: Icon(
                    Icons.close_rounded,
                    color: Colors.red.withValues(alpha: 0.5),
                    size: 22,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  // --- 3. 獨立簽名彈窗 (用於內嵌表格) ---
  void _showSignatureDialog(
    BuildContext context,
    NursingRecordViewModel viewModel,
    NursingRecordData record,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  '護理師簽名',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 200,
                  child: SignatureField(
                    value: record.signature,
                    onChanged: (data) {
                      viewModel.addSignature(record.recordId, data);
                      // 簽名後自動關閉? 或者讓使用者點確認?
                      // SignatureField 內部已有 Dialog, 但這裡是直接顯示在 Dialog 中?
                      // Wait, SignatureField is a button/preview that OPENS a dialog.
                      // So here we are putting a SignatureField inside a Dialog?
                      // Actually, SignatureField is designed to look like a field.
                      // If we want to sign directly, we should use SignatureField logic.
                      // But if we want to update the record signature, we can just let the user tap the field.
                    },
                    // We can customize height
                    height: 180,
                  ),
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('關閉'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // --- 2. 新增記錄彈窗 ---
  void _showAddRecordModal(
    NursingRecordViewModel viewModel,
    TreatmentViewModel treatmentViewModel,
  ) {
    int? tempSelectedPhraseId;
    int? tempNurseId;
    String? tempNurseName;
    Uint8List? tempSignature;

    // 自動帶入主責護理師
    try {
      final assignments = treatmentViewModel.staffAssignments;
      final primaryNurse = assignments
          .where(
            (a) =>
                treatmentViewModel.getStaffRoleCode(a.staffRoleId) == 'NURSE' &&
                a.isPrimary,
          )
          .firstOrNull;

      if (primaryNurse != null) {
        tempNurseId = primaryNurse.staffId;
        tempNurseName = viewModel.getNurseNameById(tempNurseId);
        tempSignature = viewModel.getNurseSignature(tempNurseId);
      }
    } catch (_) {
      // 忽略錯誤，維持空值
    }

    final TextEditingController timeCtrl = TextEditingController(
      text: DateFormat('yyyy/MM/dd HH:mm:ss').format(DateTime.now()),
    );
    final TextEditingController contentCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: EdgeInsets.fromLTRB(
                24,
                24,
                24,
                MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.85,
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '新增護理記錄',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // 片語選擇 (單選)
                    _buildLabel('快捷片語 (單選帶入內容)'),
                    const SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: bgField,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: borderColor),
                      ),
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children:
                            viewModel.phrases.map((phrase) {
                              bool isSel = tempSelectedPhraseId == phrase.id;
                              return InkWell(
                                onTap: () async {
                                  if (isSel) {
                                    setModalState(() {
                                      tempSelectedPhraseId = null;
                                    });
                                  } else {
                                    setModalState(() {
                                      tempSelectedPhraseId = phrase.id;
                                    });

                                    // 處理片語變數替換
                                    final processedContent =
                                        await viewModel.applyTemplate(
                                          phrase.content,
                                        );

                                    // 檢查元件是否還存在
                                    if (context.mounted) {
                                      contentCtrl.text = processedContent;
                                    }
                                  }
                                },
                                borderRadius: BorderRadius.circular(20),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        isSel
                                            ? primaryColor
                                            : Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color:
                                          isSel
                                              ? primaryColor
                                              : borderColor,
                                    ),
                                    boxShadow:
                                        isSel
                                            ? [
                                              BoxShadow(
                                                color: primaryColor
                                                    .withValues(alpha: 0.3),
                                                blurRadius: 4,
                                                offset: const Offset(0, 2),
                                              ),
                                            ]
                                            : null,
                                  ),
                                  child: Text(
                                    phrase.title,
                                    style: TextStyle(
                                      color:
                                          isSel
                                              ? Colors.white
                                              : textDark,
                                      fontSize: 13,
                                      fontWeight:
                                          isSel
                                              ? FontWeight.bold
                                              : FontWeight.w500,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                      ),
                    ),

                    const SizedBox(height: 24),

                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: _buildFieldWrapper(
                            '記錄時間',
                            GestureDetector(
                              onTap: () async {
                                final now = DateTime.now();
                                final currentDate = DateTime.tryParse(
                                  timeCtrl.text,
                                );
                                final initialDate = currentDate ?? now;

                                // 1. 選擇日期
                                final pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: initialDate,
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2100),
                                  builder: (context, child) {
                                    return Theme(
                                      data: Theme.of(context).copyWith(
                                        colorScheme: const ColorScheme.light(
                                          primary: primaryColor,
                                          onPrimary: Colors.white,
                                          onSurface: textDark,
                                        ),
                                      ),
                                      child: child!,
                                    );
                                  },
                                );

                                if (pickedDate != null) {
                                  // 2. 選擇時間
                                  if (!context.mounted) return;
                                  final pickedTime = await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.fromDateTime(
                                      initialDate,
                                    ),
                                    builder: (context, child) {
                                      return Theme(
                                        data: Theme.of(context).copyWith(
                                          colorScheme: const ColorScheme.light(
                                            primary: primaryColor,
                                            onPrimary: Colors.white,
                                            onSurface: textDark,
                                          ),
                                        ),
                                        child: child!,
                                      );
                                    },
                                  );

                                  if (pickedTime != null) {
                                    final newDateTime = DateTime(
                                      pickedDate.year,
                                      pickedDate.month,
                                      pickedDate.day,
                                      pickedTime.hour,
                                      pickedTime.minute,
                                      // 保持原有的秒數或歸零，這裡選擇歸零
                                      0,
                                    );
                                    timeCtrl.text = DateFormat(
                                      'yyyy/MM/dd HH:mm:ss',
                                    ).format(newDateTime);
                                  }
                                }
                              },
                              child: AbsorbPointer(
                                child: _buildTextField(
                                  hint: '',
                                  controller: timeCtrl,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildFieldWrapper(
                            '護理師',
                            GestureDetector(
                              onTap: () async {
                                final result = await StaffSearchSheet.show(
                                  context,
                                  title: '選擇護理師',
                                  viewModel: treatmentViewModel,
                                  roleFilter: 'Nurse',
                                );
                                if (result != null) {
                                  setModalState(() {
                                    tempNurseId = result.id;
                                    tempNurseName = result.name;

                                    // 自動帶入護理師簽名
                                    final signature = viewModel
                                        .getNurseSignature(result.id);
                                    if (signature != null) {
                                      tempSignature = signature;
                                    }
                                  });
                                }
                              },
                              child: Container(
                                height: 48,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: bgField,
                                  border: Border.all(color: borderColor),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        tempNurseName ?? '點擊選擇',
                                        style: TextStyle(
                                          color: tempNurseName != null
                                              ? textDark
                                              : textMuted,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    const Icon(
                                      Icons.arrow_drop_down,
                                      color: textMuted,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),
                    _buildFieldWrapper(
                      '記錄內容',
                      _buildTextField(
                        hint: '請輸入或修改內容...',
                        controller: contentCtrl,
                        maxLines: 5,
                      ),
                    ),

                    const SizedBox(height: 20),
                    _buildLabel('護理師簽名'),
                    const SizedBox(height: 8),
                    SignatureField(
                      value: tempSignature,
                      onChanged: (data) {
                        setModalState(() {
                          tempSignature = data;
                        });
                      },
                    ),
                    // Container(...) was removed

                    const SizedBox(height: 32),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('取消'),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () {
                              if (contentCtrl.text.isNotEmpty) {
                                final dateTime = DateTime.tryParse(
                                  timeCtrl.text,
                                );
                                viewModel.addRecord(
                                  recordTime: dateTime ?? DateTime.now(),
                                  content: contentCtrl.text,
                                  nurseId: tempNurseId,
                                  signature: tempSignature,
                                );
                                Navigator.pop(context);
                              }
                            },
                            child: const Text('確認新增'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // --- 工具元件 ---

  Widget _buildInlineTextField({
    required String initialValue,
    int? maxLines = 1,
    Function(String)? onChanged,
  }) {
    return TextFormField(
      initialValue: initialValue,
      maxLines: maxLines,
      onChanged: onChanged,
      style: const TextStyle(fontSize: 13, color: textDark),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primaryColor, width: 1.5),
        ),
      ),
    );
  }

  Widget _buildInlineStaffSelect({
    required NursingRecordViewModel viewModel,
    required TreatmentViewModel treatmentViewModel,
    required int? nurseId,
    required Function(int?) onChanged,
  }) {
    final nurseName = viewModel.getNurseNameById(nurseId) ?? '點擊選擇';

    return GestureDetector(
      onTap: () async {
        final result = await StaffSearchSheet.show(
          context,
          title: '選擇護理師',
          viewModel: treatmentViewModel,
          roleFilter: 'Nurse',
        );
        if (result != null) {
          onChanged(result.id);
        }
      },
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: borderColor),
        ),
        alignment: Alignment.centerLeft,
        child: Text(
          nurseName,
          style: const TextStyle(fontSize: 13, overflow: TextOverflow.ellipsis),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String hint,
    TextEditingController? controller,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: bgField,
        contentPadding: const EdgeInsets.all(12),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primaryColor),
        ),
      ),
    );
  }


  Widget _buildLabel(String text) => Text(
    text,
    style: const TextStyle(
      color: textMuted,
      fontSize: 11,
      fontWeight: FontWeight.bold,
      letterSpacing: 0.5,
    ),
  );

  Widget _buildTableLabel(String text) => Text(
    text,
    style: const TextStyle(
      color: textMuted,
      fontSize: 11,
      fontWeight: FontWeight.w600,
    ),
  );

  Widget _buildFieldWrapper(String label, Widget field) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [_buildLabel(label), const SizedBox(height: 6), field],
    );
  }
}
