// lib/screens/home_page.dart
import 'package:flutter/material.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:myfriend_mobile/widgets/page_box.dart';
import 'package:myfriend_mobile/widgets/prayer_item.dart';
import 'package:myfriend_mobile/widgets/prayer_box.dart';
import 'package:myfriend_mobile/widgets/custom_switch.dart';
import 'package:myfriend_mobile/services/language_service.dart';
import 'package:myfriend_mobile/services/prayer_settings_service.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final LanguageService _languageService = LanguageService();
  final PrayerSettingsService _prayerSettingsService = PrayerSettingsService();
  late String currentTime;
  late String currentDate;
  late String currentDay;
  bool isAfterPrayerTimesExpanded = false;

  final Map<String, String> prayerTimes = {
    'fajr': '06:45',
    'dhuhr': '12:15',
    'asr': '15:30',
    'maghrib': '18:45',
    'isha': '20:00',
  };

  @override
  void initState() {
    super.initState();
    _languageService.addListener(_onLanguageChanged);
    _prayerSettingsService.addListener(_onSettingsChanged);
    _updateTimeAndDate();

    Stream.periodic(const Duration(minutes: 1)).listen((_) {
      _updateTimeAndDate();
    });
  }

  @override
  void dispose() {
    _languageService.removeListener(_onLanguageChanged);
    _prayerSettingsService.removeListener(_onSettingsChanged);
    super.dispose();
  }

  void _onLanguageChanged() {
    if (mounted) {
      setState(() {
        _updateTimeAndDate();
      });
    }
  }

  void _onSettingsChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  void _updateTimeAndDate() {
    final now = DateTime.now();
    final isRTL = _languageService.isRTL;

    final timeFormat = _prayerSettingsService.selectedTimeFormat;
    if (timeFormat == '12 Hour') {
      currentTime = DateFormat('hh:mm a').format(now);
    } else {
      currentTime = DateFormat('HH:mm').format(now);
    }

    if (isRTL) {
      currentDay = _getArabicDayName(now.weekday);
      currentDate = _getHijriDateFormatted(now);
    } else {
      currentDay = DateFormat('EEEE').format(now);
      currentDate = DateFormat('d MMMM yyyy').format(now);
    }

    if (mounted) {
      setState(() {});
    }
  }

  String _getArabicDayName(int weekday) {
    const arabicDays = [
      'السبت',
      'الأحد',
      'الإثنين',
      'الثلاثاء',
      'الأربعاء',
      'الخميس',
      'الجمعة',
    ];
    return arabicDays[weekday];
  }

  String _getHijriDateFormatted(DateTime date) {
    final hijriDate = HijriCalendar.fromDate(date);
    return '${hijriDate.hDay} ${hijriDate.longMonthName} ${hijriDate.hYear} هـ';
  }

  String _getPrayerNameInArabic(String englishName) {
    switch (englishName.toLowerCase()) {
      case 'fajr':
        return 'الفجر';
      case 'dhuhr':
        return 'الظهر';
      case 'asr':
        return 'العصر';
      case 'maghrib':
        return 'المغرب';
      case 'isha':
        return 'العشاء';
      default:
        return englishName;
    }
  }

  void _toggleAfterPrayerTimes() {
    setState(() {
      isAfterPrayerTimesExpanded = !isAfterPrayerTimesExpanded;
    });
  }

  void _onAfterPrayerSwitchChanged(String prayer, bool value) {
    _prayerSettingsService.togglePrayer(prayer, value);
  }

  @override
  Widget build(BuildContext context) {
    final isRTL = _languageService.isRTL;
    final enabledPrayers = _prayerSettingsService.getEnabledPrayers().toSet();

    return Directionality(
      textDirection: _languageService.textDirection,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5DC),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (!isRTL) ...[
                            const Text(
                              '🌙',
                              style: TextStyle(fontSize: 24),
                            ),
                            const SizedBox(width: 8),
                          ],
                          const Text(
                            'صديقي',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF4A7C59),
                            ),
                          ),
                          if (isRTL) ...[
                            const SizedBox(width: 8),
                            const Text(
                              '🌙',
                              style: TextStyle(fontSize: 24),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        currentTime,
                        style: TextStyle(
                          fontSize: _getFontSize() + 24,
                          fontWeight: FontWeight.w300,
                          color: const Color(0xFF4A7C59),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '$currentDay، $currentDate',
                        style: TextStyle(
                          fontSize: _getFontSize(),
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF8B4513),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                BoxWidget(
                  title: 'prayer_times',
                  backgroundColor: Colors.white,
                  backgroundEndColor: const Color(0xFFF5F5DC),
                  children: prayerTimes.entries.map((entry) {
                    final isLast = entry.key == prayerTimes.keys.last;
                    return PrayerItem(
                      shape: PrayerItemShape.bottomBorder,
                      isLastItem: isLast,
                      leftWidget: Text(
                        entry.key.tr,
                        style: TextStyle(
                          fontSize: _getFontSize(),
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF8B4513),
                        ),
                      ),
                      rightWidget: Text(
                        entry.value,
                        style: TextStyle(
                          fontSize: _getFontSize(),
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF4A7C59),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 30),
                if (isAfterPrayerTimesExpanded) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: _toggleAfterPrayerTimes,
                          child: Row(
                            children: [
                              Icon(
                                isRTL ? Icons.arrow_forward : Icons.arrow_back,
                                color: const Color(0xFF8B4513),
                                size: 20,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'back'.tr,
                                style: TextStyle(
                                  fontSize: _getFontSize(),
                                  color: const Color(0xFF8B4513),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        Text(
                          'after_prayer_times'.tr,
                          style: TextStyle(
                            fontSize: _getFontSize() + 2,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF4A7C59),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                GestureDetector(
                  onTap: isAfterPrayerTimesExpanded
                      ? null
                      : _toggleAfterPrayerTimes,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 24.0),
                    padding: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.white,
                          Color(0xFFF5F5DC),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (!isRTL) ...[
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
                            ],
                            Text(
                              'صديقي',
                              style: TextStyle(
                                fontSize: _getFontSize() + 4,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF4A7C59),
                              ),
                            ),
                            if (isRTL) ...[
                              const SizedBox(width: 8),
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
                            ],
                          ],
                        ),
                        if (isAfterPrayerTimesExpanded) ...[
                          const SizedBox(height: 16),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 12.0),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF5F5DC),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'reminder_${_prayerSettingsService.selectedReminderTime}'
                                  .tr,
                              style: TextStyle(
                                fontSize: _getFontSize() - 2,
                                color: const Color(0xFF8B4513),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              children: prayerTimes.entries.map((entry) {
                                final isLast =
                                    entry.key == prayerTimes.keys.last;
                                String prayerName = isRTL
                                    ? _getPrayerNameInArabic(entry.key)
                                    : entry.key.tr;

                                return PrayerItem(
                                  shape: PrayerItemShape.bottomBorder,
                                  isLastItem: isLast,
                                  leftWidget: isRTL
                                      ? Row(
                                          children: [
                                            CustomSwitch(
                                              initialValue:
                                                  _prayerSettingsService
                                                      .isPrayerEnabled(
                                                          entry.key),
                                              onChanged: (value) =>
                                                  _onAfterPrayerSwitchChanged(
                                                      entry.key, value),
                                              activeColor:
                                                  const Color(0xFF4A7C59),
                                              inactiveColor:
                                                  const Color(0xFFE0E0E0),
                                            ),
                                            const SizedBox(width: 16),
                                            Text(
                                              prayerName,
                                              style: TextStyle(
                                                fontSize: _getFontSize(),
                                                fontWeight: FontWeight.w400,
                                                color: const Color(0xFF8B4513),
                                              ),
                                            ),
                                          ],
                                        )
                                      : Text(
                                          prayerName,
                                          style: TextStyle(
                                            fontSize: _getFontSize(),
                                            fontWeight: FontWeight.w400,
                                            color: const Color(0xFF8B4513),
                                          ),
                                        ),
                                  rightWidget: isRTL
                                      ? Text(
                                          entry.value,
                                          style: TextStyle(
                                            fontSize: _getFontSize(),
                                            fontWeight: FontWeight.w500,
                                            color: const Color(0xFF4A7C59),
                                          ),
                                        )
                                      : Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              entry.value,
                                              style: TextStyle(
                                                fontSize: _getFontSize(),
                                                fontWeight: FontWeight.w500,
                                                color: const Color(0xFF4A7C59),
                                              ),
                                            ),
                                            const SizedBox(width: 16),
                                            CustomSwitch(
                                              initialValue:
                                                  _prayerSettingsService
                                                      .isPrayerEnabled(
                                                          entry.key),
                                              onChanged: (value) =>
                                                  _onAfterPrayerSwitchChanged(
                                                      entry.key, value),
                                              activeColor:
                                                  const Color(0xFF4A7C59),
                                              inactiveColor:
                                                  const Color(0xFFE0E0E0),
                                            ),
                                          ],
                                        ),
                                );
                              }).toList(),
                            ),
                          ),
                        ] else ...[
                          const SizedBox(height: 8),
                          Text(
                            'after_prayer_times'.tr,
                            style: TextStyle(
                              fontSize: _getFontSize(),
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF8B4513),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                if (!isAfterPrayerTimesExpanded) ...[
                  Column(
                    children: prayerTimes.entries.map((entry) {
                      final isActive = enabledPrayers.contains(entry.key);
                      return PrayerBox(
                        prayerName: entry.key,
                        time: entry.value,
                        isActive: isActive,
                        onTap: () {},
                      );
                    }).toList(),
                  ),
                ],
                const SizedBox(height: 40),
              ],
            ),
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
