// lib/screens/medicine_page.dart
import 'package:flutter/material.dart';
import 'package:myfriend_mobile/services/medicine_service.dart';
import 'package:myfriend_mobile/widgets/midication_card.dart';
import '../models/medication.dart';
import '../services/language_service.dart';

class MedicationListScreen extends StatefulWidget {
  const MedicationListScreen({Key? key}) : super(key: key);

  @override
  _MedicationListScreenState createState() => _MedicationListScreenState();
}

class _MedicationListScreenState extends State<MedicationListScreen> {
  List<Medication> medications = [];
  final MedicationService _medicationService = MedicationService();
  final LanguageService _languageService = LanguageService();

  @override
  void initState() {
    super.initState();
    _languageService.addListener(_onLanguageChanged);
    _loadMedications();
  }

  @override
  void dispose() {
    _languageService.removeListener(_onLanguageChanged);
    super.dispose();
  }

  void _onLanguageChanged() {
    setState(() {});
  }

  // Load medications from service
  Future<void> _loadMedications() async {
    final loadedMedications = await _medicationService.loadMedications();
    setState(() {
      medications = loadedMedications;
    });
  }

  void addMedication(Medication medication) async {
    await _medicationService.addMedication(medications, medication);
    setState(() {}); // Trigger rebuild
  }

  void toggleMedication(int index, bool value) async {
    await _medicationService.updateMedicationStatus(medications, index, value);
    setState(() {}); // Trigger rebuild
  }

  @override
  Widget build(BuildContext context) {
    final isRTL = _languageService.isRTL;

    return Directionality(
      textDirection: _languageService.textDirection,
      child: Scaffold(
        backgroundColor: Color(0xFFF5F5DC),
        appBar: AppBar(
          backgroundColor: Color(0xFFF5F5DC),
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              isRTL ? Icons.arrow_forward : Icons.arrow_back,
              color: Color(0xFF4A7C59),
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: Column(
            children: [
              Text(
                'settings'.tr,
                style: TextStyle(
                  color: Color(0xFF4A7C59),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 7),
              Text(
                'medicine_reminder'.tr,
                style: TextStyle(
                  color: Color(0xFF8B4513),
                  fontSize: 16,
                ),
              ),
            ],
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Main card with medication reminders and add functionality
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      MedicationCard(
                        medications: medications,
                        onToggle: toggleMedication,
                        onAddMedication: addMedication,
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Order based on language direction
                          if (isRTL) ...[
                            Text(
                              'my_friend'.tr,
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF4A7C59),
                              ),
                            ),
                            SizedBox(width: 10),
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Color(0xFF4A7C59),
                                shape: BoxShape.circle,
                              ),
                              child: Transform.scale(
                                scaleX: 1, // Keep moon facing right for Arabic
                                child: Icon(Icons.nightlight_round,
                                    color: Colors.yellow, size: 24),
                              ),
                            ),
                          ] else ...[
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Color(0xFF4A7C59),
                                shape: BoxShape.circle,
                              ),
                              child: Transform.scale(
                                scaleX:
                                    -1, // Flip moon for English (facing left)
                                child: Icon(Icons.nightlight_round,
                                    color: Colors.yellow, size: 24),
                              ),
                            ),
                            SizedBox(width: 10),
                            Text(
                              'my_friend'.tr,
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF4A7C59),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
