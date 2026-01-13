import 'package:flutter/material.dart';

class ContactInfoScreen extends StatelessWidget {
  const ContactInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.handshake, size: 80, color: Color(0xFF83002A)), // Color UIDE
            const SizedBox(height: 24),
            const Text(
              '¡Pedido Pendiente!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const Text(
              'Has seleccionado pago en físico.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            // Tarjeta de Información
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: const Column(
                children: [
                  Text(
                    'Acércate al emprendedor para realizar el pago y retirar tu producto:',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14),
                  ),
                  Divider(height: 30),
                  Row(
                    children: [
                      Icon(Icons.person, color: Color(0xFF83002A)),
                      SizedBox(width: 12),
                      Text('Nombre:', style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(width: 8),
                      Text('Emprendedor UIDE'),
                    ],
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.phone, color: Color(0xFF83002A)),
                      SizedBox(width: 12),
                      Text('Celular:', style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(width: 8),
                      Text('099 123 4567'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            // Botón Volver al Inicio
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF83002A),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  // Vuelve a la pantalla principal y borra el historial de navegación
                  Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
                },
                child: const Text(
                  'Volver al Inicio',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}