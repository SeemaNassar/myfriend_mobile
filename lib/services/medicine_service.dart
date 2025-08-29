import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/medication.dart';

class MedicationService {
  static const String _medicationsKey = 'medications';

  // Load medications from shared preferences
  Future<List<Medication>> loadMedications() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final medicationsJson = prefs.getString(_medicationsKey);

      if (medicationsJson != null) {
        final List<dynamic> medicationsList = json.decode(medicationsJson);
        return medicationsList.map((item) => Medication.fromMap(item)).toList();
      }
      return [];
    } catch (e) {
      print('Error loading medications: $e');
      return [];
    }
  }

  // Save medications to shared preferences
  Future<void> saveMedications(List<Medication> medications) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final medicationsJson =
          json.encode(medications.map((med) => med.toMap()).toList());
      await prefs.setString(_medicationsKey, medicationsJson);
    } catch (e) {
      print('Error saving medications: $e');
    }
  }

  // Clear all medications
  Future<void> clearAllMedications() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_medicationsKey);
    } catch (e) {
      print('Error clearing medications: $e');
    }
  }

  // Add a single medication
  Future<void> addMedication(
      List<Medication> medications, Medication newMedication) async {
    medications.add(newMedication);
    await saveMedications(medications);
  }

  // Update medication status
  Future<void> updateMedicationStatus(
      List<Medication> medications, int index, bool isActive) async {
    if (index >= 0 && index < medications.length) {
      medications[index].isActive = isActive;
      await saveMedications(medications);
    }
  }
}
