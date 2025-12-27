import 'package:flutter/material.dart';
import 'reviews_screen.dart'; // Mis Reseñas
import 'ratings_screen.dart'; // Rating de Servicios
import 'orders_screen.dart'; // Mis Pedidos
import '../settings_screen.dart'; // Configuraciones
import '../../l10n/app_localizations.dart';

class ProfileScreen extends StatelessWidget {
  final Function(Locale) setLocale; // Recibe función para cambiar idioma
  const ProfileScreen({super.key, required this.setLocale});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(t.profile),
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
            // Botones Cliente / Emprendedor
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Modo Cliente activado')),
                    );
                  },
                  child: const Text('Cliente'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Modo Emprendedor activado'),
                      ),
                    );
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
                    leading: const Icon(
                      Icons.rate_review,
                      color: Color(0xFFC8102E),
                    ),
                    title: Text(t.myReviews),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReviewsScreen(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.star, color: Color(0xFFC8102E)),
                    title: Text(t.serviceRating),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RatingsScreen(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.shopping_cart,
                      color: Color(0xFFC8102E),
                    ),
                    title: Text(t.myOrders),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => OrdersScreen()),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.settings,
                      color: Color(0xFFC8102E),
                    ),
                    title: Text(t.settings),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              SettingsScreen(setLocale: setLocale),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Botón Cerrar Sesión
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Sesión cerrada')),
                  );
                  Navigator.popUntil(context, ModalRoute.withName('/login'));
                },
                child: Text(
                  t.logout,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
