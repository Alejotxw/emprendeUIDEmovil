import 'package:flutter/material.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'Todos'; // Filtro por defecto

  // Lista de filtros
  final List<String> _filters = ['Todos', 'Comida', 'Diseño', 'Tecnología', 'Foto'];

  // Datos simulados para resultados (8 items)
  final List<Map<String, dynamic>> _services = [
    {
      'title': 'Menú del día casero',
      'price': r'$3.5',
      'description': 'Almuerzos caseros deliciosos y saludables. Incluye sopa, plato fuerte y...',
      'rating': 4.8,
      'reviews': 45,
      'user': 'María González',
      'imageUrl': 'https://via.placeholder.com/150x100/4CAF50/FFFFFF?text=Comida',
      'category': 'Comida',
    },
    {
      'title': 'Diseño de logos...',
      'price': r'$25',
      'description': 'Creo logos únicos y profesionales para tu marca o emprendimiento. Incluye 3...',
      'rating': 4.9,
      'reviews': 32,
      'user': 'Carlos Ramirez',
      'imageUrl': 'https://via.placeholder.com/150x100/2196F3/FFFFFF?text=Diseño',
      'category': 'Diseño',
    },
    {
      'title': 'Reparación de...',
      'price': r'$15',
      'description': 'Mantenimiento y reparación de PCs y laptops. Diagnóstico gratuito.',
      'rating': 4.7,
      'reviews': 28,
      'user': 'Pedro Morales',
      'imageUrl': 'https://via.placeholder.com/150x100/FF9800/FFFFFF?text=Tecnología',
      'category': 'Tecnología',
    },
    {
      'title': 'Sesión fotográfica',
      'price': r'$35',
      'description': 'Sesiones creativas y profesionales para eventos o portafolios.',
      'rating': 4.8,
      'reviews': 22,
      'user': 'Laura Torres',
      'imageUrl': 'https://via.placeholder.com/150x100/9C27B0/FFFFFF?text=Foto',
      'category': 'Foto',
    },
    {
      'title': 'Clases de matemáticas',
      'price': r'$10',
      'description': 'Tutorías personalizadas para mejorar tus notas.',
      'rating': 4.9,
      'reviews': 50,
      'user': 'Ana López',
      'imageUrl': 'https://via.placeholder.com/150x100/FFC107/FFFFFF?text=Tutoría',
      'category': 'Comida', // Ejemplo para filtrado
    },
    {
      'title': 'Gestión de redes',
      'price': r'$50',
      'description': 'Estrategias para crecer tu presencia online.',
      'rating': 4.6,
      'reviews': 15,
      'user': 'Miguel Herrera',
      'imageUrl': 'https://via.placeholder.com/150x100/00BCD4/FFFFFF?text=Marketing',
      'category': 'Diseño',
    },
    {
      'title': 'Artesanías únicas',
      'price': r'$5',
      'description': 'Piezas hechas a mano con materiales locales.',
      'rating': 4.5,
      'reviews': 20,
      'user': 'Sofía Vargas',
      'imageUrl': 'https://via.placeholder.com/150x100/E91E63/FFFFFF?text=Artesanía',
      'category': 'Tecnología',
    },
    {
      'title': 'Edición de video',
      'price': r'$20',
      'description': 'Videos profesionales para redes sociales.',
      'rating': 4.7,
      'reviews': 35,
      'user': 'Diego Ruiz',
      'imageUrl': 'https://via.placeholder.com/150x100/8BC34A/FFFFFF?text=Video',
      'category': 'Foto',
    },
  ];

  // Filtrar servicios basados en _selectedFilter
  List<Map<String, dynamic>> get _filteredServices {
    if (_selectedFilter == 'Todos') {
      return _services;
    }
    return _services.where((service) => service['category'] == _selectedFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Explorar'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.purple, Colors.blue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(80.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                // Barra de búsqueda
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Buscar servicios...',
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    suffixIcon: const Icon(Icons.filter_list, color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
                const SizedBox(height: 8),
                // Chips de filtros
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _filters.map((filter) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ChoiceChip(
                          label: Text(filter),
                          selected: _selectedFilter == filter,
                          onSelected: (selected) {
                            if (selected) {
                              setState(() {
                                _selectedFilter = filter;
                              });
                            }
                          },
                          selectedColor: Colors.purple[100],
                          backgroundColor: Colors.white,
                          labelStyle: TextStyle(
                            color: _selectedFilter == filter ? Colors.purple : Colors.grey,
                            fontWeight: _selectedFilter == filter ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Contador de resultados
            Text(
              '${_filteredServices.length} resultados',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            // Lista de servicios
            Expanded(
              child: ListView.builder(
                itemCount: _filteredServices.length,
                itemBuilder: (context, index) {
                  final service = _filteredServices[index];
                  return ServiceCard(
                    title: service['title'],
                    price: service['price'],
                    description: service['description'],
                    rating: service['rating'],
                    reviews: service['reviews'],
                    user: service['user'],
                    imageUrl: service['imageUrl'],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

// Widget reutilizable para tarjetas de servicios
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
        margin: const EdgeInsets.only(bottom: 16),
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