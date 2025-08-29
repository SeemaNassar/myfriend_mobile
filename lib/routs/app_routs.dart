// lib/routs/app_routs.dart
import 'package:flutter/material.dart';
import 'package:myfriend_mobile/screens/home.dart';
import 'package:myfriend_mobile/screens/settings_page.dart';
import 'package:myfriend_mobile/screens/medicine_page.dart';

class AppRoutes {
  static const String home = '/';
  static const String prayerSettings = '/prayer-settings';
  static const String medication = '/medication';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case prayerSettings:
        return MaterialPageRoute(
          builder: (_) => const PrayerSettingsPage(),
          settings: settings,
        );

      case medication:
        return MaterialPageRoute(
          builder: (_) => const MedicationListScreen(),
          settings: settings,
        );

      case home:
        return MaterialPageRoute(
          builder: (_) => const HomePage(),
          settings: settings,
        );

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
