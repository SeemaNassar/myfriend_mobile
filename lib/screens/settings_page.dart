import 'package:flutter/material.dart';
import 'package:myfriend_mobile/services/language_service.dart';
import 'package:myfriend_mobile/services/prayer_settings_service.dart';
import 'package:myfriend_mobile/widgets/page_box.dart';
import 'package:myfriend_mobile/widgets/prayer_item.dart';
import 'package:myfriend_mobile/widgets/custom_switch.dart';
import 'package:myfriend_mobile/widgets/selection_button.dart';

class PrayerSettingsPage extends StatefulWidget {
  const PrayerSettingsPage({Key? key}) : super(key: key);

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
        backgroundColor: const Color(0xFFF5F5DC),
        appBar: AppBar(
          backgroundColor: const Color(0xFFF5F5DC),
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              isRTL ? Icons.arrow_forward : Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            'settings'.tr,
            style: TextStyle(
              color: const Color(0xFF4A7C59),
              fontSize: _getFontSize() + 6,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              BoxWidget(
                title: 'prayer_reminder',
                backgroundColor: Colors.white,
                backgroundEndColor: const Color(0xFFF5F5DC),
                children: _prayerSettingsService.prayerStates.entries
                    .map((entry) => PrayerItem(
                          leftWidget: Text(
                            entry.key.tr,
                            style: TextStyle(
                              fontSize: _getFontSize(),
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFF8B4513),
                            ),
                          ),
                          rightWidget: CustomSwitch(
                            initialValue: entry.value,
                            onChanged: (value) => _prayerSettingsService
                                .togglePrayer(entry.key, value),
                            activeColor: const Color(0xFF4A7C59),
                            inactiveColor: const Color(0xFFE0E0E0),
                          ),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 20),
              BoxWidget(
                title: 'app_settings',
                backgroundColor: Colors.white,
                backgroundEndColor: const Color(0xFFF5F5DC),
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 12.0),
                        child: Text(
                          'time_format'.tr,
                          style: TextStyle(
                            fontSize: _getFontSize(),
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF8B4513),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: SelectionButton(
                                text: '12 Hour',
                                isSelected:
                                    _prayerSettingsService.selectedTimeFormat ==
                                        '12 Hour',
                                onTap: () {
                                  _prayerSettingsService
                                      .setTimeFormat('12 Hour');
                                },
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: SelectionButton(
                                text: '24 Hour',
                                isSelected:
                                    _prayerSettingsService.selectedTimeFormat ==
                                        '24 Hour',
                                onTap: () {
                                  _prayerSettingsService
                                      .setTimeFormat('24 Hour');
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
                            horizontal: 20.0, vertical: 12.0),
                        child: Text(
                          'reminder_time_after_prayer'.tr,
                          style: TextStyle(
                            fontSize: _getFontSize(),
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF8B4513),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: SelectionButton(
                                text: '15 min',
                                isSelected: _prayerSettingsService
                                        .selectedReminderTime ==
                                    '15 min',
                                onTap: () {
                                  _prayerSettingsService
                                      .setReminderTime('15 min');
                                },
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: SelectionButton(
                                text: '30 min',
                                isSelected: _prayerSettingsService
                                        .selectedReminderTime ==
                                    '30 min',
                                onTap: () {
                                  _prayerSettingsService
                                      .setReminderTime('30 min');
                                },
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: SelectionButton(
                                text: '40 min',
                                isSelected: _prayerSettingsService
                                        .selectedReminderTime ==
                                    '40 min',
                                onTap: () {
                                  _prayerSettingsService
                                      .setReminderTime('40 min');
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
                            horizontal: 20.0, vertical: 12.0),
                        child: Text(
                          'alert_sound'.tr,
                          style: TextStyle(
                            fontSize: _getFontSize(),
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF8B4513),
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
                                    text: 'Default',
                                    isSelected: _prayerSettingsService
                                            .selectedAlertSound ==
                                        'Default',
                                    onTap: () {
                                      _prayerSettingsService
                                          .setAlertSound('Default');
                                    },
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: SelectionButton(
                                    text: 'Adhan',
                                    isSelected: _prayerSettingsService
                                            .selectedAlertSound ==
                                        'Adhan',
                                    onTap: () {
                                      _prayerSettingsService
                                          .setAlertSound('Adhan');
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
                                    text: 'Bell',
                                    isSelected: _prayerSettingsService
                                            .selectedAlertSound ==
                                        'Bell',
                                    onTap: () {
                                      _prayerSettingsService
                                          .setAlertSound('Bell');
                                    },
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: SelectionButton(
                                    text: 'Chime',
                                    isSelected: _prayerSettingsService
                                            .selectedAlertSound ==
                                        'Chime',
                                    onTap: () {
                                      _prayerSettingsService
                                          .setAlertSound('Chime');
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
                            horizontal: 20.0, vertical: 12.0),
                        child: Text(
                          'font_size'.tr,
                          style: TextStyle(
                            fontSize: _getFontSize(),
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF8B4513),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: SelectionButton(
                                text: 'Small',
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
                                text: 'Medium',
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
                                text: 'Large',
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
                backgroundColor: Colors.white,
                backgroundEndColor: const Color(0xFFF5F5DC),
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 12.0),
                        child: Text(
                          'language'.tr,
                          style: TextStyle(
                            fontSize: _getFontSize(),
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF8B4513),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: SelectionButton(
                                text: 'العربية',
                                isSelected: _languageService
                                        .currentLocale.languageCode ==
                                    'ar',
                                onTap: () => _changeLanguage('ar'),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: SelectionButton(
                                text: 'English',
                                isSelected: _languageService
                                        .currentLocale.languageCode ==
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
                  PrayerItem(
                    leftWidget: Text(
                      'notifications'.tr,
                      style: TextStyle(
                        fontSize: _getFontSize(),
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF8B4513),
                      ),
                    ),
                    rightWidget: CustomSwitch(
                      initialValue: _prayerSettingsService.notificationsEnabled,
                      onChanged: (value) {
                        _prayerSettingsService.setNotifications(value);
                      },
                      activeColor: const Color(0xFF4A7C59),
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
