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
  
  // Loading state for API calls
  bool _isLoading = false;

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

  // Load medications from API server
  Future<void> _loadMedications() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final loadedMedications = await _medicationService.loadMedications();
      setState(() {
        medications = loadedMedications;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // Show error message to user
      _showErrorSnackBar('failed_to_load_medications_try_again'.tr);
    }
  }

  // Add medication with API call
  void addMedication(Medication medication) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final success = await _medicationService.addMedication(medications, medication);
      
      setState(() {
        _isLoading = false;
      });

      if (success) {
        // Medication was added successfully (already added to local list in service)
        setState(() {}); // Trigger rebuild to show new medication
        _showSuccessSnackBar('medication_added_successfully_message'.tr);
      } else {
        _showErrorSnackBar('failed_to_add_medication_try_again'.tr);
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorSnackBar('network_error_check_connection'.tr);
    }
  }

  // Toggle medication status with API call
  void toggleMedication(int index, bool value) async {
    // Store original value for rollback if needed
    final originalValue = medications[index].isActive;
    
    // Optimistically update UI
    setState(() {
      medications[index].isActive = value;
    });

    try {
      final success = await _medicationService.updateMedicationStatus(medications, index, value);
      
      if (!success) {
        // Rollback if API call failed
        setState(() {
          medications[index].isActive = originalValue;
        });
        _showErrorSnackBar('failed_to_update_medication_status_try_again'.tr);
      }
    } catch (e) {
      // Rollback if network error occurred
      setState(() {
        medications[index].isActive = originalValue;
      });
      _showErrorSnackBar('network_error_check_connection'.tr);
    }
  }

  // Show error message to user
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.red,
        duration: Duration(seconds: 3),
      ),
    );
  }

  // Show success message to user
  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.primary,
        duration: Duration(seconds: 2),
      ),
    );
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
                      // Show loading indicator while API calls are in progress
                      if (_isLoading)
                        Container(
                          padding: EdgeInsets.all(20),
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                          ),
                        ),
                      
                      // Main card with medication reminders and add functionality
                      MedicationCard(
                        medications: medications,
                        onToggle: toggleMedication,
                        onAddMedication: addMedication,
                        isLoading: _isLoading, // Pass loading state to card
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