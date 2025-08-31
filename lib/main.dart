import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:myfriend_mobile/routs/app_routs.dart';
import 'package:myfriend_mobile/services/language_service.dart';
import 'package:myfriend_mobile/services/prayer_settings_service.dart';
import 'package:myfriend_mobile/services/prayer_times_service.dart';
import 'package:myfriend_mobile/screens/main_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final LanguageService _languageService = LanguageService();
  final PrayerSettingsService _prayerSettingsService = PrayerSettingsService();
  final PrayerTimesService _prayerTimesService = PrayerTimesService();
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _languageService.addListener(_onLanguageChanged);
    _initializeApp();
  }

  @override
  void dispose() {
    _languageService.removeListener(_onLanguageChanged);
    super.dispose();
  }

  void _onLanguageChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _initializeApp() async {
    try {
      final userId = await _getUserId();

      _prayerSettingsService.setUserId(userId);
      _prayerTimesService.setUserId(userId);

      await _prayerSettingsService.initialize();
      await _prayerTimesService.loadPrayerTimes();

      final savedLanguage = await _languageService.getSavedLanguage();
      await _languageService.loadLanguage(savedLanguage);

      setState(() {
        _isInitialized = true;
      });
    } catch (e) {
      print('Error initializing app: $e');
      await _languageService.loadLanguage('en');
      setState(() {
        _isInitialized = true;
      });
    }
  }

  Future<String> _getUserId() async {
    return 'user123';
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return MaterialApp(
        home: Scaffold(
          body: Container(
            color: const Color(0xFFF5F5DC),
            child: const Center(
              child: CircularProgressIndicator(color: Color(0xFF4A7C59)),
            ),
          ),
        ),
      );
    }

    return MaterialApp(
      title: 'MyFriend Mobile',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en', ''), Locale('ar', '')],
      locale: _languageService.currentLocale,
      localeResolutionCallback: (locale, supportedLocales) {
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale?.languageCode) {
            return supportedLocale;
          }
        }
        return supportedLocales.first;
      },
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: const Color(0xFFF5F5DC),
        fontFamily: 'Roboto',
      ),
      home: const MainScreen(),
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}
