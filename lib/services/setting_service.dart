// lib/services/backend_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:myfriend_mobile/models/prayer_settings_dto.dart';
import 'package:myfriend_mobile/models/prayer_times_dto.dart';

class BackendService {
  static const String baseUrl = '';
  static final BackendService _instance = BackendService._internal();

  factory BackendService() => _instance;
  BackendService._internal();

  Future<PrayerSettingsDTO> getPrayerSettings(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/users/$userId/settings'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return PrayerSettingsDTO.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load prayer settings');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<void> updatePrayerSettings(
    String userId,
    PrayerSettingsDTO settings,
  ) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/users/$userId/settings'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(settings.toJson()),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update prayer settings');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<PrayerTimesDTO> getPrayerTimes(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/users/$userId/prayer-times'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return PrayerTimesDTO.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load prayer times');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
