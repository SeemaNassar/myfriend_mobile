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
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: isActive ? 1.0 : 0.5, // Main opacity effect for inactive boxes
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                isActive ? AppColors.bgBox : AppColors.bgBox.withOpacity(0.7),
                isActive ? AppColors.bgBox2 : AppColors.bgBox2.withOpacity(0.7),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border(
              left: isRTL
                  ? BorderSide(
                      color: isActive
                          ? AppColors.primary
                          : const Color(0xFFE0E0E0).withOpacity(0.5),
                      width: 0.8,
                    )
                  : BorderSide(
                      color: isActive
                          ? AppColors.primary
                          : const Color(0xFFE0E0E0).withOpacity(0.5),
                      width: isActive ? 4.0 : 1.5,
                    ),
              right: isRTL
                  ? BorderSide(
                      color: isActive
                          ? AppColors.primary
                          : const Color(0xFFE0E0E0).withOpacity(0.5),
                      width: isActive ? 4.0 : 1.5,
                    )
                  : BorderSide(
                      color: isActive
                          ? AppColors.primary
                          : const Color(0xFFE0E0E0).withOpacity(0.5),
                      width: 0.8,
                    ),
              top: BorderSide(
                color: isActive
                    ? AppColors.primary
                    : const Color(0xFFE0E0E0).withOpacity(0.5),
                width: 0.8,
              ),
              bottom: BorderSide(
                color: isActive
                    ? AppColors.primary
                    : const Color(0xFFE0E0E0).withOpacity(0.5),
                width: 0.8,
              ),
            ),
          ),
          child: Directionality(
            textDirection: languageService.textDirection,
            child: Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: isActive
                        ? AppColors.primary
                        : const Color(0xFFBDBDBD).withOpacity(0.6),
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
                                ? AppColors.secondery
                                : AppColors.secondery.withOpacity(0.6),
                          )
                        : _getFontSize() == 16
                        ? AppFonts.mdMedium(
                            context,
                            color: isActive
                                ? AppColors.secondery
                                : AppColors.secondery.withOpacity(0.6),
                          )
                        : AppFonts.lgMedium(
                            context,
                            color: isActive
                                ? AppColors.secondery
                                : AppColors.secondery.withOpacity(0.6),
                          ),
                  ),
                ),
                Text(
                  time,
                  style: _getFontSize() == 14
                      ? AppFonts.smBold(
                          context,
                          color: isActive
                              ? AppColors.primary
                              : AppColors.primary.withOpacity(0.5),
                        )
                      : _getFontSize() == 16
                      ? AppFonts.mdBold(
                          context,
                          color: isActive
                              ? AppColors.primary
                              : AppColors.primary.withOpacity(0.5),
                        )
                      : AppFonts.lgBold(
                          context,
                          color: isActive
                              ? AppColors.primary
                              : AppColors.primary.withOpacity(0.5),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
