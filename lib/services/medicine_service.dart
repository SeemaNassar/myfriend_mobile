//lib/services/medicine_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/medication.dart';
import '../services/language_service.dart';

class MedicationService {
  // Base URL for the API
  static const String _baseUrl = 'https://your-api-server.com/api';
  static const String _medicationsEndpoint = '/medications';
  
  // Headers for API requests
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
        return medicationsList.map((item) => Medication.fromMap(item)).toList();
      } else {
        print('failed_to_load_medications'.tr + '${response.statusCode}');
        // Return default medications if API fails
        return _getDefaultMedications();
      }
    } catch (e) {
      print('error_loading_medications'.tr + '$e');
      // Return default medications if network error occurs
      return _getDefaultMedications();
    }
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
        // Add to local list only if server request succeeded
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

      // Assuming each medication has a unique identifier
      final response = await http.patch(
        Uri.parse('$_baseUrl$_medicationsEndpoint/${medication.name}'), // Using name as ID
        headers: _headers,
        body: body,
      );

      if (response.statusCode == 200) {
        // Update local list only if server request succeeded
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
  
  // Default medications for testing and fallback
  List<Medication> _getDefaultMedications() {
    return [
      Medication(
        name: 'Paracetamol',
        time: '09:00 AM',
        isActive: true,
        type: 'specific_time',
        hours: 8,
      ),
      Medication(
        name: 'Vitamin D',
        time: 'every 12 hours',
        isActive: true,
        type: 'every_x_hours',
        hours: 12,
      ),
      Medication(
        name: 'Iron Supplement',
        time: '02:00 PM (2 times daily)',
        isActive: false,
        type: 'specific_time',
        hours: 6,
      ),
      Medication(
        name: 'Blood Pressure Medicine',
        time: 'every 6 hours',
        isActive: true,
        type: 'every_x_hours',
        hours: 6,
      ),
    ];
  }

}