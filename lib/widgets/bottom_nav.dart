import 'package:flutter/material.dart';
import 'package:myfriend_mobile/services/language_service.dart';
import 'package:myfriend_mobile/services/prayer_settings_service.dart';
import 'package:myfriend_mobile/utils/app_font.dart';
import 'package:myfriend_mobile/utils/colors.dart';

class CustomBottomNavBar extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  final LanguageService _languageService = LanguageService();
  final PrayerSettingsService _prayerSettingsService = PrayerSettingsService();

  @override
  void initState() {
    super.initState();
    _languageService.addListener(_onLanguageChanged);
    _prayerSettingsService.addListener(_onSettingsChanged);
  }

  @override
  void dispose() {
    _languageService.removeListener(_onLanguageChanged);
    _prayerSettingsService.removeListener(_onSettingsChanged);
    super.dispose();
  }

  void _onLanguageChanged() {
    setState(() {});
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
    final bool isRTL = _languageService.isRTL;

    // Define the navigation items in the desired order: Home (index 0), Settings (index 2), Medicine (index 1)
    // We want the visual order to be: Medicine (left) → Settings (middle) → Home (right)
    final List<Map<String, dynamic>> navItems = [
      {'index': 1, 'emoji': '💊', 'label': 'medication'.tr}, // Left position
      {'index': 2, 'emoji': '⚙️', 'label': 'settings'.tr}, // Middle position
      {'index': 0, 'emoji': '🏠', 'label': 'home'.tr}, // Right position
    ];

    // For RTL, we need to reverse the visual order to maintain the same positions
    // In RTL: Home (right) becomes left, Medicine (left) becomes right
    final List<Map<String, dynamic>> orderedNavItems = isRTL
        ? List.from(navItems.reversed)
        : navItems;

    return Container(
      height: 75 + MediaQuery.of(context).padding.bottom,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(0, -2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: orderedNavItems.map((item) {
            return _buildNavItem(
              context: context,
              index: item['index'],
              emoji: item['emoji'],
              label: item['label'],
              isActive: widget.currentIndex == item['index'],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required int index,
    required String emoji,
    required String label,
    required bool isActive,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: () => widget.onTap(index),
        child: Container(
          height: 75,
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(emoji, style: const TextStyle(fontSize: 24)),
              const SizedBox(height: 4),
              Text(
                label,
                style: _getFontSize() == 14
                    ? AppFonts.xsMedium(
                        context,
                        color: isActive ? Colors.white : AppColors.secondery,
                      )
                    : _getFontSize() == 16
                    ? AppFonts.smMedium(
                        context,
                        color: isActive ? Colors.white : AppColors.secondery,
                      )
                    : AppFonts.mdMedium(
                        context,
                        color: isActive ? Colors.white : AppColors.secondery,
                      ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
