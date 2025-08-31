//lib\widgets\page_box.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:myfriend_mobile/services/language_service.dart';
import 'package:myfriend_mobile/utils/app_font.dart';
import 'package:myfriend_mobile/utils/colors.dart';

class BoxWidget extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final TextStyle? titleStyle;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? titlePadding;
  final Color? backgroundColor;
  final Color? backgroundEndColor;

  const BoxWidget({
    Key? key,
    required this.title,
    required this.children,
    this.titleStyle,
    this.margin,
    this.titlePadding,
    this.backgroundColor,
    this.backgroundEndColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final languageService = LanguageService();
    final isRTL = languageService.isRTL;

    return Container(
      margin:
          margin ??
          const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  (backgroundColor ?? Colors.white).withOpacity(0.9),
                  (backgroundEndColor ?? const Color(0xFFF5F5DC)).withOpacity(
                    0.7,
                  ),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 1.5,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding:
                          titlePadding ??
                          const EdgeInsets.symmetric(
                            vertical: 16.0,
                            horizontal: 20.0,
                          ),
                      child: Directionality(
                        textDirection: languageService.textDirection,
                        child: Align(
                          alignment: isRTL
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Text(
                            title.tr,
                            style:
                                titleStyle ??
                                AppFonts.xlSemiBold(
                                  context,
                                  color: AppColors.primary,
                                ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20.0),
                      height: 1,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE0E0E0).withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
                Directionality(
                  textDirection: languageService.textDirection,
                  child: Column(children: children),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
