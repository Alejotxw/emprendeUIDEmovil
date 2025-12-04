import 'package:flutter/material.dart';
import 'configuration_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            backgroundColor: const Color(0xFF90063a),
            flexibleSpace: const FlexibleSpaceBar(
              title: Text('Perfil', style: TextStyle(color: Colors.white)),
              background: ColoredBox(color: Color(0xFF90063a)),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
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
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),

                  const SizedBox(height: 8),

                  // ROL
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
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
                    children: const [
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
                    onTap: () =>
                        _showSnackBar(context, 'Abriendo historial...'),
                  ),
                  _MenuItem(
                    icon: Icons.favorite_border,
                    title: 'Favoritos',
                    badge: '8',
                    onTap: () =>
                        _showSnackBar(context, 'Abriendo favoritos...'),
                  ),
                  _MenuItem(
                    icon: Icons.rate_review,
                    title: 'Mis reseñas',
                    onTap: () => _showSnackBar(context, 'Abriendo reseñas...'),
                  ),

                  // 👇 NUEVO: Notificaciones
                  _MenuItem(
                    icon: Icons.notifications_active,
                    title: 'Notificaciones',
                    onTap: () {
                      Navigator.pushNamed(context, '/notifications');
                    },
                  ),

                  _MenuItem(
                    icon: Icons.settings,
                    title: 'Configuración',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ConfigurationScreen(),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 24),

                  // BOTÓN CERRAR SESIÓN
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Aquí más adelante puedes limpiar SharedPreferences

                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/login',
                          (route) => false,
                        );
                      },
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
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static void _showSnackBar(BuildContext context, String message) {
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
                ),
              ),
            ),
            if (badge != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF90063a).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  badge!,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF90063a),
                  ),
                ),
              ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
