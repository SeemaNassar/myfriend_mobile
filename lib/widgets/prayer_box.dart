//lib\widgets\prayer_box.dart
import 'package:flutter/material.dart';
import 'package:myfriend_mobile/services/language_service.dart';

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
                        ? const Color(0xFF4A7C59)
                        : const Color(0xFFE0E0E0),
                    width: isActive ? 4.0 : 1.5,
                  ),
            right: isRTL
                ? BorderSide(
                    color: isActive
                        ? const Color(0xFF4A7C59)
                        : const Color(0xFFE0E0E0),
                    width: isActive ? 4.0 : 1.5,
                  )
                : BorderSide.none,
            top: BorderSide(
              color:
                  isActive ? const Color(0xFF4A7C59) : const Color(0xFFE0E0E0),
              width: 1.5,
            ),
            bottom: BorderSide(
              color:
                  isActive ? const Color(0xFF4A7C59) : const Color(0xFFE0E0E0),
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
                  color: isActive
                      ? const Color(0xFF4A7C59)
                      : const Color(0xFFBDBDBD),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  prayerName.tr,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: isActive
                        ? const Color(0xFF4A7C59)
                        : const Color(0xFF8B4513),
                  ),
                ),
              ),
              Text(
                time,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: isActive
                      ? const Color(0xFF4A7C59)
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
