//lib\widgets\selection_button.dart
import 'package:flutter/material.dart';
import 'package:myfriend_mobile/services/prayer_settings_service.dart';
import 'package:myfriend_mobile/utils/app_font.dart';
import 'package:myfriend_mobile/utils/colors.dart';

class SelectionButton extends StatefulWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;
  final double? width;
  final double? height;

  const SelectionButton({
    Key? key,
    required this.text,
    required this.isSelected,
    required this.onTap,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  State<SelectionButton> createState() => _SelectionButtonState();
}

class _SelectionButtonState extends State<SelectionButton> {
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
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: widget.width,
        height: widget.height ?? 40,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: widget.isSelected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.primary, width: 0.5),
        ),
        child: Center(
          child: Text(
            widget.text,
            style: _getFontSize() == 14
                ? AppFonts.smMedium(
                    context,
                    color: widget.isSelected ? Colors.white : AppColors.primary,
                  )
                : _getFontSize() == 16
                ? AppFonts.mdMedium(
                    context,
                    color: widget.isSelected ? Colors.white : AppColors.primary,
                  )
                : AppFonts.lgMedium(
                    context,
                    color: widget.isSelected ? Colors.white : AppColors.primary,
                  ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
