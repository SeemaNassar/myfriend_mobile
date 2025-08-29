// lib/widgets/custom_time_picker.dart
import 'package:flutter/material.dart';

class CustomTimePicker extends StatefulWidget {
  final TimeOfDay initialTime;
  final Function(TimeOfDay) onTimeChanged;

  const CustomTimePicker({
    Key? key,
    required this.initialTime,
    required this.onTimeChanged,
  }) : super(key: key);

  @override
  _CustomTimePickerState createState() => _CustomTimePickerState();
}

class _CustomTimePickerState extends State<CustomTimePicker> {
  late TimeOfDay _selectedTime;
  late FixedExtentScrollController _hourController;
  late FixedExtentScrollController _minuteController;
  late FixedExtentScrollController _periodController;

  @override
  void initState() {
    super.initState();
    _selectedTime = widget.initialTime;

    _hourController = FixedExtentScrollController(
      initialItem:
          _selectedTime.hourOfPeriod == 0 ? 11 : _selectedTime.hourOfPeriod - 1,
    );

    _minuteController = FixedExtentScrollController(
      initialItem: _selectedTime.minute,
    );

    _periodController = FixedExtentScrollController(
      initialItem: _selectedTime.period == DayPeriod.am ? 0 : 1,
    );
  }

  @override
  void dispose() {
    _hourController.dispose();
    _minuteController.dispose();
    _periodController.dispose();
    super.dispose();
  }

  void _handleHourChange(int hourIndex) {
    int newDisplayHour = (hourIndex % 12) + 1;
    if (newDisplayHour < 1) newDisplayHour = 12;

    int currentDisplayHour =
        _selectedTime.hourOfPeriod == 0 ? 12 : _selectedTime.hourOfPeriod;

    bool scrollingFrom11To12 =
        (currentDisplayHour == 11 && newDisplayHour == 12);
    bool scrollingFrom12To11 =
        (currentDisplayHour == 12 && newDisplayHour == 11);

    DayPeriod newPeriod = _selectedTime.period;

    if (scrollingFrom11To12 || scrollingFrom12To11) {
      newPeriod =
          (_selectedTime.period == DayPeriod.am) ? DayPeriod.pm : DayPeriod.am;
      _periodController.jumpToItem(newPeriod == DayPeriod.am ? 0 : 1);
    }

    int newHour;
    if (newPeriod == DayPeriod.am) {
      newHour = newDisplayHour == 12 ? 0 : newDisplayHour;
    } else {
      newHour = newDisplayHour == 12 ? 12 : newDisplayHour + 12;
    }

    setState(() {
      _selectedTime = TimeOfDay(hour: newHour, minute: _selectedTime.minute);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 70,
      decoration: BoxDecoration(
        color: Color(0xFF2D2D2D).withOpacity(0.85),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // AM/PM picker
                _buildPickerWheel(
                  controller: _periodController,
                  itemCount: 2,
                  builder: (context, index) {
                    bool isAM = index == 0;
                    bool isSelected =
                        (isAM && _selectedTime.period == DayPeriod.am) ||
                            (!isAM && _selectedTime.period == DayPeriod.pm);

                    return Container(
                      height: 50,
                      alignment: Alignment.center,
                      child: Text(
                        isAM ? 'AM' : 'PM',
                        style: TextStyle(
                          fontSize: 22,
                          color: isSelected ? Colors.white : Colors.grey[600],
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    );
                  },
                  onSelectedItemChanged: (int index) {
                    setState(() {
                      bool isSelectingAM = index == 0;
                      int currentDisplayHour = _selectedTime.hourOfPeriod == 0
                          ? 12
                          : _selectedTime.hourOfPeriod;

                      int newHour;
                      if (isSelectingAM) {
                        newHour =
                            currentDisplayHour == 12 ? 0 : currentDisplayHour;
                      } else {
                        newHour = currentDisplayHour == 12
                            ? 12
                            : currentDisplayHour + 12;
                      }

                      _selectedTime = TimeOfDay(
                          hour: newHour, minute: _selectedTime.minute);
                    });
                  },
                ),

                // Minute picker
                _buildPickerWheel(
                  controller: _minuteController,
                  itemCount: 60,
                  builder: (context, index) {
                    int minute = index;
                    final isSelected = minute == _selectedTime.minute;
                    return Container(
                      height: 50,
                      alignment: Alignment.center,
                      child: Text(
                        minute.toString().padLeft(2, '0'),
                        style: TextStyle(
                          fontSize: 28,
                          color: isSelected ? Colors.white : Colors.grey[600],
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    );
                  },
                  onSelectedItemChanged: (int index) {
                    setState(() {
                      _selectedTime = TimeOfDay(
                        hour: _selectedTime.hour,
                        minute: index,
                      );
                    });
                  },
                ),

                // Hour picker
                _buildPickerWheel(
                  controller: _hourController,
                  itemCount: 12,
                  builder: (context, index) {
                    int hour = (index % 12) + 1;
                    if (hour < 1) hour = 12;
                    int currentHour = _selectedTime.hourOfPeriod == 0
                        ? 12
                        : _selectedTime.hourOfPeriod;
                    bool isSelected = hour == currentHour;

                    return Container(
                      height: 50,
                      alignment: Alignment.center,
                      child: Text(
                        hour.toString(),
                        style: TextStyle(
                          fontSize: 28,
                          color: isSelected ? Colors.white : Colors.grey[600],
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    );
                  },
                  onSelectedItemChanged: _handleHourChange,
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              border:
                  Border(top: BorderSide(color: Colors.grey[800]!, width: 1)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    widget.onTimeChanged(_selectedTime);
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Done',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _selectedTime = widget.initialTime;
                      _hourController.jumpToItem(_selectedTime.hourOfPeriod == 0
                          ? 11
                          : _selectedTime.hourOfPeriod - 1);
                      _minuteController.jumpToItem(_selectedTime.minute);
                      _periodController.jumpToItem(
                          _selectedTime.period == DayPeriod.am ? 0 : 1);
                    });
                  },
                  child: Text(
                    'Reset',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimeOfDay(TimeOfDay time) {
    final hour = time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    final displayHour = hour == 0 ? 12 : hour;
    return '${displayHour}:${minute} ${period}';
  }

  Widget _buildPickerWheel({
    required FixedExtentScrollController controller,
    required int itemCount,
    required IndexedWidgetBuilder builder,
    required ValueChanged<int> onSelectedItemChanged,
  }) {
    return Container(
      width: 60,
      height: 200,
      child: ListWheelScrollView.useDelegate(
        controller: controller,
        itemExtent: 50,
        perspective: 0.005,
        diameterRatio: 1.2,
        physics: FixedExtentScrollPhysics(),
        onSelectedItemChanged: onSelectedItemChanged,
        childDelegate: itemCount == 2
            ? ListWheelChildListDelegate(
                children: List.generate(
                    itemCount, (index) => builder(context, index)),
              )
            : ListWheelChildLoopingListDelegate(
                children: List.generate(
                    itemCount, (index) => builder(context, index)),
              ),
      ),
    );
  }
}
