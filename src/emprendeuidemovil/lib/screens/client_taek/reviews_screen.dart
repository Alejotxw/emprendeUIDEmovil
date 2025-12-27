import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';

class ReviewsScreen extends StatelessWidget {
  const ReviewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(t.myReviews), // Ahora usa el texto traducible
        backgroundColor: const Color(0xFFC8102E),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Text(
          t.myReviews + ' - Implementar lista de reseñas con check/trash',
        ),
      ),
    );
  }
}
