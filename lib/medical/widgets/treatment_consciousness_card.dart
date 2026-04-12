import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/medical/treatment_view.dart';

class TreatmentConsciousnessCard extends StatefulWidget {
  const TreatmentConsciousnessCard({super.key});

  @override
  State<TreatmentConsciousnessCard> createState() =>
      _TreatmentConsciousnessCardState();
}

class _TreatmentConsciousnessCardState
    extends State<TreatmentConsciousnessCard> {
  // --- 樣式定義 ---
  static const Color primaryColor = Color(0xFF007A8A);
  static const Color textDark = Color(0xFF1E293B);
  static const Color textMuted = Color(0xFF64748B);
  static const Color borderColor = Color(0xFFE2E8F0);

  // --- 狀態變數 ---
  bool _isAlert = true;
  int? _leftPupilReactionId = 1;
  int? _rightPupilReactionId = 1;
  int? _gcsTotal;

  // --- 控制器 ---
  late TextEditingController _gcsEController;
  late TextEditingController _gcsVController;
  late TextEditingController _gcsMController;
  late TextEditingController _leftPupilSizeController;
  late TextEditingController _rightPupilSizeController;
  late TextEditingController _headNeckController;
  late TextEditingController _chestController;
  late TextEditingController _abdomenController;
  late TextEditingController _extremitiesController;
  late TextEditingController _otherPhysicalExamController;

  @override
  void initState() {
    super.initState();
    _gcsEController = TextEditingController();
    _gcsVController = TextEditingController();
    _gcsMController = TextEditingController();
    _leftPupilSizeController = TextEditingController();
    _rightPupilSizeController = TextEditingController();
    _headNeckController = TextEditingController();
    _chestController = TextEditingController();
    _abdomenController = TextEditingController();
    _extremitiesController = TextEditingController();
    _otherPhysicalExamController = TextEditingController();
  }

  @override
  void dispose() {
    _gcsEController.dispose();
    _gcsVController.dispose();
    _gcsMController.dispose();
    _leftPupilSizeController.dispose();
    _rightPupilSizeController.dispose();
    _headNeckController.dispose();
    _chestController.dispose();
    _abdomenController.dispose();
    _extremitiesController.dispose();
    _otherPhysicalExamController.dispose();
    super.dispose();
  }

  void _updateControllers(TreatmentViewModel viewModel) {
    // 每次 build 都同步 Controller，確保最新資料能顯示在 UI 上
    // 不再使用 _isInitialized 來阻止更新

    final latestConsciousnessExam = viewModel.latestConsciousnessExam;
    if (latestConsciousnessExam != null) {
      _gcsEController.text = latestConsciousnessExam.gcsE ?? '';
      _gcsVController.text = latestConsciousnessExam.gcsV ?? '';
      _gcsMController.text = latestConsciousnessExam.gcsM ?? '';
      _leftPupilSizeController.text =
          latestConsciousnessExam.leftPupilSize?.toString() ?? '';
      _rightPupilSizeController.text =
          latestConsciousnessExam.rightPupilSize?.toString() ?? '';
      _leftPupilReactionId = latestConsciousnessExam.leftPupilReactionId ?? 1;
      _rightPupilReactionId = latestConsciousnessExam.rightPupilReactionId ?? 1;
      _headNeckController.text = latestConsciousnessExam.headNeckExam ?? '';
      _chestController.text = latestConsciousnessExam.chestExam ?? '';
      _abdomenController.text = latestConsciousnessExam.abdomenExam ?? '';
      _extremitiesController.text =
          latestConsciousnessExam.extremitiesExam ?? '';
      _otherPhysicalExamController.text =
          latestConsciousnessExam.otherPhysicalExam ?? '';
      _isAlert = latestConsciousnessExam.consciousnessLevelId == 1;

      // 計算 GCS Total
      _updateGCSTotalAndValidate(viewModel, save: false);
    }
  }

  // GCS 驗證：檢查數值是否在有效範圍內
  String? _validateGCS(String value, int max, String fieldName) {
    if (value.isEmpty) return null; // 空值不驗證
    final num = int.tryParse(value);
    if (num == null) return '$fieldName 必須為數字';
    if (num < 1 || num > max) {
      return '$fieldName 必須在 1-$max 之間';
    }
    return null; // 驗證通過
  }

  // GCS 自動計算並驗證
  void _updateGCSTotalAndValidate(TreatmentViewModel viewModel,
      {bool save = true}) {
    // 驗證各欄位
    final eError = _validateGCS(_gcsEController.text, 4, 'E');
    final vError = _validateGCS(_gcsVController.text, 5, 'V');
    final mError = _validateGCS(_gcsMController.text, 6, 'M');

    // 計算 Total（只有通過驗證的才計入）
    final e = (eError == null) ? (int.tryParse(_gcsEController.text) ?? 0) : 0;
    final v = (vError == null) ? (int.tryParse(_gcsVController.text) ?? 0) : 0;
    final m = (mError == null) ? (int.tryParse(_gcsMController.text) ?? 0) : 0;

    setState(() {
      _gcsTotal = (e > 0 && v > 0 && m > 0) ? (e + v + m) : null;
    });

    if (save) {
      // 觸發自動儲存
      _onConsciousnessAndExamChanged(viewModel);
    }
  }

  // 意識與理學檢查變更時觸發自動儲存
  void _onConsciousnessAndExamChanged(TreatmentViewModel viewModel) {
    // 計算 GCS Total
    final e = int.tryParse(_gcsEController.text) ?? 0;
    final v = int.tryParse(_gcsVController.text) ?? 0;
    final m = int.tryParse(_gcsMController.text) ?? 0;
    final gcsTotal = (e > 0 && v > 0 && m > 0) ? (e + v + m) : null;

    viewModel.updateConsciousnessAndExamCache(
      isAlert: _isAlert,
      consciousnessLevelId: _isAlert ? 1 : 2,
      gcsE: _gcsEController.text,
      gcsV: _gcsVController.text,
      gcsM: _gcsMController.text,
      gcs: gcsTotal,
      leftPupilReactionId: _leftPupilReactionId,
      leftPupilSize: double.tryParse(_leftPupilSizeController.text),
      rightPupilReactionId: _rightPupilReactionId,
      rightPupilSize: double.tryParse(_rightPupilSizeController.text),
      headNeckExam: _headNeckController.text,
      chestExam: _chestController.text,
      abdomenExam: _abdomenController.text,
      extremitiesExam: _extremitiesController.text,
      otherPhysicalExam: _otherPhysicalExamController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<TreatmentViewModel>();
    
    // 每次 build 都同步控制器，確保最新資料能顯示在 UI 上
    if (viewModel.treatment != null) {
      _updateControllers(viewModel);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCheckboxTile(
          label: '意識清晰 Alert & Oriented',
          value: _isAlert,
          onChanged: (v) {
            setState(() => _isAlert = v!);
            if (_isAlert) {
              _gcsEController.clear();
              _gcsVController.clear();
              _gcsMController.clear();
              setState(() {
                _gcsTotal = null;
              });
            }
            _onConsciousnessAndExamChanged(viewModel);
          },
        ),
        if (!_isAlert) ...[
          const SizedBox(height: 12),
          _buildLabel('GCS 指數評估'),
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  hint: 'E',
                  controller: _gcsEController,
                  textAlign: TextAlign.center,
                  onChanged: (_) => _updateGCSTotalAndValidate(viewModel),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: _buildTextField(
                  hint: 'V',
                  controller: _gcsVController,
                  textAlign: TextAlign.center,
                  onChanged: (_) => _updateGCSTotalAndValidate(viewModel),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: _buildTextField(
                  hint: 'M',
                  controller: _gcsMController,
                  textAlign: TextAlign.center,
                  onChanged: (_) => _updateGCSTotalAndValidate(viewModel),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: primaryColor.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: borderColor),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    _gcsTotal != null ? 'Total: $_gcsTotal' : 'Total',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: _gcsTotal != null ? primaryColor : textMuted,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildPupilSection(
                  '左瞳孔 Left Pupil',
                  (v) {
                    setState(
                      () => _leftPupilReactionId = v == '+'
                          ? 1
                          : (v == '-' ? 2 : 3),
                    );
                    _onConsciousnessAndExamChanged(viewModel);
                  },
                  _leftPupilReactionId == 1
                      ? '+'
                      : (_leftPupilReactionId == 2 ? '-' : '±'),
                  _leftPupilSizeController,
                  viewModel,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildPupilSection(
                  '右瞳孔 Right Pupil',
                  (v) {
                    setState(
                      () => _rightPupilReactionId = v == '+'
                          ? 1
                          : (v == '-' ? 2 : 3),
                    );
                    _onConsciousnessAndExamChanged(viewModel);
                  },
                  _rightPupilReactionId == 1
                      ? '+'
                      : (_rightPupilReactionId == 2 ? '-' : '±'),
                  _rightPupilSizeController,
                  viewModel,
                ),
              ),
            ],
          ),
        ],
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildLabeledFieldWithController(
                '頭頸部 Head/Neck',
                '',
                _headNeckController,
                () => _onConsciousnessAndExamChanged(viewModel),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildLabeledFieldWithController(
                '胸部 Chest',
                '',
                _chestController,
                () => _onConsciousnessAndExamChanged(viewModel),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _buildLabeledFieldWithController(
                '腹部 Abdomen',
                '',
                _abdomenController,
                () => _onConsciousnessAndExamChanged(viewModel),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildLabeledFieldWithController(
                '四肢 Extremities',
                '',
                _extremitiesController,
                () => _onConsciousnessAndExamChanged(viewModel),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        _buildLabeledFieldWithController(
          '其它理學觀察 Other Observations...',
          '',
          _otherPhysicalExamController,
          () => _onConsciousnessAndExamChanged(viewModel),
          maxLines: 2,
        ),
      ],
    );
  }

  // --- UI Helpers ---

  Widget _buildLabel(String text) => Text(
        text,
        style: const TextStyle(
          color: textMuted,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      );

  Widget _buildTextField({
    String? hint,
    TextEditingController? controller,
    ValueChanged<String>? onChanged,
    int maxLines = 1,
    TextAlign textAlign = TextAlign.start,
  }) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      maxLines: maxLines,
      textAlign: textAlign,
      style: const TextStyle(fontSize: 13, color: textDark),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: textMuted.withValues(alpha: 0.5)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        filled: true,
        fillColor: const Color(0xFFF9FBFC), // bgField
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: borderColor),
        ),
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

  Widget _buildCheckboxTile({
    required String label,
    required bool value,
    required Function(bool?) onChanged,
  }) {
    return InkWell(
      onTap: () => onChanged(!value),
      child: Row(
        children: [
          SizedBox(
            width: 24,
            height: 24,
            child: Checkbox(
              value: value,
              onChanged: onChanged,
              activeColor: primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: textDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPupilSection(
    String label,
    Function(String) onReactionChanged,
    String currentReaction,
    TextEditingController sizeController,
    TreatmentViewModel viewModel,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label),
        const SizedBox(height: 4),
        Row(
          children: [
            Container(
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFF9FBFC),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: borderColor),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: ['+', '-', '±'].map((r) {
                  final isSel = currentReaction == r;
                  return GestureDetector(
                    onTap: () => onReactionChanged(r),
                    child: Container(
                      width: 36,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isSel ? primaryColor : Colors.transparent,
                        borderRadius: BorderRadius.circular(7),
                      ),
                      margin: const EdgeInsets.all(2),
                      child: Text(
                        r,
                        style: TextStyle(
                          color: isSel ? Colors.white : textMuted,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildTextField(
                hint: 'mm',
                controller: sizeController,
                textAlign: TextAlign.center,
                onChanged: (_) => _onConsciousnessAndExamChanged(viewModel),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLabeledFieldWithController(
    String label,
    String hint,
    TextEditingController controller,
    VoidCallback onChanged, {
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label),
        const SizedBox(height: 4),
        _buildTextField(
          hint: hint,
          controller: controller,
          onChanged: (_) => onChanged(),
          maxLines: maxLines,
        ),
      ],
    );
  }
}
