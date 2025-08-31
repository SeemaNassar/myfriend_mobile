//lib/services/medicine_service.dart
import 'dart:convert';
import 'package:flutter/material.dart'; 
import 'package:http/http.dart' as http;
import '../models/medication.dart';
import '../services/language_service.dart';

class MedicationService {
  // Base URL for the API
  static const String _baseUrl = 'https://your-api-server.com/api';
  static const String _medicationsEndpoint = '/medications';
  
  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Load medications from API server
  Future<List<Medication>> loadMedications() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl$_medicationsEndpoint'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> medicationsList = responseData['data'] ?? [];
        return medicationsList.map((item) => _convertLegacyData(item)).toList();
      } else {
        print('failed_to_load_medications'.tr + '${response.statusCode}');
        return _getDefaultMedications();
      }
    } catch (e) {
      print('error_loading_medications'.tr + '$e');
      return _getDefaultMedications();
    }
  }

  // Convert legacy data to the new model
  Medication _convertLegacyData(Map<String, dynamic> item) {
    // If data contains new keys, use them directly
    if (item.containsKey('timeKey') && item.containsKey('timeParams')) {
      return Medication.fromMap(item);
    }
    
    // Convert legacy data
    String oldTime = item['time'] ?? '';
    String type = item['type'] ?? 'specific_time';
    
    if (type == 'every_x_hours' || oldTime.contains('every') || oldTime.contains('كل')) {
      // Extract hours count from text
      int hours = item['hours'] ?? 6;
      return Medication.createEveryXHours(
        name: item['name'],
        hours: hours,
        isActive: item['isActive'] ?? true,
      );
    } else {
      // Determine frequency from text
      int timesPerDay = 1;
      String timeText = oldTime;
      
      if (oldTime.contains('times daily') || oldTime.contains('مرات يوميا')) {
        RegExp regExp = RegExp(r'\((\d+)');
        Match? match = regExp.firstMatch(oldTime);
        if (match != null) {
          timesPerDay = int.tryParse(match.group(1) ?? '1') ?? 1;
        }
        timeText = oldTime.split('(')[0].trim();
      }
      
      // Extract time components from text
      TimeOfDay parsedTime = _parseTimeString(timeText);
      
      return Medication.createSpecificTime(
        name: item['name'],
        time: parsedTime,
        timesPerDay: timesPerDay,
        isActive: item['isActive'] ?? true,
      );
    }
  }

  // Function to parse time text and convert to TimeOfDay
  TimeOfDay _parseTimeString(String timeText) {
    timeText = timeText.trim();
    
    // Search for time pattern (e.g., "2:30 PM", "2:30PM", or "14:30")
    RegExp timeRegex = RegExp(r'(\d{1,2}):(\d{2})\s*(AM|PM|am|pm|ص|م)?');
    Match? match = timeRegex.firstMatch(timeText);
    
    if (match != null) {
      int hour = int.tryParse(match.group(1) ?? '9') ?? 9;
      int minute = int.tryParse(match.group(2) ?? '0') ?? 0;
      String? period = match.group(3);
      
      // Convert to 24-hour format if necessary
      if (period != null) {
        period = period.toLowerCase();
        if ((period == 'pm' || period == 'م') && hour != 12) {
          hour += 12;
        } else if ((period == 'am' || period == 'ص') && hour == 12) {
          hour = 0;
        }
      }
      
      return TimeOfDay(hour: hour, minute: minute);
    }
    
    // Default value if text cannot be parsed
    return TimeOfDay(hour: 9, minute: 0);
  }

  // Save all medications to API server
  Future<bool> saveMedications(List<Medication> medications) async {
    try {
      final body = json.encode({
        'medications': medications.map((med) => med.toMap()).toList(),
      });

      final response = await http.put(
        Uri.parse('$_baseUrl$_medicationsEndpoint'),
        headers: _headers,
        body: body,
      );

      if (response.statusCode == 200) {
        print('medications_saved_successfully'.tr);
        return true;
      } else {
        print('failed_to_save_medications'.tr + '${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('error_saving_medications'.tr + '$e');
      return false;
    }
  }

  // Add a single medication to server
  Future<bool> addMedication(List<Medication> medications, Medication newMedication) async {
    try {
      final body = json.encode(newMedication.toMap());

      final response = await http.post(
        Uri.parse('$_baseUrl$_medicationsEndpoint'),
        headers: _headers,
        body: body,
      );

      if (response.statusCode == 201) {
        medications.add(newMedication);
        print('medication_added_successfully'.tr);
        return true;
      } else {
        print('failed_to_add_medication'.tr + '${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('error_adding_medication'.tr + '$e');
      return false;
    }
  }

  // Update medication status on server
  Future<bool> updateMedicationStatus(List<Medication> medications, int index, bool isActive) async {
    if (index < 0 || index >= medications.length) {
      print('invalid_medication_index'.tr);
      return false;
    }

    try {
      final medication = medications[index];
      final body = json.encode({
        'isActive': isActive,
      });

      final response = await http.patch(
        Uri.parse('$_baseUrl$_medicationsEndpoint/${medication.name}'),
        headers: _headers,
        body: body,
      );

      if (response.statusCode == 200) {
        medications[index].isActive = isActive;
        print('medication_status_updated_successfully'.tr);
        return true;
      } else {
        print('failed_to_update_medication_status'.tr + '${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('error_updating_medication_status'.tr + '$e');
      return false;
    }
  }
  
  // Default medications with new structure
  List<Medication> _getDefaultMedications() {
    return [
      Medication.createSpecificTime(
        name: 'Paracetamol',
        time: TimeOfDay(hour: 9, minute: 0),
        timesPerDay: 1,
        isActive: true,
      ),
      Medication.createEveryXHours(
        name: 'Vitamin D',
        hours: 12,
        isActive: true,
      ),
      Medication.createSpecificTime(
        name: 'Iron Supplement',
        time: TimeOfDay(hour: 14, minute: 0), 
        timesPerDay: 2,
        isActive: false,
      ),
      Medication.createEveryXHours(
        name: 'Blood Pressure Medicine',
        hours: 6,
        isActive: true,
      ),
    ];
  }
}