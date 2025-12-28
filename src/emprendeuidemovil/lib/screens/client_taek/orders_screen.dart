import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(t.myOrders), // Título traducible
        backgroundColor: const Color(0xFFC8102E),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Text(t.myOrders + ' - Implementar lista de pedidos con status'),
      ),
    );
  }
}