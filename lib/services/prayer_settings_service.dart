// lib/services/prayer_settings_service.dart
import 'package:flutter/foundation.dart';
import 'package:myfriend_mobile/models/prayer_settings_dto.dart';
import 'package:myfriend_mobile/services/setting_service.dart';

class PrayerSettingsService extends ChangeNotifier {
  static final PrayerSettingsService _instance =
      PrayerSettingsService._internal();
  factory PrayerSettingsService() => _instance;
  PrayerSettingsService._internal();

  final BackendService _backendService = BackendService();
  String? _userId;

  PrayerSettingsDTO _settings = PrayerSettingsDTO(
    prayerStates: {
      'fajr': true,
      'dhuhr': false,
      'asr': false,
      'maghrib': false,
      'isha': true,
    },
    alertSound: 'Default',
    fontSize: 'Medium',
    notificationsEnabled: true,
    timeFormat: '24 Hour',
    reminderTime: '15 min',
  );

  Map<String, bool> get prayerStates => _settings.prayerStates;
  String get selectedAlertSound => _settings.alertSound;
  String get selectedFontSize => _settings.fontSize;
  bool get notificationsEnabled => _settings.notificationsEnabled;
  String get selectedTimeFormat => _settings.timeFormat;
  String get selectedReminderTime => _settings.reminderTime;

  void setUserId(String userId) {
    _userId = userId;
  }

  Future<void> initialize() async {
    if (_userId == null) {
      throw Exception('User ID not set. Call setUserId first.');
    }

    try {
      _settings = await _backendService.getPrayerSettings(_userId!);
      notifyListeners();
    } catch (e) {
      print('Error loading settings from backend: $e');
    }
  }

  Future<void> _saveSettings() async {
    if (_userId == null) return;

    try {
      await _backendService.updatePrayerSettings(_userId!, _settings);
    } catch (e) {
      print('Error saving settings to backend: $e');
      throw e;
    }
  }

  void togglePrayer(String prayerName, bool value) {
    _settings.prayerStates[prayerName] = value;
    _saveSettings();
    notifyListeners();
  }

  void setAlertSound(String sound) {
    _settings.alertSound = sound;
    _saveSettings();
    notifyListeners();
  }

  void setFontSize(String size) {
    _settings.fontSize = size;
    _saveSettings();
    notifyListeners();
  }

  void setNotifications(bool enabled) {
    _settings.notificationsEnabled = enabled;
    _saveSettings();
    notifyListeners();
  }

  void setTimeFormat(String format) {
    _settings.timeFormat = format;
    _saveSettings();
    notifyListeners();
  }

  void setReminderTime(String time) {
    _settings.reminderTime = time;
    _saveSettings();
    notifyListeners();
  }

  bool isPrayerEnabled(String prayerName) {
    return _settings.prayerStates[prayerName] ?? false;
  }

  List<String> getEnabledPrayers() {
    return _settings.prayerStates.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();
  }
}
