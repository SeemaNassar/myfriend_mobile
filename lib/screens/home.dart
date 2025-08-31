// lib/screens/home_page.dart
import 'package:flutter/material.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:myfriend_mobile/utils/app_font.dart';
import 'package:myfriend_mobile/utils/colors.dart';
import 'package:myfriend_mobile/widgets/page_box.dart';
import 'package:myfriend_mobile/widgets/prayer_item.dart';
import 'package:myfriend_mobile/widgets/prayer_box.dart';
import 'package:myfriend_mobile/widgets/custom_switch.dart';
import 'package:myfriend_mobile/services/language_service.dart';
import 'package:myfriend_mobile/services/prayer_settings_service.dart';
import 'package:intl/intl.dart';
import 'dart:async';

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
  Timer? _timer;

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

    _timer = Timer.periodic(const Duration(minutes: 1), (_) {
      _updateTimeAndDate();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
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
      'الإثنين',
      'الثلاثاء',
      'الأربعاء',
      'الخميس',
      'الجمعة',
      'السبت',
      'الأحد',
    ];
    return arabicDays[weekday - 1];
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (!isRTL) ...[
                            const Text('🌙', style: TextStyle(fontSize: 24)),
                            const SizedBox(width: 8),
                          ],
                          Text(
                            'صديقي',
                            style: AppFonts.xlSemiBold(
                              context,
                              color: AppColors.primary,
                            ),
                          ),
                          if (isRTL) ...[
                            const SizedBox(width: 8),
                            const Text('🌙', style: TextStyle(fontSize: 24)),
                          ],
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        currentTime,
                        style: _getFontSize() == 14
                            ? AppFonts.h2(context, color: AppColors.primary)
                            : _getFontSize() == 16
                            ? AppFonts.h1(context, color: AppColors.primary)
                            : AppFonts.h1(
                                context,
                                color: AppColors.primary,
                              ).copyWith(fontSize: 42),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '$currentDay، $currentDate',
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
                      rightWidget: Text(
                        entry.value,
                        style: _getFontSize() == 14
                            ? AppFonts.smMedium(
                                context,
                                color: AppColors.primary,
                              )
                            : _getFontSize() == 16
                            ? AppFonts.mdMedium(
                                context,
                                color: AppColors.primary,
                              )
                            : AppFonts.lgMedium(
                                context,
                                color: AppColors.primary,
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
                                color: AppColors.secondery,
                                size: 20,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'back'.tr,
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
                            ],
                          ),
                        ),
                        const Spacer(),
                        Text(
                          'after_prayer_times'.tr,
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
                        colors: [AppColors.bgBox, AppColors.bgBox2],
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
                            ],
                            Text(
                              'صديقي',
                              style: _getFontSize() == 14
                                  ? AppFonts.lgSemiBold(
                                      context,
                                      color: AppColors.primary,
                                    )
                                  : _getFontSize() == 16
                                  ? AppFonts.xlSemiBold(
                                      context,
                                      color: AppColors.primary,
                                    )
                                  : AppFonts.xlSemiBold(
                                      context,
                                      color: AppColors.primary,
                                    ).copyWith(fontSize: 22),
                            ),
                            if (isRTL) ...[
                              const SizedBox(width: 8),
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
                            ],
                          ],
                        ),
                        if (isAfterPrayerTimesExpanded) ...[
                          const SizedBox(height: 16),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              vertical: 8.0,
                              horizontal: 12.0,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.bgCard,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'reminder_${_prayerSettingsService.selectedReminderTime}'
                                  .tr,
                              style: _getFontSize() == 14
                                  ? AppFonts.xsRegular(
                                      context,
                                      color: AppColors.secondery,
                                    )
                                  : _getFontSize() == 16
                                  ? AppFonts.smRegular(
                                      context,
                                      color: AppColors.secondery,
                                    )
                                  : AppFonts.mdRegular(
                                      context,
                                      color: AppColors.secondery,
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
                                                        entry.key,
                                                      ),
                                              onChanged: (value) =>
                                                  _onAfterPrayerSwitchChanged(
                                                    entry.key,
                                                    value,
                                                  ),
                                              activeColor: AppColors.primary,
                                              inactiveColor: const Color(
                                                0xFFE0E0E0,
                                              ),
                                            ),
                                            const SizedBox(width: 16),
                                            Text(
                                              prayerName,
                                              style: _getFontSize() == 14
                                                  ? AppFonts.smRegular(
                                                      context,
                                                      color:
                                                          AppColors.secondery,
                                                    )
                                                  : _getFontSize() == 16
                                                  ? AppFonts.mdRegular(
                                                      context,
                                                      color:
                                                          AppColors.secondery,
                                                    )
                                                  : AppFonts.lgRegular(
                                                      context,
                                                      color:
                                                          AppColors.secondery,
                                                    ),
                                            ),
                                          ],
                                        )
                                      : Text(
                                          prayerName,
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
                                  rightWidget: isRTL
                                      ? Text(
                                          entry.value,
                                          style: _getFontSize() == 14
                                              ? AppFonts.smMedium(
                                                  context,
                                                  color: AppColors.primary,
                                                )
                                              : _getFontSize() == 16
                                              ? AppFonts.mdMedium(
                                                  context,
                                                  color: AppColors.primary,
                                                )
                                              : AppFonts.lgMedium(
                                                  context,
                                                  color: AppColors.primary,
                                                ),
                                        )
                                      : Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              entry.value,
                                              style: _getFontSize() == 14
                                                  ? AppFonts.smMedium(
                                                      context,
                                                      color: AppColors.primary,
                                                    )
                                                  : _getFontSize() == 16
                                                  ? AppFonts.mdMedium(
                                                      context,
                                                      color: AppColors.primary,
                                                    )
                                                  : AppFonts.lgMedium(
                                                      context,
                                                      color: AppColors.primary,
                                                    ),
                                            ),
                                            const SizedBox(width: 16),
                                            CustomSwitch(
                                              initialValue:
                                                  _prayerSettingsService
                                                      .isPrayerEnabled(
                                                        entry.key,
                                                      ),
                                              onChanged: (value) =>
                                                  _onAfterPrayerSwitchChanged(
                                                    entry.key,
                                                    value,
                                                  ),
                                              activeColor: AppColors.primary,
                                              inactiveColor: const Color(
                                                0xFFE0E0E0,
                                              ),
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
