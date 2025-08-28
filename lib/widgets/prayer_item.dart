import 'package:flutter/material.dart';
import 'package:myfriend_mobile/services/language_service.dart';

enum PrayerItemShape {
  normal, // No border (default)
  bottomBorder, // Bottom border only
}

class PrayerItem extends StatelessWidget {
  final Widget leftWidget;
  final Widget rightWidget;
  final EdgeInsetsGeometry? padding;
  final MainAxisAlignment? mainAxisAlignment;
  final CrossAxisAlignment? crossAxisAlignment;
  final VoidCallback? onTap;
  final PrayerItemShape shape;
  final bool isLastItem;

  const PrayerItem({
    Key? key,
    required this.leftWidget,
    required this.rightWidget,
    this.padding,
    this.mainAxisAlignment,
    this.crossAxisAlignment,
    this.onTap,
    this.shape = PrayerItemShape.normal,
    this.isLastItem = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final languageService = LanguageService();
    final isRTL = languageService.isRTL;

    Widget content = _buildContent(languageService, isRTL);

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: content,
      );
    }

    return content;
  }

  Widget _buildContent(LanguageService languageService, bool isRTL) {
    switch (shape) {
      case PrayerItemShape.normal:
        return Padding(
          padding: padding ??
              const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
          child: Directionality(
            textDirection: languageService.textDirection,
            child: Row(
              mainAxisAlignment:
                  mainAxisAlignment ?? MainAxisAlignment.spaceBetween,
              crossAxisAlignment:
                  crossAxisAlignment ?? CrossAxisAlignment.center,
              children: [
                Flexible(child: leftWidget),
                rightWidget,
              ],
            ),
          ),
        );

      case PrayerItemShape.bottomBorder:
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Container(
            decoration: BoxDecoration(
              border: isLastItem
                  ? null
                  : const Border(
                      bottom: BorderSide(
                        color: Color(0xFFE0E0E0),
                        width: 1.0,
                      ),
                    ),
            ),
            child: Padding(
              padding: padding ?? const EdgeInsets.symmetric(vertical: 12.0),
              child: Directionality(
                textDirection: languageService.textDirection,
                child: Row(
                  mainAxisAlignment:
                      mainAxisAlignment ?? MainAxisAlignment.spaceBetween,
                  crossAxisAlignment:
                      crossAxisAlignment ?? CrossAxisAlignment.center,
                  children: [
                    Flexible(child: leftWidget),
                    rightWidget,
                  ],
                ),
              ),
            ),
          ),
        );
    }
  }
}
