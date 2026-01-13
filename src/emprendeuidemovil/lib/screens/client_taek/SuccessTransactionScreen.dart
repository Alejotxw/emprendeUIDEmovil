import 'package:flutter/material.dart';

class SuccessTransactionScreen extends StatelessWidget {
  const SuccessTransactionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle_outline, size: 100, color: Colors.green),
              const SizedBox(height: 20),
              const Text('¡Transacción Exitosa!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              const Text('Tu comprobante ha sido enviado. El emprendedor verificará la transferencia.', textAlign: TextAlign.center),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFC8102E),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    // Navegar al inicio
                    Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
                  },
                  child: const Text('Volver al Inicio', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}