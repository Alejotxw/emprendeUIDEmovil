import 'package:flutter/material.dart';
import 'reviews_screen.dart';  // Import para Mis Reseñas
import 'ratings_screen.dart';  // Import para Rating de Servicios
import 'orders_screen.dart';  // Import para Mis Pedidos
import 'settings_screen.dart';  // Import para Configuraciones


class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
<<<<<<< Updated upstream
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            backgroundColor: const Color(0xFF90063a),
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'Perfil',
                style: TextStyle(color: Colors.white),
              ),
              background: Container(
                color: const Color(0xFF90063a),
              ),
=======
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
>>>>>>> Stashed changes
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
<<<<<<< Updated upstream
                  
                  // AVATAR
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF90063a).withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: const CircleAvatar(
                      radius: 50,
                      backgroundColor: Color(0xFF90063a),
                      child: Text(
                        'JD',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // NOMBRE
                  const Text(
                    'Juan Pérez',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF90063a),
                    ),
                  ),

                  const SizedBox(height: 4),

                  // EMAIL
                  const Text(
                    'juan.perez@uide.edu.ec',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // ROL
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF90063a).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Estudiante Emprendedor',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF90063a),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ESTADÍSTICAS
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _StatCard(label: 'Servicios', value: '12'),
                      _StatCard(label: 'Ventas', value: '45'),
                      _StatCard(
                        label: 'Rating',
                        value: '4.8',
                        icon: Icons.star,
                        color: Colors.amber,
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // MENÚ
                  _MenuItem(
                    icon: Icons.history,
                    title: 'Historial de pedidos',
                    badge: '3',
                    onTap: () => _showSnackBar(context, 'Abriendo historial...'),
                  ),
                  _MenuItem(
                    icon: Icons.favorite_border,
                    title: 'Favoritos',
                    badge: '8',
                    onTap: () => _showSnackBar(context, 'Abriendo favoritos...'),
                  ),
                  _MenuItem(
                    icon: Icons.rate_review,
                    title: 'Mis reseñas',
                    onTap: () => _showSnackBar(context, 'Abriendo reseñas...'),
                  ),
                  _MenuItem(
                    icon: Icons.settings,
                    title: 'Configuración',
=======
                  ListTile(
                    leading: const Icon(Icons.rate_review, color: Color(0xFFC8102E)),
                    title: const Text('Mis Reseñas'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
>>>>>>> Stashed changes
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ReviewsScreen()),
                      );
                    },
                  ),
<<<<<<< Updated upstream

                  const SizedBox(height: 24),

                  // BOTÓN CERRAR SESIÓN
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pushReplacementNamed(context, "/"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 218, 32, 32),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Cerrar sesión',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
=======
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
>>>>>>> Stashed changes
                  ),
                ],
              ),
            ),
<<<<<<< Updated upstream
          ),
        ],
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF90063a),
      ),
    );
  }
}

// 🌟 TARJETAS DE ESTADÍSTICAS
class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData? icon;
  final Color? color;

  const _StatCard({
    required this.label,
    required this.value,
    this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF90063a).withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: icon != null
              ? Icon(icon, size: 28, color: color)
              : Text(
                  value,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF90063a),
                  ),
                ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[700],
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

// 🌟 ITEM DE MENÚ
class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? badge;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.title,
    this.badge,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF90063a).withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF90063a)),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF90063a),
=======
            const SizedBox(height: 16),
            // Botón Cerrar Sesión (rojo)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
>>>>>>> Stashed changes
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