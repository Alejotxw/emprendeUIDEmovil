import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String greeting;
  final VoidCallback onSearchTap;

  const CustomAppBar({
    super.key,
    required this.greeting,
    required this.onSearchTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Hola, $greeting', style: const TextStyle(fontSize: 18, color: Colors.white)),
          const SizedBox(height: 4),
          GestureDetector(
            onTap: onSearchTap,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                children: [
                  Icon(Icons.search, color: Colors.white70, size: 20),
                  SizedBox(width: 8),
                  Text('¿Qué necesitas hoy? Busca servicios o emprendimientos', style: TextStyle(color: Colors.white70)),
                ],
              ),
            ),
          ),
        ],
      ),
      actions: const [
        Icon(Icons.notifications, color: Colors.white),  // Notificaciones en header
        SizedBox(width: 16),
      ],
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 60);  // Extra espacio para search
}