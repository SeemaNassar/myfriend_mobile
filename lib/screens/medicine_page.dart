// lib/screens/medicine_page.dart
import 'package:flutter/material.dart';
import 'package:myfriend_mobile/services/medicine_service.dart';
import 'package:myfriend_mobile/widgets/midication_card.dart';
import '../models/medication.dart';
import '../services/language_service.dart';
import '../services/prayer_settings_service.dart';

class MedicationListScreen extends StatefulWidget {
  const MedicationListScreen({Key? key}) : super(key: key);

  @override
  _MedicationListScreenState createState() => _MedicationListScreenState();
}

class _MedicationListScreenState extends State<MedicationListScreen> {
  List<Medication> medications = [];
  final MedicationService _medicationService = MedicationService();
  final LanguageService _languageService = LanguageService();
  final PrayerSettingsService _prayerSettingsService = PrayerSettingsService();

  @override
  void initState() {
    super.initState();
    _languageService.addListener(_onLanguageChanged);
    _prayerSettingsService.addListener(_onSettingsChanged);
    _loadMedications();
  }

  @override
  void dispose() {
    _languageService.removeListener(_onLanguageChanged);
    _prayerSettingsService.removeListener(_onSettingsChanged);
    super.dispose();
  }

  void _onLanguageChanged() {
    setState(() {});
  }

  void _onSettingsChanged() {
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

  double _getFontSize() {
    switch (_prayerSettingsService.selectedFontSize) {
      case 'Small':
        return 14;
      case 'Medium':
        return 16;
      case 'Large':
        return 18;
      default:
        return 16;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isRTL = _languageService.isRTL;
    print('isRTL value: $isRTL');

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
              SizedBox(height: 5),
              Text(
                'settings'.tr,
                style: TextStyle(
                  color: Color(0xFF4A7C59),
                  fontSize: _getFontSize() + 8,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5),
              Text(
                'medicine_reminder'.tr,
                style: TextStyle(
                  color: Color(0xFF8B4513),
                  fontSize: _getFontSize(),
                ),
              ),
              SizedBox(height: 5),
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
                          Container(
                            width: 32,
                            height: 32,
                            decoration: const BoxDecoration(
                              color: Color(0xFF4A7C59),
                              shape: BoxShape.circle,
                            ),
                            child: const Center(
                              child: Text(
                                '🌙',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'صديقي',
                            style: TextStyle(
                              fontSize: _getFontSize(),
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF4A7C59),
                            ),
                          ),

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