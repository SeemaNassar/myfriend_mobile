import 'package:flutter/material.dart';
import 'package:myfriend_mobile/services/language_service.dart';
import 'package:myfriend_mobile/services/prayer_settings_service.dart';
import 'package:myfriend_mobile/utils/app_font.dart';
import 'package:myfriend_mobile/utils/colors.dart';

enum PrayerItemShape { normal, bottomBorder }

class PrayerItem extends StatefulWidget {
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
  State<PrayerItem> createState() => _PrayerItemState();
}

class _PrayerItemState extends State<PrayerItem> {
  final PrayerSettingsService _prayerSettingsService = PrayerSettingsService();

  @override
  void initState() {
    super.initState();
    _prayerSettingsService.addListener(_onSettingsChanged);
  }

  @override
  void dispose() {
    _prayerSettingsService.removeListener(_onSettingsChanged);
    super.dispose();
  }

  void _onSettingsChanged() {
    if (mounted) {
      setState(() {});
    }
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

  @override
  Widget build(BuildContext context) {
    final languageService = LanguageService();
    final isRTL = languageService.isRTL;

    Widget content = _buildContent(languageService, isRTL);

    if (widget.onTap != null) {
      return GestureDetector(onTap: widget.onTap, child: content);
    }

    return content;
  }

  Widget _buildContent(LanguageService languageService, bool isRTL) {
    switch (widget.shape) {
      case PrayerItemShape.normal:
        return Padding(
          padding:
              widget.padding ??
              const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
          child: Directionality(
            textDirection: languageService.textDirection,
            child: Row(
              mainAxisAlignment:
                  widget.mainAxisAlignment ?? MainAxisAlignment.spaceBetween,
              crossAxisAlignment:
                  widget.crossAxisAlignment ?? CrossAxisAlignment.center,
              children: [
                Flexible(child: widget.leftWidget),
                widget.rightWidget,
              ],
            ),
          ),
        );

      case PrayerItemShape.bottomBorder:
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Container(
            decoration: BoxDecoration(
              border: widget.isLastItem
                  ? null
                  : const Border(
                      bottom: BorderSide(
                        color: Color.fromARGB(255, 216, 215, 215),
                        width: 0.5,
                      ),
                    ),
            ),
            child: Padding(
              padding:
                  widget.padding ??
                  const EdgeInsets.only(top: 20.0, bottom: 12.0),
              child: Directionality(
                textDirection: languageService.textDirection,
                child: Row(
                  mainAxisAlignment:
                      widget.mainAxisAlignment ??
                      MainAxisAlignment.spaceBetween,
                  crossAxisAlignment:
                      widget.crossAxisAlignment ?? CrossAxisAlignment.center,
                  children: [
                    Flexible(child: widget.leftWidget),
                    widget.rightWidget,
                  ],
                ),
              ),
            ),
          ),
        );
    }
  }
}
