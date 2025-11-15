import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EmprendeUIDE'),
        backgroundColor: const Color.fromARGB(0, 255, 255, 255),
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color.fromARGB(255, 145, 0, 34), Color.fromARGB(255, 243, 173, 33)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Subtítulo
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text(
                'Encuentra servicios de estudiantes emprendedores',
                style: TextStyle(
                  fontSize: 18,
                  color: Color.fromARGB(255, 82, 82, 82),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Sección Categorías
            const Text(
              'Categorías',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 120,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: const [
                  CategoryCard(icon: Icons.fastfood, label: 'Comida'),
                  SizedBox(width: 12),
                  CategoryCard(icon: Icons.palette, label: 'Diseño'),
                  SizedBox(width: 12),
                  CategoryCard(icon: Icons.laptop, label: 'Tecnología'),
                  SizedBox(width: 12),
                  CategoryCard(icon: Icons.camera_alt, label: 'Fotografía'),
                  SizedBox(width: 12),
                  CategoryCard(icon: Icons.book, label: 'Tutorías'),
                  SizedBox(width: 12),
                  CategoryCard(icon: Icons.trending_up, label: 'Marketing'),
                  SizedBox(width: 12),
                  CategoryCard(icon: Icons.palette_outlined, label: 'Artesanías'),
                  SizedBox(width: 12),
                  CategoryCard(icon: Icons.music_note, label: 'Música'),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Sección Destacados
            Row(
              children: [
                const Text(
                  'Destacados',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.star, color: Colors.amber, size: 24),
              ],
            ),
            const SizedBox(height: 12),
            Column(
              children: [
                ServiceCard(
                  title: 'Menú del día casero',
                  price: '\$3.5',
                  description: 'Almuerzos caseros y deliciosos y salmuerzos. Incluye sopa, plato fuerte y...',
                  rating: 4.8,
                  reviews: 45,
                  user: 'María Gonzalez',
                  imageUrl: 'https://via.placeholder.com/150x100/4CAF50/FFFFFF?text=Comida',
                ),
                const SizedBox(height: 16),
                ServiceCard(
                  title: 'Diseño de logos...',
                  price: '\$25',
                  description: 'Creo logos únicos para tu marca o emprendimiento. Incluye 3...',
                  rating: 4.9,
                  reviews: 32,
                  user: 'Carlos Ramirez',
                  imageUrl: 'https://via.placeholder.com/150x100/2196F3/FFFFFF?text=Diseño',
                ),
                const SizedBox(height: 16),
                ServiceCard(
                  title: 'Reparación de...',
                  price: '\$15',
                  description: 'Reparación de PCs y dispositivos electrónicos. Servicio rápido y confiable.',
                  rating: 4.7,
                  reviews: 28,
                  user: 'Ana López',
                  imageUrl: 'https://via.placeholder.com/150x100/FF9800/FFFFFF?text=Tecnología',
                ),
              ],
            ),
            const SizedBox(height: 30),

            // Nueva Sección En Tendencia (Grid 2x2)
            Row(
              children: [
                const Text(
                  'En Tendencia',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.trending_up, color: Colors.green, size: 24),
              ],
            ),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.85, // Ajusta para matching de altura
              children: const [
                TrendCard(
                  title: 'Sesión fotográfica',
                  price: '\$35',
                  rating: 5.0,
                ),
                TrendCard(
                  title: 'Clases de matemáticas',
                  price: '\$8',
                  rating: 4.9,
                ),
                TrendCard(
                  title: 'Gestión de redes sociales',
                  price: '\$50',
                  rating: 4.8,
                ),
                TrendCard(
                  title: 'Artes artesanales',
                  price: '\$5',
                  rating: 4.6,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Widget reutilizable para categorías (con interactividad)
class CategoryCard extends StatelessWidget {
  final IconData icon;
  final String label;

  const CategoryCard({
    super.key,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Categoría seleccionada: $label'),
            backgroundColor: Colors.purple,
            duration: const Duration(seconds: 2),
          ),
        );
      },
      child: Container(
        width: 80,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: Colors.purple),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// Widget reutilizable para tarjetas de servicios destacados (con interactividad)
class ServiceCard extends StatelessWidget {
  final String title;
  final String price;
  final String description;
  final double rating;
  final int reviews;
  final String user;
  final String imageUrl;

  const ServiceCard({
    super.key,
    required this.title,
    required this.price,
    required this.description,
    required this.rating,
    required this.reviews,
    required this.user,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Abriendo detalle de: $title'),
            backgroundColor: Colors.blue,
            duration: const Duration(seconds: 2),
            action: SnackBarAction(
              label: 'Contactar',
              textColor: Colors.white,
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Enviando mensaje al emprendedor...')),
                );
              },
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                imageUrl,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 80,
                    height: 80,
                    color: Colors.grey[200],
                    child: const Icon(Icons.image_not_supported, size: 40),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(
                        price,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Row(
                        children: List.generate(5, (index) => Icon(
                          index < rating ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                          size: 16,
                        )),
                      ),
                      const SizedBox(width: 4),
                      Text('$rating ($reviews)'),
                      const SizedBox(width: 8),
                      Text(user, style: const TextStyle(fontWeight: FontWeight.w500)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Nuevo Widget para tarjetas en En Tendencia (simplificado, sin imagen)
class TrendCard extends StatelessWidget {
  final String title;
  final String price;
  final double rating;

  const TrendCard({
    super.key,
    required this.title,
    required this.price,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Abriendo detalle de: $title'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.purple[50],
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Agregado a favoritos'),
                        backgroundColor: Colors.red,
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                  child: const Icon(
                    Icons.favorite_border,
                    color: Colors.pink,
                    size: 20,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  price,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                Row(
                  children: [
                    Row(
                      children: List.generate(5, (index) => Icon(
                        index < rating ? Icons.star : Icons.star_border,
                        color: Colors.amber,
                        size: 14,
                      )),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      rating.toStringAsFixed(1),
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}