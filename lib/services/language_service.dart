//lib\services\language_service.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageService extends ChangeNotifier {
  static final LanguageService _instance = LanguageService._internal();
  factory LanguageService() => _instance;
  LanguageService._internal();

  Map<String, String> _localizedStrings = {};
  Locale _currentLocale = const Locale('en');

  Locale get currentLocale => _currentLocale;
  bool get isRTL => _currentLocale.languageCode == 'ar';

  String translate(String key) {
    return _localizedStrings[key] ?? key;
  }

  Future<void> loadLanguage(String languageCode) async {
    try {
      String jsonString =
          await rootBundle.loadString('assets/translation/$languageCode.json');
      Map<String, dynamic> jsonMap = json.decode(jsonString);
      _localizedStrings =
          jsonMap.map((key, value) => MapEntry(key, value.toString()));
      _currentLocale = Locale(languageCode);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('selected_language', languageCode);

      notifyListeners();
    } catch (e) {
      print('Error loading language $languageCode: $e');
    }
  }

  Future<void> changeLanguage(String languageCode) async {
    if (_currentLocale.languageCode != languageCode) {
      await loadLanguage(languageCode);
    }
  }

  Future<String> getSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('selected_language') ?? 'en';
  }

  TextDirection get textDirection =>
      isRTL ? TextDirection.rtl : TextDirection.ltr;
}

extension TranslationExtension on String {
  String get tr => LanguageService().translate(this);
}
