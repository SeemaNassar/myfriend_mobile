// lib/services/prayer_times_service.dart
import 'package:flutter/foundation.dart';
import 'package:myfriend_mobile/models/prayer_times_dto.dart';
import 'package:myfriend_mobile/services/setting_service.dart';

class PrayerTimesService extends ChangeNotifier {
  static final PrayerTimesService _instance = PrayerTimesService._internal();
  factory PrayerTimesService() => _instance;
  PrayerTimesService._internal();

  final BackendService _backendService = BackendService();
  String? _userId;

  PrayerTimesDTO _prayerTimes = PrayerTimesDTO(
    times: {
      'fajr': '06:45',
      'dhuhr': '12:15',
      'asr': '15:30',
      'maghrib': '18:45',
      'isha': '20:00',
    },
    date: '',
  );

  Map<String, String> get prayerTimes => _prayerTimes.times;
  String get prayerDate => _prayerTimes.date;

  void setUserId(String userId) {
    _userId = userId;
  }

  Future<void> loadPrayerTimes() async {
    if (_userId == null) {
      throw Exception('User ID not set. Call setUserId first.');
    }

    try {
      _prayerTimes = await _backendService.getPrayerTimes(_userId!);
      notifyListeners();
    } catch (e) {
      print('Error loading prayer times from backend: $e');
    }
  }
}
