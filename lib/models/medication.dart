// lib/models/medication.dart
import 'package:flutter/material.dart'; 
import '../services/language_service.dart';

class Medication {
  String name;
  String timeKey; // Translation key
  Map<String, dynamic> timeParams; 
  bool isActive;
  String typeKey; // Reminder type key
  int hours;

  Medication({
    required this.name,
    required this.timeKey,
    required this.timeParams,
    this.isActive = true,
    this.typeKey = "specific_time",
    this.hours = 6,
  });

  // Get translated time text
  String getDisplayTime(LanguageService languageService) {
    if (timeKey == 'every_x_hours_display') {
      return '${languageService.translate('every')} ${timeParams['hours']} ${languageService.translate('hours')}';
    } else if (timeKey == 'specific_time_display') {
      // Get saved time components
      int hour = timeParams['hour'] ?? 9;
      int minute = timeParams['minute'] ?? 0;
      String period = timeParams['period'] ?? 'am';
      int timesPerDay = timeParams['timesPerDay'] ?? 1;
      
      String translatedTime = _formatTimeWithTranslation(hour, minute, period, languageService);
      
      if (timesPerDay > 1) {
        return '$translatedTime (${timesPerDay} ${languageService.translate('times_daily')})';
      } else {
        return translatedTime;
      }
    }
    return timeParams['fallback'] ?? '';
  }

  String _formatTimeWithTranslation(int hour, int minute, String period, LanguageService languageService) {
    String minuteStr = minute.toString().padLeft(2, '0');
    String hourStr = hour.toString().padLeft(2, '0');
    String translatedPeriod = languageService.translate(period);
    
    return '$hourStr:$minuteStr $translatedPeriod';
  }

  // Get translated reminder type
  String getDisplayType(LanguageService languageService) {
    return languageService.translate(typeKey);
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'timeKey': timeKey,
      'timeParams': timeParams,
      'isActive': isActive,
      'typeKey': typeKey,
      'hours': hours,
    };
  }

  factory Medication.fromMap(Map<String, dynamic> map) {
    return Medication(
      name: map['name'],
      timeKey: map['timeKey'] ?? 'specific_time_display',
      timeParams: Map<String, dynamic>.from(map['timeParams'] ?? {}),
      isActive: map['isActive'] ?? true,
      typeKey: map['typeKey'] ?? 'specific_time',
      hours: map['hours'] ?? 6,
    );
  }

  // Helper function to create medication with specific time
  static Medication createSpecificTime({
    required String name,
    required TimeOfDay time, 
    required int timesPerDay,
    bool isActive = true,
  }) {
    return Medication(
      name: name,
      timeKey: 'specific_time_display',
      timeParams: {
        'hour': time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod,
        'minute': time.minute,
        'period': time.period == DayPeriod.am ? 'am' : 'pm',
        'timesPerDay': timesPerDay,
      },
      isActive: isActive,
      typeKey: 'specific_time',
      hours: 6,
    );
  }

  // Helper function to create medication with specific hours interval
  static Medication createEveryXHours({
    required String name,
    required int hours,
    bool isActive = true,
  }) {
    return Medication(
      name: name,
      timeKey: 'every_x_hours_display',
      timeParams: {
        'hours': hours,
      },
      isActive: isActive,
      typeKey: 'every_x_hours',
      hours: hours,
    );
  }
}