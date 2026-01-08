import 'package:flutter/material.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Pedidos'),
        backgroundColor: const Color.fromARGB(255, 131, 0, 41),
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('Pantalla de Mis Pedidos - Implementar lista de pedidos con status'),
      ),
    );
  }
}