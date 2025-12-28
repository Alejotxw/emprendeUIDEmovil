import 'package:flutter/material.dart';
import 'reviews_screen.dart';  // Import para Mis Reseñas
import 'ratings_screen.dart';  // Import para Rating de Servicios
import 'orders_screen.dart';  // Import para Mis Pedidos
import '../settings_screen.dart';  // Import para Configuraciones

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Perfil'),
        backgroundColor: const Color(0xFFC8102E),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Avatar
            const CircleAvatar(
              radius: 50,
              backgroundColor: Color(0xFFC8102E),
              child: Icon(Icons.person, size: 50, color: Colors.white),
            ),
            const SizedBox(height: 16),
            // Nombre
            const Text(
              'Sebastián Chocho',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            // Email
            const Text(
              'sebastianchocho@uide.edu.ec',
              style: TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            // Botones Cliente / Emprendedor (centrados uno al lado del otro)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Modo Cliente activado')));
                  },
                  child: const Text('Cliente'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Modo Emprendedor activado')));
                  },
                  child: const Text('Emprendedor'),
                ),
              ],
            ),
            const SizedBox(height: 32),
            // Lista de secciones (con navegación)
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    leading: const Icon(Icons.rate_review, color: Color(0xFFC8102E)),
                    title: const Text('Mis Reseñas'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ReviewsScreen()),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.star, color: Color(0xFFC8102E)),
                    title: const Text('Rating de Servicios'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const RatingsScreen()),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.shopping_cart, color: Color(0xFFC8102E)),
                    title: const Text('Mis Pedidos'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const OrdersScreen()),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.settings, color: Color(0xFFC8102E)),
                    title: const Text('Configuraciones'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SettingsScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Botón Cerrar Sesión (rojo)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Sesión cerrada')));
                  Navigator.popUntil(context, ModalRoute.withName('/login'));
                },
                child: const Text('Cerrar sesión', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}