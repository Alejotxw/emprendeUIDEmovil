import 'package:flutter/material.dart';

class ContactInfoScreen extends StatelessWidget {
  final String entrepreneurName;
  final String entrepreneurPhone;

  const ContactInfoScreen({
    super.key,
    this.entrepreneurName = "Emprendedor UIDE", // Valor por defecto o dinámico
    this.entrepreneurPhone = "099 123 4567",
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.handshake, size: 80, color: Color(0xFFC8102E)), // Color institucional
            const SizedBox(height: 24),
            const Text(
              '¡Pedido Registrado!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const Text(
              'Has seleccionado pago en físico.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            // Tarjeta de Información de Contacto
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Column(
                children: [
                  const Text(
                    'Ponte en contacto con el emprendedor para coordinar el pago y entrega:',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14),
                  ),
                  const Divider(height: 30),
                  _buildInfoRow(Icons.person, 'Nombre:', entrepreneurName),
                  const SizedBox(height: 12),
                  _buildInfoRow(Icons.phone, 'Celular:', entrepreneurPhone),
                ],
              ),
            ),
            const Spacer(),
            // Botón Volver al Inicio
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFC8102E),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  // Navegar al inicio y borrar historial
                  Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
                },
                child: const Text('Volver al Inicio', style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFFC8102E), size: 20),
        const SizedBox(width: 12),
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(width: 8),
        Text(value),
      ],
    );
  }
}