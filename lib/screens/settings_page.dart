// lib/screens/settings_page.dart
import 'package:flutter/material.dart';
import 'package:myfriend_mobile/services/language_service.dart';
import 'package:myfriend_mobile/services/prayer_settings_service.dart';
import 'package:myfriend_mobile/utils/app_font.dart';
import 'package:myfriend_mobile/utils/colors.dart';
import 'package:myfriend_mobile/widgets/page_box.dart';
import 'package:myfriend_mobile/widgets/prayer_item.dart';
import 'package:myfriend_mobile/widgets/custom_switch.dart';
import 'package:myfriend_mobile/widgets/selection_button.dart';

class PrayerSettingsPage extends StatefulWidget {
  final VoidCallback? onBackPressed;

  const PrayerSettingsPage({Key? key, this.onBackPressed}) : super(key: key);

  @override
  State<PrayerSettingsPage> createState() => _PrayerSettingsPageState();
}

class _PrayerSettingsPageState extends State<PrayerSettingsPage> {
  final LanguageService _languageService = LanguageService();
  final PrayerSettingsService _prayerSettingsService = PrayerSettingsService();

  @override
  void initState() {
    super.initState();
    _languageService.addListener(_onLanguageChanged);
    _prayerSettingsService.addListener(_onSettingsChanged);
  }

  @override
  void dispose() {
    _languageService.removeListener(_onLanguageChanged);
    _prayerSettingsService.removeListener(_onSettingsChanged);
    super.dispose();
  }

  void _onLanguageChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  void _onSettingsChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  void _changeLanguage(String languageCode) async {
    await _languageService.changeLanguage(languageCode);
  }

  @override
  Widget build(BuildContext context) {
    final isRTL = _languageService.isRTL;

    return Directionality(
      textDirection: _languageService.textDirection,
      child: Scaffold(
        backgroundColor: AppColors.mainBg,
        appBar: AppBar(
          backgroundColor: AppColors.mainBg,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Text(
            'settings'.tr,
            style: _getFontSize() == 14
                ? AppFonts.xlSemiBold(context, color: AppColors.primary)
                : _getFontSize() == 16
                ? AppFonts.xlSemiBold(
                    context,
                    color: AppColors.primary,
                  ).copyWith(fontSize: 22)
                : AppFonts.xlSemiBold(
                    context,
                    color: AppColors.primary,
                  ).copyWith(fontSize: 24),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              BoxWidget(
                title: 'prayer_reminder',
                backgroundColor: AppColors.bgBox,
                backgroundEndColor: AppColors.bgBox2,
                children: _prayerSettingsService.prayerStates.entries
                    .map(
                      (entry) => PrayerItem(
                        leftWidget: Text(
                          entry.key.tr,
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
                        rightWidget: CustomSwitch(
                          initialValue: entry.value,
                          onChanged: (value) => _prayerSettingsService
                              .togglePrayer(entry.key, value),
                          activeColor: AppColors.primary,
                          inactiveColor: const Color(0xFFE0E0E0),
                        ),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 20),
              BoxWidget(
                title: 'app_settings',
                backgroundColor: AppColors.bgBox,
                backgroundEndColor: AppColors.bgBox2,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 12.0,
                        ),
                        child: Text(
                          'time_format'.tr,
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
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: SelectionButton(
                                text: 'time_format_12_hour'.tr,
                                isSelected:
                                    _prayerSettingsService.selectedTimeFormat ==
                                    '12 Hour',
                                onTap: () {
                                  _prayerSettingsService.setTimeFormat(
                                    '12 Hour',
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: SelectionButton(
                                text: 'time_format_24_hour'.tr,
                                isSelected:
                                    _prayerSettingsService.selectedTimeFormat ==
                                    '24 Hour',
                                onTap: () {
                                  _prayerSettingsService.setTimeFormat(
                                    '24 Hour',
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 12.0,
                        ),
                        child: Text(
                          'reminder_time_after_prayer'.tr,
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
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: SelectionButton(
                                text: '15',
                                isSelected:
                                    _prayerSettingsService
                                        .selectedReminderTime ==
                                    '15',
                                onTap: () {
                                  _prayerSettingsService.setReminderTime('15');
                                },
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: SelectionButton(
                                text: '30',
                                isSelected:
                                    _prayerSettingsService
                                        .selectedReminderTime ==
                                    '30',
                                onTap: () {
                                  _prayerSettingsService.setReminderTime('30');
                                },
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: SelectionButton(
                                text: '40',
                                isSelected:
                                    _prayerSettingsService
                                        .selectedReminderTime ==
                                    '40',
                                onTap: () {
                                  _prayerSettingsService.setReminderTime('40');
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 12.0,
                        ),
                        child: Text(
                          'alert_sound'.tr,
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
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: SelectionButton(
                                    text: 'sound_default'.tr,
                                    isSelected:
                                        _prayerSettingsService
                                            .selectedAlertSound ==
                                        'Default',
                                    onTap: () {
                                      _prayerSettingsService.setAlertSound(
                                        'Default',
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: SelectionButton(
                                    text: 'sound_adhan'.tr,
                                    isSelected:
                                        _prayerSettingsService
                                            .selectedAlertSound ==
                                        'Adhan',
                                    onTap: () {
                                      _prayerSettingsService.setAlertSound(
                                        'Adhan',
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: SelectionButton(
                                    text: 'sound_bell'.tr,
                                    isSelected:
                                        _prayerSettingsService
                                            .selectedAlertSound ==
                                        'Bell',
                                    onTap: () {
                                      _prayerSettingsService.setAlertSound(
                                        'Bell',
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: SelectionButton(
                                    text: 'sound_chime'.tr,
                                    isSelected:
                                        _prayerSettingsService
                                            .selectedAlertSound ==
                                        'Chime',
                                    onTap: () {
                                      _prayerSettingsService.setAlertSound(
                                        'Chime',
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 12.0,
                        ),
                        child: Text(
                          'font_size'.tr,
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
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: SelectionButton(
                                text: 'font_size_small'.tr,
                                isSelected:
                                    _prayerSettingsService.selectedFontSize ==
                                    'Small',
                                onTap: () {
                                  _prayerSettingsService.setFontSize('Small');
                                },
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: SelectionButton(
                                text: 'font_size_medium'.tr,
                                isSelected:
                                    _prayerSettingsService.selectedFontSize ==
                                    'Medium',
                                onTap: () {
                                  _prayerSettingsService.setFontSize('Medium');
                                },
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: SelectionButton(
                                text: 'font_size_large'.tr,
                                isSelected:
                                    _prayerSettingsService.selectedFontSize ==
                                    'Large',
                                onTap: () {
                                  _prayerSettingsService.setFontSize('Large');
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              BoxWidget(
                title: 'general_settings',
                backgroundColor: AppColors.bgBox,
                backgroundEndColor: AppColors.bgBox2,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 12.0,
                        ),
                        child: Text(
                          'language'.tr,
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
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: SelectionButton(
                                text: 'language_arabic'.tr,
                                isSelected:
                                    _languageService
                                        .currentLocale
                                        .languageCode ==
                                    'ar',
                                onTap: () => _changeLanguage('ar'),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: SelectionButton(
                                text: 'language_english'.tr,
                                isSelected:
                                    _languageService
                                        .currentLocale
                                        .languageCode ==
                                    'en',
                                onTap: () => _changeLanguage('en'),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 12.0,
                        ),
                        child: Text(
                          'selected_country'.tr,
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
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 12.0,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.bgCard,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: const Color(0xFFE0E0E0),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            'country_saudi_arabia'.tr,
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
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                  PrayerItem(
                    leftWidget: Text(
                      'notifications'.tr,
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
                    rightWidget: CustomSwitch(
                      initialValue: _prayerSettingsService.notificationsEnabled,
                      onChanged: (value) {
                        _prayerSettingsService.setNotifications(value);
                      },
                      activeColor: AppColors.primary,
                      inactiveColor: const Color(0xFFE0E0E0),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
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
}
