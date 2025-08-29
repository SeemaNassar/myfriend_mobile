// lib/models/medication.dart
class Medication {
  String name;
  String time;
  bool isActive;
  String type;
  int hours;

  Medication({
    required this.name,
    required this.time,
    this.isActive = true,
    this.type = "وقت محدد",
    this.hours = 6,
  });

  // Convert Medication to Map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'time': time,
      'isActive': isActive,
      'type': type,
      'hours': hours,
    };
  }

  // Create Medication from Map
  factory Medication.fromMap(Map<String, dynamic> map) {
    return Medication(
      name: map['name'],
      time: map['time'],
      isActive: map['isActive'],
      type: map['type'],
      hours: map['hours'],
    );
  }
}
