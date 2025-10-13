// lib/providers/locale_provider.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('zh', 'TW'); // 預設繁體中文

  Locale get locale => _locale;
  bool get isZh => _locale.languageCode == 'zh';
  bool get isEn => _locale.languageCode == 'en';

  // 初始化時從本地儲存讀取語言設定
  Future<void> loadLocale() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final languageCode = prefs.getString('languageCode') ?? 'zh';
      final countryCode = prefs.getString('countryCode') ?? 'TW';
      _locale = Locale(languageCode, countryCode);
      notifyListeners();
    } catch (e) {
      debugPrint('載入語言設定失敗: $e');
    }
  }

  // 切換語言
  Future<void> setLocale(Locale locale) async {
    if (_locale == locale) return;

    _locale = locale;
    notifyListeners();

    // 儲存到本地
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('languageCode', locale.languageCode);
      await prefs.setString('countryCode', locale.countryCode ?? '');
    } catch (e) {
      debugPrint('儲存語言設定失敗: $e');
    }
  }

  // 切換到中文
  Future<void> setChineseTW() async {
    await setLocale(const Locale('zh', 'TW'));
  }

  // 切換到英文
  Future<void> setEnglish() async {
    await setLocale(const Locale('en', 'US'));
  }

  // 切換語言（中英互換）
  Future<void> toggleLocale() async {
    if (isZh) {
      await setEnglish();
    } else {
      await setChineseTW();
    }
  }
}
