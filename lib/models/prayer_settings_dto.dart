// lib/models/prayer_settings_dto.dart
class PrayerSettingsDTO {
  Map<String, bool> prayerStates;
  String alertSound;
  String fontSize;
  bool notificationsEnabled;
  String timeFormat;
  String reminderTime;

  PrayerSettingsDTO({
    required this.prayerStates,
    required this.alertSound,
    required this.fontSize,
    required this.notificationsEnabled,
    required this.timeFormat,
    required this.reminderTime,
  });

  factory PrayerSettingsDTO.fromJson(Map<String, dynamic> json) {
    return PrayerSettingsDTO(
      prayerStates: Map<String, bool>.from(json['prayerStates']),
      alertSound: json['alertSound'],
      fontSize: json['fontSize'],
      notificationsEnabled: json['notificationsEnabled'],
      timeFormat: json['timeFormat'],
      reminderTime: json['reminderTime'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'prayerStates': prayerStates,
      'alertSound': alertSound,
      'fontSize': fontSize,
      'notificationsEnabled': notificationsEnabled,
      'timeFormat': timeFormat,
      'reminderTime': reminderTime,
    };
  }
}
