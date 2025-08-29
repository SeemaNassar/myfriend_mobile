// lib/screens/main_screen.dart
import 'package:flutter/material.dart';
import 'package:myfriend_mobile/screens/home.dart';
import 'package:myfriend_mobile/screens/settings_page.dart';
import 'package:myfriend_mobile/screens/medicine_page.dart';
import 'package:myfriend_mobile/widgets/bottom_nav.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomePage(),
    const MedicationPage(),
    const PrayerSettingsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
