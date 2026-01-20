import 'package:flutter/material.dart';
import 'widgets/medical_header.dart';
import 'pages/personal_info.dart';

class MedicalPage extends StatelessWidget {
  const MedicalPage({super.key});

  static const Color bgLight = Color(0xFFF6F8FA);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgLight,
      body: SafeArea(
        child: Column(
          children: [
            const MedicalHeader(),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 32,
                ),
                child: Column(
                  children: const [
                    PersonalInfo(), // 直接呼叫此組件
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
