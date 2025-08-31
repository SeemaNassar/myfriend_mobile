// lib/widgets/medication_card.dart
import 'package:flutter/material.dart';
import 'package:myfriend_mobile/utils/app_font.dart';
import 'package:myfriend_mobile/utils/colors.dart';
import 'package:myfriend_mobile/widgets/custom_timw_picker.dart';
import '../models/medication.dart';
import '../services/language_service.dart';
import '../services/prayer_settings_service.dart';
import '../widgets/custom_switch.dart';
import '../widgets/selection_button.dart';
import '../widgets/page_box.dart';
import 'package:dashed_rect/dashed_rect.dart';

class MedicationCard extends StatefulWidget {
  final List<Medication> medications;
  final Function(int, bool) onToggle;
  final Function(Medication) onAddMedication;

  const MedicationCard({
    Key? key,
    required this.medications,
    required this.onToggle,
    required this.onAddMedication,
  }) : super(key: key);

  @override
  _MedicationCardState createState() => _MedicationCardState();
}

class _MedicationCardState extends State<MedicationCard>
    with SingleTickerProviderStateMixin {
  final LanguageService _languageService = LanguageService();
  final PrayerSettingsService _prayerSettingsService = PrayerSettingsService();
  bool _isExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;

  String selectedReminderType = 'specific_time';
  int selectedTimesPerDay = 1;
  int selectedHours = 6;
  TimeOfDay selectedTime = TimeOfDay(hour: 9, minute: 0);
  TextEditingController medicineNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _languageService.addListener(_onLanguageChanged);
    _prayerSettingsService.addListener(_onSettingsChanged);
  }

  @override
  void dispose() {
    _animationController.dispose();
    medicineNameController.dispose();
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

  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();

        medicineNameController.clear();
        selectedReminderType = 'specific_time';
        selectedTimesPerDay = 1;
        selectedHours = 6;
        selectedTime = TimeOfDay(hour: 9, minute: 0);
      }
    });
  }

  String _formatTimeOfDay(TimeOfDay time) {
    final hour = time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'am'.tr : 'pm'.tr;
    final displayHour = hour == 0 ? 12 : hour;
    return '${displayHour.toString().padLeft(2, '0')}:${minute} ${period}';
  }

  void _showTimePicker() {
    showDialog(
      context: context,
      barrierColor: AppColors.black.withOpacity(0.4),
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.all(20),
          child: CustomTimePicker(
            initialTime: selectedTime,
            onTimeChanged: (time) {
              setState(() {
                selectedTime = time;
              });
            },
          ),
        );
      },
    );
  }

  void _addMedication() {
    if (medicineNameController.text.isNotEmpty) {
      String timeDisplay;
      if (selectedReminderType == 'every_x_hours') {
        timeDisplay = 'every'.tr + ' ${selectedHours} ' + 'hours'.tr;
      } else {
        if (selectedTimesPerDay > 1) {
          timeDisplay =
              '${_formatTimeOfDay(selectedTime)} (${selectedTimesPerDay} ' +
                  'times_daily'.tr +
                  ')';
        } else {
          timeDisplay = _formatTimeOfDay(selectedTime);
        }
      }

      Medication newMedication = Medication(
        name: medicineNameController.text,
        time: timeDisplay,
        isActive: true,
        type: selectedReminderType,
        hours: selectedHours,
      );

      widget.onAddMedication(newMedication);
      _toggleExpansion();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('please_enter_medicine_name'.tr),
          backgroundColor: AppColors.red,
        ),
      );
    }
  }

  Widget _buildMedicationItem(int index, Medication medication) {
    final isRTL = _languageService.isRTL;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: Row(
        children: [
          if (isRTL) ...[
            CustomSwitch(
              initialValue: medication.isActive,
              onChanged: (value) {
                widget.onToggle(index, value);
              },
              activeColor: AppColors.primary,
              inactiveColor: AppColors.dividerLine,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    medication.name,
                    style: _getFontSize() == 14
                        ? AppFonts.smMedium(
                            context,
                            color: AppColors.secondery,
                          )
                        : _getFontSize() == 16
                        ? AppFonts.mdMedium(
                            context,
                            color: AppColors.secondery,
                          )
                        : AppFonts.lgMedium(
                            context,
                            color: AppColors.secondery,
                          ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    medication.time,
                    style: _getFontSize() == 14
                        ? AppFonts.xsRegular(
                            context,
                            color: AppColors.secondery.withOpacity(0.7),
                          )
                        : _getFontSize() == 16
                        ? AppFonts.smRegular(
                            context,
                            color: AppColors.secondery.withOpacity(0.7),
                          )
                        : AppFonts.mdRegular(
                            context,
                            color: AppColors.secondery.withOpacity(0.7),
                          ),
                  ),
                ],
              ),
            ),
          ] else ...[
            CustomSwitch(
              initialValue: medication.isActive,
              onChanged: (value) {
                widget.onToggle(index, value);
              },
              activeColor: AppColors.primary,
              inactiveColor: AppColors.dividerLine,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    medication.name,
                    style: _getFontSize() == 14
                        ? AppFonts.smMedium(
                            context,
                            color: AppColors.secondery,
                          )
                        : _getFontSize() == 16
                        ? AppFonts.mdMedium(
                            context,
                            color: AppColors.secondery,
                          )
                        : AppFonts.lgMedium(
                            context,
                            color: AppColors.secondery,
                          ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    medication.time,
                    style: _getFontSize() == 14
                        ? AppFonts.xsRegular(
                            context,
                            color: AppColors.secondery.withOpacity(0.7),
                          )
                        : _getFontSize() == 16
                        ? AppFonts.smRegular(
                            context,
                            color: AppColors.secondery.withOpacity(0.7),
                          )
                        : AppFonts.mdRegular(
                            context,
                            color: AppColors.secondery.withOpacity(0.7),
                          ),
                  ),
                ],
              ),
            ),
          ]
        ],
      ),
    );
  }

Widget _buildAddMedicationForm() {
  final isRTL = _languageService.isRTL;

  return Container(
    decoration: BoxDecoration( 
      border: Border.all(
        color: AppColors.primary.withOpacity(0.3),
        width: 1.5,
      ),
      borderRadius: BorderRadius.circular(8),
    ),
    margin: const EdgeInsets.all(8), 
    child: Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment:
        isRTL ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          // Medicine name field - تم إصلاح البوردر
          Container(
            width: double.infinity,
            child: TextField(
              controller: medicineNameController,
              textAlign: isRTL ? TextAlign.right : TextAlign.left,
              style: _getFontSize() == 14
                  ? AppFonts.smRegular(context, color: AppColors.primary)
                  : _getFontSize() == 16
                  ? AppFonts.mdRegular(context, color: AppColors.primary)
                  : AppFonts.lgRegular(context, color: AppColors.primary),
              decoration: InputDecoration(
                hintText: 'medicine_name'.tr,
                hintStyle: _getFontSize() == 14
                    ? AppFonts.smRegular(
                        context,
                        color: AppColors.secondery.withOpacity(0.5),
                      )
                    : _getFontSize() == 16
                    ? AppFonts.mdRegular(
                        context,
                        color: AppColors.secondery.withOpacity(0.5),
                      )
                    : AppFonts.lgRegular(
                        context,
                        color: AppColors.secondery.withOpacity(0.5),
                      ),
                // إصلاح البوردر هنا
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: AppColors.primary.withOpacity(0.3),
                    width: 1.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: AppColors.primary,
                    width: 1.0,
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: AppColors.primary.withOpacity(0.3),
                    width: 1.0,
                  ),
                ),
                contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ),
          const SizedBox(height: 20),

            // Reminder type section
            Text(
              'reminder_type'.tr,
              style: _getFontSize() == 14
                  ? AppFonts.smSemiBold(
                context,
                color: AppColors.primary,
              )
                  : _getFontSize() == 16
                  ? AppFonts.mdSemiBold(
                context,
                color: AppColors.primary,
              )
                  : AppFonts.lgSemiBold(
                context,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: SelectionButton(
                    text: 'every_x_hours'.tr,
                    isSelected: selectedReminderType == 'every_x_hours',
                    onTap: () {
                      setState(() {
                        selectedReminderType = 'every_x_hours';
                      });
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: SelectionButton(
                    text: 'specific_time'.tr,
                    isSelected: selectedReminderType == 'specific_time',
                    onTap: () {
                      setState(() {
                        selectedReminderType = 'specific_time';
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Conditional content based on reminder type
            if (selectedReminderType == 'specific_time') ...[
              // Time selection
              GestureDetector(
                onTap: _showTimePicker,
                child: Container(
                  width: double.infinity,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _formatTimeOfDay(selectedTime),
                    textAlign: TextAlign.center,
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
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Times per day section
              Text(
                'times_per_day'.tr,
                style: _getFontSize() == 14
                    ? AppFonts.smSemiBold(
                  context,
                  color: AppColors.primary,
                )
                    : _getFontSize() == 16
                    ? AppFonts.mdSemiBold(
                  context,
                  color: AppColors.primary,
                )
                    : AppFonts.lgSemiBold(
                  context,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: SelectionButton(
                      text: '4',
                      isSelected: selectedTimesPerDay == 4,
                      onTap: () {
                        setState(() {
                          selectedTimesPerDay = 4;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: SelectionButton(
                      text: '3',
                      isSelected: selectedTimesPerDay == 3,
                      onTap: () {
                        setState(() {
                          selectedTimesPerDay = 3;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: SelectionButton(
                      text: '2',
                      isSelected: selectedTimesPerDay == 2,
                      onTap: () {
                        setState(() {
                          selectedTimesPerDay = 2;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: SelectionButton(
                      text: '1',
                      isSelected: selectedTimesPerDay == 1,
                      onTap: () {
                        setState(() {
                          selectedTimesPerDay = 1;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ] else ...[
              // Hours selection for "every X hours"
              Text(
                'every_how_many_hours'.tr,
                style: _getFontSize() == 14
                    ? AppFonts.smSemiBold(
                  context,
                  color: AppColors.primary,
                )
                    : _getFontSize() == 16
                    ? AppFonts.mdSemiBold(
                  context,
                  color: AppColors.primary,
                )
                    : AppFonts.lgSemiBold(
                  context,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: SelectionButton(
                      text: '12',
                      isSelected: selectedHours == 12,
                      onTap: () {
                        setState(() {
                          selectedHours = 12;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: SelectionButton(
                      text: '8',
                      isSelected: selectedHours == 8,
                      onTap: () {
                        setState(() {
                          selectedHours = 8;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: SelectionButton(
                      text: '6',
                      isSelected: selectedHours == 6,
                      onTap: () {
                        setState(() {
                          selectedHours = 6;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: SelectionButton(
                      text: '4',
                      isSelected: selectedHours == 4,
                      onTap: () {
                        setState(() {
                          selectedHours = 4;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 30),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: SelectionButton(
                    text: 'cancel'.tr,
                    isSelected: false,
                    onTap: () {
                      _toggleExpansion();
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: SelectionButton(
                    text: 'add'.tr,
                    isSelected: true,
                    onTap: () {
                      _addMedication();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddMedicationButton() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: GestureDetector(
        onTap: _toggleExpansion,
        child: DashedRect(
          color: AppColors.primary.withOpacity(0.4),
          strokeWidth: 2,
          gap: 4,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add,
                  color: AppColors.primary,
                  size: 20,
                ),
                const SizedBox(width: 10),
                Text(
                  'add_medicine'.tr,
                  style: _getFontSize() == 14
                      ? AppFonts.smRegular(
                      context,
                      color: AppColors.primary,
                  )
                      : _getFontSize() == 16
                      ? AppFonts.mdRegular(
                      context,
                      color: AppColors.primary,
                  )
                      : AppFonts.lgRegular(
                      context,
                      color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isRTL = _languageService.isRTL;

    return BoxWidget(
      title: 'medicine_reminder',
      backgroundColor: AppColors.white,
      backgroundEndColor: AppColors.backgroundEndColor,
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      children: [
        // Dynamic list of medications or empty state
        if (widget.medications.isEmpty)
          Container(
            padding:
            const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
            child: Center(
              child: Text(
                'no_medicines_added'.tr,
                style: _getFontSize() == 14
                    ? AppFonts.smRegular(
                    context,
                    color: AppColors.secondery.withOpacity(0.7),
                )
                    : _getFontSize() == 16
                    ? AppFonts.mdRegular(
                    context,
                    color: AppColors.secondery.withOpacity(0.7),
                )
                    : AppFonts.lgRegular(
                    context,
                    color: AppColors.secondery.withOpacity(0.7),
                ),
              ),
            ),
          )
        else
          ...widget.medications.asMap().entries.map((entry) {
            int index = entry.key;
            Medication medication = entry.value;
            return Column(
              children: [
                _buildMedicationItem(index, medication),
                if (index < widget.medications.length - 1)
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20.0),
                    height: 1,
                    decoration: BoxDecoration(
                      color: AppColors.dividerLine.withOpacity(0.6),
                    ),
                  ),
              ],
            );
          }).toList(),

        // Add divider before add medication section if there are medications
        if (widget.medications.isNotEmpty)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20.0),
            height: 1,
            decoration: BoxDecoration(
              color: AppColors.dividerLine.withOpacity(0.6),
            ),
          ),

        // Add medication button or expanded form
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _isExpanded
              ? _buildAddMedicationForm()
              : _buildAddMedicationButton(),
        ),
      ],
    );
  }
}