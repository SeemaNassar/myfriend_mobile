//lib\widgets\custom_switch.dart
import 'package:flutter/material.dart';

class CustomSwitch extends StatefulWidget {
  final bool initialValue;
  final Function(bool) onChanged;
  final Color activeColor;
  final Color inactiveColor;

  const CustomSwitch({
    Key? key,
    required this.initialValue,
    required this.onChanged,
    this.activeColor = const Color(0xFF4A7C59),
    this.inactiveColor = const Color(0xFFE0E0E0),
  }) : super(key: key);

  @override
  State<CustomSwitch> createState() => _CustomPrayerSwitchState();
}

class _CustomPrayerSwitchState extends State<CustomSwitch> {
  late bool isEnabled;

  @override
  void initState() {
    super.initState();
    isEnabled = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isEnabled = !isEnabled;
        });
        widget.onChanged(isEnabled);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 50,
        height: 28,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: isEnabled ? widget.activeColor : widget.inactiveColor,
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 200),
          alignment: isEnabled ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            margin: const EdgeInsets.all(2),
            width: 24,
            height: 24,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}
