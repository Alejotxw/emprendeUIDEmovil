import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';

class RatingsScreen extends StatelessWidget {
  const RatingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(t.serviceRating), // Usar la traducción
        backgroundColor: const Color(0xFFC8102E),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Text(t.serviceRating + ' - Implementar cards con stars'),
      ),
    );
  }
}