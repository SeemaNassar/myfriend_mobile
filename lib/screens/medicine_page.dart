// lib/screens/medication_page.dart
import 'package:flutter/material.dart';
import 'package:myfriend_mobile/services/language_service.dart';

class MedicationPage extends StatelessWidget {
  const MedicationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final languageService = LanguageService();

    return Directionality(
      textDirection: languageService.textDirection,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5DC),
        appBar: AppBar(
          backgroundColor: const Color(0xFFF5F5DC),
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              languageService.isRTL ? Icons.arrow_forward : Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            'medication'.tr,
            style: const TextStyle(
              color: Color(0xFF4A7C59),
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
        ),
        body: Center(
          child: Text(
            'medication_page_coming_soon'.tr,
            style: const TextStyle(
              fontSize: 18,
              color: Color(0xFF8B4513),
            ),
          ),
        ),
      ),
    );
  }
}
