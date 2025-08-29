// lib/services/prayer_settings_service.dart
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrayerSettingsService extends ChangeNotifier {
  static final PrayerSettingsService _instance =
      PrayerSettingsService._internal();
  factory PrayerSettingsService() => _instance;
  PrayerSettingsService._internal();

  static const String _prayerStatesKey = 'prayer_states';
  static const String _alertSoundKey = 'alert_sound';
  static const String _fontSizeKey = 'font_size';
  static const String _notificationsKey = 'notifications';
  static const String _timeFormatKey = 'time_format';
  static const String _reminderTimeKey = 'reminder_time';

  Map<String, bool> _prayerStates = {
    'fajr': true,
    'dhuhr': false,
    'asr': false,
    'maghrib': false,
    'isha': true,
  };

  String _selectedAlertSound = 'Default';
  String _selectedFontSize = 'Medium';
  bool _notificationsEnabled = true;
  String _selectedTimeFormat = '24 Hour';
  String _selectedReminderTime = '15 min';

  Map<String, bool> get prayerStates => Map.unmodifiable(_prayerStates);
  String get selectedAlertSound => _selectedAlertSound;
  String get selectedFontSize => _selectedFontSize;
  bool get notificationsEnabled => _notificationsEnabled;
  String get selectedTimeFormat => _selectedTimeFormat;
  String get selectedReminderTime => _selectedReminderTime;

  Future<void> initialize() async {
    await _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final prayerStatesJson = prefs.getString(_prayerStatesKey);
      if (prayerStatesJson != null) {
        final Map<String, dynamic> loadedStates =
            Map<String, dynamic>.from(json.decode(prayerStatesJson));
        _prayerStates =
            loadedStates.map((key, value) => MapEntry(key, value as bool));
      }

      _selectedAlertSound = prefs.getString(_alertSoundKey) ?? 'Default';
      _selectedFontSize = prefs.getString(_fontSizeKey) ?? 'Medium';
      _notificationsEnabled = prefs.getBool(_notificationsKey) ?? true;
      _selectedTimeFormat = prefs.getString(_timeFormatKey) ?? '24 Hour';
      _selectedReminderTime = prefs.getString(_reminderTimeKey) ?? '15 min';

      notifyListeners();
    } catch (e) {
      print('Error loading settings: $e');
    }
  }

  Future<void> _saveSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      await prefs.setString(_prayerStatesKey, json.encode(_prayerStates));
      await prefs.setString(_alertSoundKey, _selectedAlertSound);
      await prefs.setString(_fontSizeKey, _selectedFontSize);
      await prefs.setBool(_notificationsKey, _notificationsEnabled);
      await prefs.setString(_timeFormatKey, _selectedTimeFormat);
      await prefs.setString(_reminderTimeKey, _selectedReminderTime);
    } catch (e) {
      print('Error saving settings: $e');
    }
  }

  void togglePrayer(String prayerName, bool value) {
    _prayerStates[prayerName] = value;
    _saveSettings();
    notifyListeners();
    print('$prayerName reminder ${value ? 'enabled' : 'disabled'}');
  }

  void setAlertSound(String sound) {
    _selectedAlertSound = sound;
    _saveSettings();
    notifyListeners();
  }

  void setFontSize(String size) {
    _selectedFontSize = size;
    _saveSettings();
    notifyListeners();
  }

  void setNotifications(bool enabled) {
    _notificationsEnabled = enabled;
    _saveSettings();
    notifyListeners();
  }

  void setTimeFormat(String format) {
    _selectedTimeFormat = format;
    _saveSettings();
    notifyListeners();
  }

  void setReminderTime(String time) {
    _selectedReminderTime = time;
    _saveSettings();
    notifyListeners();
  }

  bool isPrayerEnabled(String prayerName) {
    return _prayerStates[prayerName] ?? false;
  }

  List<String> getEnabledPrayers() {
    return _prayerStates.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();
  }
}
