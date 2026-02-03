import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:signature/signature.dart';

class SignatureField extends StatelessWidget {
  final String placeholder;
  final Uint8List? value;
  final Function(Uint8List) onChanged;
  final VoidCallback? onTap; // Optional override for tap action
  final double height;
  final Color backgroundColor;
  final Color borderColor;

  const SignatureField({
    super.key,
    this.placeholder = '點擊簽名 Click to Sign',
    required this.value,
    required this.onChanged,
    this.onTap,
    this.height = 80,
    this.backgroundColor = const Color(0xFFF9FBFC), // bgField
    this.borderColor = const Color(0xFFE2E8F0), // borderColor
  });

  static const Color primaryColor = Color(0xFF007A8A);
  static const Color textMuted = Color(0xFF64748B);

  @override
  Widget build(BuildContext context) {
    final bool isSigned = value != null;
    
    return GestureDetector(
      onTap: onTap ?? () => _showSignatureDialog(context),
      child: Container(
        height: height,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: isSigned ? primaryColor : borderColor,
            width: isSigned ? 1.5 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            if (isSigned)
              BoxShadow(
                color: primaryColor.withValues(alpha: 0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: isSigned
            ? ClipRRect(
                borderRadius: BorderRadius.circular(11), // Slightly less than container
                child: Image.memory(
                  value!,
                  fit: BoxFit.contain,
                  width: double.infinity,
                  color: primaryColor, // Optional: Tint the signature to primary color for consistency
                  colorBlendMode: BlendMode.srcIn,
                ),
              )
            : Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: textMuted.withValues(alpha: 0.05),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.edit_outlined,
                        size: 18,
                        color: textMuted.withValues(alpha: 0.7),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      placeholder,
                      style: TextStyle(
                        color: textMuted.withValues(alpha: 0.7),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Future<void> _showSignatureDialog(BuildContext context) async {
    final SignatureController controller = SignatureController(
      penStrokeWidth: 3,
      penColor: Colors.black,
      exportBackgroundColor: Colors.transparent,
    );

    await showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: Colors.white,
        insetPadding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.draw, color: primaryColor, size: 24),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          placeholder.split(' ').first,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          '請在下方區域簽名 Please sign below',
                          style: TextStyle(
                            fontSize: 12,
                            color: textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close, color: textMuted),
                  ),
                ],
              ),
            ),
            
            const Divider(height: 1),

            // Canvas
            Flexible(
              child: Container(
                margin: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: borderColor),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Signature(
                    controller: controller,
                    backgroundColor: const Color(0xFFF8FAFC),
                    height: 300,
                    width: double.infinity,
                  ),
                ),
              ),
            ),

            // Actions
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: Row(
                children: [
                  Expanded(
                    child: TextButton.icon(
                      onPressed: () => controller.clear(),
                      icon: const Icon(Icons.refresh, size: 18),
                      label: const Text('重新簽名 Clear'),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.red.shade400,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: Colors.red.shade100),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        if (controller.isNotEmpty) {
                          final Uint8List? data = await controller.toPngBytes();
                          if (data != null) {
                            onChanged(data);
                          }
                        }
                        if (context.mounted) {
                          Navigator.of(context).pop();
                        }
                      },
                      icon: const Icon(Icons.check, size: 18),
                      label: const Text('確認簽名 Confirm'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
    controller.dispose();
  }
}
