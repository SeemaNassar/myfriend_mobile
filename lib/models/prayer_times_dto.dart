// lib/models/prayer_times_dto.dart
class PrayerTimesDTO {
  final Map<String, String> times;
  final String date;

  PrayerTimesDTO({required this.times, required this.date});

  factory PrayerTimesDTO.fromJson(Map<String, dynamic> json) {
    return PrayerTimesDTO(
      times: Map<String, String>.from(json['times']),
      date: json['date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'times': times, 'date': date};
  }
}
