// lib/screens/medicine_page.dart
import 'package:flutter/material.dart';
import 'package:myfriend_mobile/services/medicine_service.dart';
import 'package:myfriend_mobile/widgets/midication_card.dart';
import 'package:myfriend_mobile/utils/app_font.dart';
import 'package:myfriend_mobile/utils/colors.dart';
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
        backgroundColor: AppColors.mainBg,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    children: [
                      Text(
                        'settings'.tr,
                        style: _getFontSize() == 14
                            ? AppFonts.lgBold(
                                context,
                                color: AppColors.primary,
                              )
                            : _getFontSize() == 16
                            ? AppFonts.xlBold(
                                context,
                                color: AppColors.primary,
                              )
                            : AppFonts.xlBold(
                                context,
                                color: AppColors.primary,
                              ).copyWith(fontSize: 22),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'medicine_reminder'.tr,
                        style: _getFontSize() == 14
                            ? AppFonts.smRegular(
                                context,
                                color: AppColors.secondery,
                              )
                            : _getFontSize() == 16
                            ? AppFonts.mdRegular(
                                context,
                                color: AppColors.secondery,
                              )
                            : AppFonts.lgRegular(
                                context,
                                color: AppColors.secondery,
                              ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // Main card with medication reminders and add functionality
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
                              color: AppColors.primary,
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
                            style: _getFontSize() == 14
                                ? AppFonts.mdSemiBold(
                                    context,
                                    color: AppColors.primary,
                                  )
                                : _getFontSize() == 16
                                ? AppFonts.lgSemiBold(
                                    context,
                                    color: AppColors.primary,
                                  )
                                : AppFonts.xlSemiBold(
                                    context,
                                    color: AppColors.primary,
                                  ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}