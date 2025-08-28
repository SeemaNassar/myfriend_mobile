//lib\screens\settings_page.dart
import 'package:flutter/material.dart';
import 'package:myfriend_mobile/widgets/page_box.dart';
import 'package:myfriend_mobile/widgets/prayer_item.dart';
import 'package:myfriend_mobile/widgets/custom_switch.dart';
import 'package:myfriend_mobile/widgets/selection_button.dart';
import 'package:myfriend_mobile/services/language_service.dart';

class PrayerSettingsPage extends StatefulWidget {
  const PrayerSettingsPage({Key? key}) : super(key: key);

  @override
  State<PrayerSettingsPage> createState() => _PrayerSettingsPageState();
}

class _PrayerSettingsPageState extends State<PrayerSettingsPage> {
  final LanguageService _languageService = LanguageService();

  Map<String, bool> prayerStates = {
    'fajr': true,
    'dhuhr': false,
    'asr': false,
    'maghrib': false,
    'isha': true,
  };

  String selectedAlertSound = 'Default';
  String selectedFontSize = 'Medium';
  String selectedLanguage = 'English';
  String selectedCountry = 'المملكة العربية السعودية';
  bool notificationsEnabled = true;
  String selectedTimeFormat = '24 Hour';
  String selectedReminderTime = '15 min';

  final List<String> alertSounds = ['Default', 'Adhan', 'Bell', 'Chime'];

  final List<String> fontSizes = ['Small', 'Medium', 'Large'];

  final List<String> timeFormats = ['12 Hour', '24 Hour'];

  final List<String> reminderTimes = ['15 min', '30 min', '40 min'];

  @override
  void initState() {
    super.initState();
    _languageService.addListener(_onLanguageChanged);
    _loadInitialLanguage();
  }

  @override
  void dispose() {
    _languageService.removeListener(_onLanguageChanged);
    super.dispose();
  }

  void _onLanguageChanged() {
    setState(() {
      selectedLanguage = _languageService.currentLocale.languageCode == 'en'
          ? 'English'
          : 'العربية';
    });
  }

  Future<void> _loadInitialLanguage() async {
    await _languageService.loadLanguage('en');
  }

  void togglePrayer(String prayerName, bool value) {
    setState(() {
      prayerStates[prayerName] = value;
    });
    print('$prayerName reminder ${value ? 'enabled' : 'disabled'}');
  }

  void _changeLanguage(String languageCode) async {
    await _languageService.changeLanguage(languageCode);
  }

  void _toggleLanguage() {
    final newLang =
        _languageService.currentLocale.languageCode == 'en' ? 'ar' : 'en';
    _changeLanguage(newLang);
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
            style: const TextStyle(
              color: Color(0xFF4A7C59),
              fontSize: 24,
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
                children: prayerStates.entries
                    .map((entry) => PrayerItem(
                          leftWidget: Text(
                            entry.key.tr,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF8B4513),
                            ),
                          ),
                          rightWidget: CustomSwitch(
                            initialValue: entry.value,
                            onChanged: (value) =>
                                togglePrayer(entry.key, value),
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
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF8B4513),
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
                                isSelected: selectedTimeFormat == '12 Hour',
                                onTap: () {
                                  setState(() {
                                    selectedTimeFormat = '12 Hour';
                                  });
                                },
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: SelectionButton(
                                text: '24 Hour',
                                isSelected: selectedTimeFormat == '24 Hour',
                                onTap: () {
                                  setState(() {
                                    selectedTimeFormat = '24 Hour';
                                  });
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
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF8B4513),
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
                                isSelected: selectedReminderTime == '15 min',
                                onTap: () {
                                  setState(() {
                                    selectedReminderTime = '15 min';
                                  });
                                },
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: SelectionButton(
                                text: '30 min',
                                isSelected: selectedReminderTime == '30 min',
                                onTap: () {
                                  setState(() {
                                    selectedReminderTime = '30 min';
                                  });
                                },
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: SelectionButton(
                                text: '40 min',
                                isSelected: selectedReminderTime == '40 min',
                                onTap: () {
                                  setState(() {
                                    selectedReminderTime = '40 min';
                                  });
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
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF8B4513),
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
                                    isSelected: selectedAlertSound == 'Default',
                                    onTap: () {
                                      setState(() {
                                        selectedAlertSound = 'Default';
                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: SelectionButton(
                                    text: 'Adhan',
                                    isSelected: selectedAlertSound == 'Adhan',
                                    onTap: () {
                                      setState(() {
                                        selectedAlertSound = 'Adhan';
                                      });
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
                                    isSelected: selectedAlertSound == 'Bell',
                                    onTap: () {
                                      setState(() {
                                        selectedAlertSound = 'Bell';
                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: SelectionButton(
                                    text: 'Chime',
                                    isSelected: selectedAlertSound == 'Chime',
                                    onTap: () {
                                      setState(() {
                                        selectedAlertSound = 'Chime';
                                      });
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
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF8B4513),
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
                                isSelected: selectedFontSize == 'Small',
                                onTap: () {
                                  setState(() {
                                    selectedFontSize = 'Small';
                                  });
                                },
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: SelectionButton(
                                text: 'Medium',
                                isSelected: selectedFontSize == 'Medium',
                                onTap: () {
                                  setState(() {
                                    selectedFontSize = 'Medium';
                                  });
                                },
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: SelectionButton(
                                text: 'Large',
                                isSelected: selectedFontSize == 'Large',
                                onTap: () {
                                  setState(() {
                                    selectedFontSize = 'Large';
                                  });
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
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF8B4513),
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
                      'selected_country'.tr,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF8B4513),
                      ),
                    ),
                    rightWidget: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFE0E0E0)),
                      ),
                      child: Text(
                        selectedCountry,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFF666666),
                        ),
                      ),
                    ),
                  ),
                  PrayerItem(
                    leftWidget: Text(
                      'notifications'.tr,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF8B4513),
                      ),
                    ),
                    rightWidget: CustomSwitch(
                      initialValue: notificationsEnabled,
                      onChanged: (value) {
                        setState(() {
                          notificationsEnabled = value;
                        });
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
}
