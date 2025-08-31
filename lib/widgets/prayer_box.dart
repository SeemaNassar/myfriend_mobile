//lib\widgets\prayer_box.dart
import 'package:flutter/material.dart';
import 'package:myfriend_mobile/services/language_service.dart';
import 'package:myfriend_mobile/services/prayer_settings_service.dart';
import 'package:myfriend_mobile/utils/app_font.dart';
import 'package:myfriend_mobile/utils/colors.dart';

class PrayerBox extends StatelessWidget {
  final String prayerName;
  final String time;
  final bool isActive;
  final VoidCallback? onTap;

  const PrayerBox({
    Key? key,
    required this.prayerName,
    required this.time,
    this.isActive = false,
    this.onTap,
  }) : super(key: key);

  double _getFontSize() {
    final prayerSettingsService = PrayerSettingsService();
    switch (prayerSettingsService.selectedFontSize) {
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
    final languageService = LanguageService();
    final isRTL = languageService.isRTL;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border(
            left: isRTL
                ? BorderSide.none
                : BorderSide(
                    color: isActive
                        ? AppColors.primary
                        : const Color(0xFFE0E0E0),
                    width: isActive ? 4.0 : 1.5,
                  ),
            right: isRTL
                ? BorderSide(
                    color: isActive
                        ? AppColors.primary
                        : const Color(0xFFE0E0E0),
                    width: isActive ? 4.0 : 1.5,
                  )
                : BorderSide.none,
            top: BorderSide(
              color: isActive ? AppColors.primary : const Color(0xFFE0E0E0),
              width: 1.5,
            ),
            bottom: BorderSide(
              color: isActive ? AppColors.primary : const Color(0xFFE0E0E0),
              width: 1.5,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Directionality(
          textDirection: languageService.textDirection,
          child: Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: isActive ? AppColors.primary : const Color(0xFFBDBDBD),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  prayerName.tr,
                  style: _getFontSize() == 14
                      ? AppFonts.smMedium(
                          context,
                          color: isActive
                              ? AppColors.primary
                              : AppColors.secondery,
                        )
                      : _getFontSize() == 16
                      ? AppFonts.mdMedium(
                          context,
                          color: isActive
                              ? AppColors.primary
                              : AppColors.secondery,
                        )
                      : AppFonts.lgMedium(
                          context,
                          color: isActive
                              ? AppColors.primary
                              : AppColors.secondery,
                        ),
                ),
              ),
              Text(
                time,
                style: _getFontSize() == 14
                    ? AppFonts.smMedium(
                        context,
                        color: isActive
                            ? AppColors.primary
                            : const Color(0xFF666666),
                      )
                    : _getFontSize() == 16
                    ? AppFonts.mdMedium(
                        context,
                        color: isActive
                            ? AppColors.primary
                            : const Color(0xFF666666),
                      )
                    : AppFonts.lgMedium(
                        context,
                        color: isActive
                            ? AppColors.primary
                            : const Color(0xFF666666),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
