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
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppColors.bgBox, AppColors.bgBox2],
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.bgBox, width: 0.5),
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
                            vertical: 12.0,
                            horizontal: 20.0,
                          ),
                      child: Directionality(
                        textDirection: languageService.textDirection,
                        child: Align(
                          alignment: isRTL
                              ? Alignment.centerRight
                              : Alignment.center,
                          child: Text(
                            title.tr,
                            style:
                                titleStyle ??
                                AppFonts.lgSemiBold(
                                  context,
                                  color: AppColors.primary,
                                ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20.0),
                      height: 0.5,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 206, 205, 205),
                      ),
                    ),
                    const SizedBox(height: 8),
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
