import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'maintain/maintain_menu_sheet.dart';
import 'providers/app_navigation_provider.dart';
import 'providers/locale_provider.dart'; // 【新增】引入 LocaleProvider
import 'l10n/app_translations.dart'; // 【新增】引入翻譯

// --- 顏色定義 ---
const lightColor = Color(0xFF83ACA9);
const darkColor = Color(0xFF274C4A);
const navBarBg = Color(0xFFFFFFFF);

class Nav1Page extends StatelessWidget {
  const Nav1Page({super.key});

  @override
  Widget build(BuildContext context) {
    final appNavProvider = context.watch<AppNavigationProvider>();
    final selectedIndex = appNavProvider.selectedIndex;

    // 【新增】取得翻譯和語言狀態
    final t = AppTranslations.of(context);
    final localeProvider = context.watch<LocaleProvider>();

    final List<String> items = <String>[
      t.airportVisit, // '機場出診單' / 'Airport Visit'
      t.emergencyRecord, // '急救紀錄單' / 'Emergency Record'
      t.ambulanceRecord, // '救護車紀錄單' / 'Ambulance Record'
      t.viewReports, // '查看報表' / 'View Reports'
      t.maintenance, // '各式列表維護' / 'List Maintenance'
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: navBarBg,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(items.length, (i) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: _PillButton(
                      label: items[i],
                      active: i == selectedIndex,
                      onTap: () => _handleNavigation(context, i),
                    ),
                  );
                }),
              ),
            ),
          ),
          // 【新增】語言切換按鈕
          const SizedBox(width: 8),
          _LanguageToggleButton(
            isZh: localeProvider.isZh,
            onTap: () async {
              await localeProvider.toggleLocale();
            },
          ),
        ],
      ),
    );
  }

  void _handleNavigation(BuildContext context, int index) {
    final appNavProvider = context.read<AppNavigationProvider>();

    switch (index) {
      case 0: // 機場出診單 (對應 HomePage)
      case 1: // 急救紀錄單 (對應 Home2Page)
      case 2: // 救護車紀錄單 (對應 Home3Page)
      case 3: // 查看報表 (對應 Home4Page)
        appNavProvider.setSelectedIndex(index);
        break;
      case 4: // 各式列表維護
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (_) => const MaintainMenuSheet(),
        );
        break;
      default:
        break;
    }
  }
}

// --- _PillButton 維持不變 ---
class _PillButton extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _PillButton({
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color bg = active ? darkColor : lightColor;
    const Color fg = Colors.white;

    return InkWell(
      borderRadius: BorderRadius.circular(15),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 2,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Text(
          label,
          style: const TextStyle(color: fg, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

// 【新增】語言切換按鈕元件
class _LanguageToggleButton extends StatelessWidget {
  final bool isZh;
  final VoidCallback onTap;

  const _LanguageToggleButton({required this.isZh, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(15),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: darkColor,
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 2,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.language, color: Colors.white, size: 18),
            const SizedBox(width: 6),
            Text(
              isZh ? '中' : 'EN',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
