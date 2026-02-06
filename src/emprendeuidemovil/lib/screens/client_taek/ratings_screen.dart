import 'package:flutter/material.dart';

class RatingsScreen extends StatelessWidget {
  const RatingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rating de Servicios'),
        backgroundColor: const Color(0xFF83002A),
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('Pantalla de Rating de Servicios - Implementar cards con stars'),
      ),
    );
  }
}