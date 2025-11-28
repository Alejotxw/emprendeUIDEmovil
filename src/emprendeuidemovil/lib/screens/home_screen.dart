import 'package:flutter/material.dart';

class Service {
  final String id;
  final String letter;
  final String name;
  final String subtitle;
  final double price;
  final double rating;
  final String category;

  Service({
    required this.id,
    required this.letter,
    required this.name,
    required this.subtitle,
    required this.price,
    required this.rating,
    required this.category,
  });
}

class DetailScreen extends StatelessWidget {
  final Service service;

  const DetailScreen({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(service.name),
        backgroundColor: const Color(0xFF90063A),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Letter avatar
            Container(
              width: 60,
              height: 60,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  service.letter,
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF90063A),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Name
            Text(
              service.name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            // Subtitle
            Text(
              service.subtitle,
              style: TextStyle(
                fontSize: 16,
                color: const Color(0xFF757575),
              ),
            ),
            const SizedBox(height: 8),
            // Category
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF3E0),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                service.category,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFFFF9800),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Rating
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 20),
                const SizedBox(width: 8),
                Text(
                  '${service.rating.toStringAsFixed(1)} estrellas',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Price
            Text(
              '\$${service.price.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 20,
                color: Color(0xFF90063A),
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            // Action button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Contactar a ${service.name}')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF90063A),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Solicitar Servicios',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
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

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedCategoryIndex = 0;
  Set<String> _favorites = <String>{};
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Service> _services = [
    Service(
      id: '1',
      letter: 'D',
      name: 'Delicias Caseras',
      subtitle: 'Comidas preparadas con amor',
      price: 30.00,
      rating: 4.8,
      category: 'Comida',
    ),
    Service(
      id: '2',
      letter: 'M',
      name: 'Diseño Pro',
      subtitle: 'Diseño gráfico profesional para proyectos',
      price: 30.00,
      rating: 4.8,
      category: 'Diseño',
    ),
    Service(
      id: '3',
      letter: 'T',
      name: 'Delicias Caseras',
      subtitle: 'Postres deliciosos preparados con amor',
      price: 5.00,
      rating: 2.5,
      category: 'Comida',
    ),
    Service(
      id: '4',
      letter: 'A',
      name: 'Servicios de Comida',
      subtitle: 'Platos caseros preparados con amor',
      price: 8.00,
      rating: 2.5,
      category: 'Comida',
    ),
    Service(
      id: '5',
      letter: 'G',
      name: 'Comidas Caseras',
      subtitle: 'Delicias caseras',
      price: 6.00,
      rating: 2.5,
      category: 'Comida',
    ),
    Service(
      id: '6',
      letter: 'F',
      name: 'Delicias Caseras',
      subtitle: 'Servicios de comida preparados con amor',
      price: 7.00,
      rating: 2.5,
      category: 'Comida',
    ),
    // Nuevos servicios agregados
    Service(
      id: '7',
      letter: 'W',
      name: 'Web Design',
      subtitle: 'Diseño web moderno y responsive',
      price: 100.00,
      rating: 4.7,
      category: 'Diseño',
    ),
    Service(
      id: '8',
      letter: 'L',
      name: 'Logo Maker',
      subtitle: 'Creación de logos únicos y creativos',
      price: 40.00,
      rating: 4.6,
      category: 'Diseño',
    ),
    Service(
      id: '9',
      letter: 'P',
      name: 'Pasteles Personalizados',
      subtitle: 'Pasteles para ocasiones especiales',
      price: 25.00,
      rating: 4.9,
      category: 'Comida',
    ),
    // Servicios para Tecnologia
    Service(
      id: '10',
      letter: 'A',
      name: 'App Development',
      subtitle: 'Desarrollo de aplicaciones móviles personalizadas',
      price: 150.00,
      rating: 4.9,
      category: 'Tecnologia',
    ),
    Service(
      id: '11',
      letter: 'S',
      name: 'Software Solutions',
      subtitle: 'Soluciones de software a medida',
      price: 200.00,
      rating: 4.7,
      category: 'Tecnologia',
    ),
    // Servicios para Artesanias
    Service(
      id: '12',
      letter: 'H',
      name: 'Handmade Crafts',
      subtitle: 'Artesanías hechas a mano únicas',
      price: 15.00,
      rating: 4.5,
      category: 'Artesanias',
    ),
    Service(
      id: '13',
      letter: 'J',
      name: 'Joyas Artesanales',
      subtitle: 'Joyas personalizadas con materiales naturales',
      price: 50.00,
      rating: 4.8,
      category: 'Artesanias',
    ),
  ];

  List<Service> get _favoriteServices {
    return _services.where((s) => _favorites.contains(s.id)).toList();
  }

  List<Service> get _filteredServices {
    // Primero filtrar por búsqueda
    var filtered = _services.where((s) =>
        _searchQuery.isEmpty ||
        s.name.toLowerCase().contains(_searchQuery) ||
        s.subtitle.toLowerCase().contains(_searchQuery));

    // Luego filtrar por categoría si no es "Todas"
    if (_selectedCategoryIndex != 0) {
      final selectedCategory = _categories[_selectedCategoryIndex]['label'];
      filtered = filtered.where((s) => s.category == selectedCategory);
    }

    return filtered.toList();
  }

  List<Service> get _filteredTopServices {
    final filtered = _filteredServices;
    return filtered.take(2).toList();
  }

  void _toggleFavorite(String id) {
    setState(() {
      if (_favorites.contains(id)) {
        _favorites.remove(id);
      } else {
        _favorites.add(id);
      }
    });
  }

  void _navigateToDetail(Service service) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailScreen(service: service),
      ),
    );
  }

  final List<Map<String, dynamic>> _categories = [
    {'label': 'Todas', 'icon': Icons.apps},
    {'label': 'Comida', 'icon': Icons.restaurant},
    {'label': 'Diseño', 'icon': Icons.design_services},
    {'label': 'Tecnologia', 'icon': Icons.developer_mode},
    {'label': 'Artesanias', 'icon': Icons.palette},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Greeting with UIDE logo - full width
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(50),
              decoration: BoxDecoration(
                color: const Color(0xFF90063A).withOpacity(0.9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Hola, Alejandro',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(221, 255, 255, 255),
                        ),
                      ),
                      Text(
                        '¿Qué necesitas hoy?',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color.fromARGB(255, 205, 205, 205),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: const Color(0xFF90063A),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Text(
                        'U',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Rest of content with horizontal padding
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Search bar - Ahora es un TextField funcional
                  TextField(
                    controller: _searchController,
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      hintText: 'Busca servicios o emprendimientos',
                      hintStyle: const TextStyle(color: Color(0xFF9E9E9E)),
                      prefixIcon: const Icon(Icons.search, color: Color(0xFF90063A)),
                      filled: true,
                      fillColor: const Color(0xFF90063A).withOpacity(0.1),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Categories
                  SizedBox(
                    height: 40,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _categories.length,
                      itemBuilder: (context, index) {
                        final category = _categories[index];
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedCategoryIndex = index;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Seleccionado: ${category['label']}')),
                            );
                          },
                          child: _CategoryChip(
                            label: category['label'],
                            icon: category['icon'],
                            isSelected: _selectedCategoryIndex == index,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Top Destacadas section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _searchQuery.isNotEmpty ? 'Resultados de búsqueda' : 'Top Destacadas',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      if (_searchQuery.isEmpty)
                        GestureDetector(
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Ver todas las destacadas')),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF3E0),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.star, color: Color(0xFFFF9800), size: 16),
                                SizedBox(width: 4),
                                Text(
                                  'Ver todo',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFFFF9800),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Top featured horizontal cards (filtrados por categoría y búsqueda)
                  SizedBox(
                    height: 140,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _filteredTopServices.length,
                      itemBuilder: (context, index) {
                        final service = _filteredTopServices[index];
                        return Padding(
                          padding: EdgeInsets.only(right: index < _filteredTopServices.length - 1 ? 12 : 0),
                          child: _ServiceCard(
                            service: service,
                            isFavorite: _favorites.contains(service.id),
                            onCardTap: () => _navigateToDetail(service),
                            onHeartTap: () => _toggleFavorite(service.id),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Todos los emprendimientos section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _searchQuery.isNotEmpty 
                            ? 'Resultados (${_filteredServices.length})' 
                            : '${_categories[_selectedCategoryIndex]['label']} los emprendimientos',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      if (_searchQuery.isEmpty)
                        GestureDetector(
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Ver todos los emprendimientos')),
                            );
                          },
                          child: const Text(
                            'Ver todo',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF757575),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Grid of filtered services
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    childAspectRatio: 0.8,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    children: _filteredServices.map((service) {
                      return _ServiceCard(
                        service: service,
                        isFavorite: _favorites.contains(service.id),
                        onCardTap: () => _navigateToDetail(service),
                        onHeartTap: () => _toggleFavorite(service.id),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),

                  // Favoritos section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Favoritos',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Ver todos los favoritos')),
                          );
                        },
                        child: const Text(
                          'Ver todo',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF757575),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Grid of favorites or empty state
                  if (_favoriteServices.isEmpty)
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.favorite_border, size: 48, color: Color(0xFF9E9E9E)),
                            const SizedBox(height: 8),
                            const Text(
                              'No tienes favoritos aún',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF757575),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      childAspectRatio: 0.8,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      children: _favoriteServices.map((service) {
                        return _ServiceCard(
                          service: service,
                          isFavorite: true, // Siempre true aquí
                          onCardTap: () => _navigateToDetail(service),
                          onHeartTap: () => _toggleFavorite(service.id),
                        );
                      }).toList(),
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

// Category chip widget
class _CategoryChip extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool isSelected;

  const _CategoryChip({
    required this.label,
    this.icon,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFFFF3E0) : const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 16, color: isSelected ? const Color(0xFFFF9800) : const Color(0xFF9E9E9E)),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              color: isSelected ? const Color(0xFFFF9800) : const Color(0xFF757575),
            ),
          ),
        ],
      ),
    );
  }
}

// Service card widget
class _ServiceCard extends StatelessWidget {
  final Service service;
  final bool isFavorite;
  final VoidCallback onCardTap;
  final VoidCallback onHeartTap;

  const _ServiceCard({
    required this.service,
    required this.isFavorite,
    required this.onCardTap,
    required this.onHeartTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onCardTap,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF90063A),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Letter avatar
              Container(
                width: 40,
                height: 30,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    service.letter,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF90063A),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              // Name
              Text(
                service.name,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              // Subtitle
              Text(
                service.subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFFBDBDBD),
                ),
              ),
              const Spacer(),
              // Rating and heart
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        service.rating.toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: onHeartTap,
                    child: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              // Price
              Text(
                '\$${service.price.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}