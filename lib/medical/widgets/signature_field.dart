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
    return GestureDetector(
      onTap: onTap ?? () => _showSignatureDialog(context),
      child: Container(
        height: height,
        width: double.infinity,
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(color: borderColor, style: BorderStyle.solid),
          borderRadius: BorderRadius.circular(8),
        ),
        child: value != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.memory(
                  value!,
                  fit: BoxFit.contain,
                  width: double.infinity,
                ),
              )
            : Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.draw_outlined,
                      size: 18,
                      color: textMuted.withValues(alpha: 0.5),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      placeholder,
                      style: TextStyle(
                        color: textMuted.withValues(alpha: 0.5),
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
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
      builder: (context) => AlertDialog(
        title: Text(placeholder.split(' ').first), // Use first part of placeholder as title
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 500,
              height: 300,
              decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
              child: Signature(
                controller: controller,
                backgroundColor: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '請在上方區域簽名',
              style: TextStyle(color: textMuted, fontSize: 12),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => controller.clear(),
            child: const Text('清除 Clear', style: TextStyle(color: Colors.red)),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消 Cancel'),
          ),
          ElevatedButton(
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
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('確認 Confirm'),
          ),
        ],
      ),
    );
    controller.dispose();
  }
}
