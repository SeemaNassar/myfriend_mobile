import 'package:flutter/material.dart';
import 'package:myfriend_mobile/screens/settings_page.dart';

class AppRoutes {
  static const String home = '/';
  static const String prayerSettings = '/prayer-settings';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      // case home:
      //   return MaterialPageRoute(
      //     builder: (_) => const HomePage(),
      //     settings: settings,
      //   );

      case prayerSettings:
        return MaterialPageRoute(
          builder: (_) => const PrayerSettingsPage(),
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
