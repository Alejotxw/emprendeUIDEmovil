import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF90063A),
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(service.name),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header con avatar grande y rating
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Color(0xFF90063A),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: Text(
                      service.letter,
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF90063A),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    service.name,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    service.subtitle,
                    style: const TextStyle(fontSize: 16, color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 28),
                      const SizedBox(width: 8),
                      Text(
                        service.rating.toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '(${service.rating >= 4.5 ? 'Muy recomendado' : 'Bueno'})',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Tarjeta de información
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Información',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF90063A),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildInfoRow(
                        Icons.access_time,
                        'Horario',
                        'Lun-Vie 10:00 - 16:00',
                      ),
                      const SizedBox(height: 12),
                      _buildInfoRow(
                        Icons.location_on,
                        'Ubicación',
                        'Campus UIDE, Cafetería',
                      ),
                      const SizedBox(height: 12),
                      _buildInfoRow(Icons.person, 'Emprendedor', 'Romy Ríos'),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Servicios disponibles
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.menu_book, color: Color(0xFF90063A)),
                          SizedBox(width: 10),
                          Text(
                            'Servicios Disponibles',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildServiceItem(
                        'Almuerzos',
                        'Menú del día con sopa y seco',
                        '\$2.50',
                      ),
                      const SizedBox(height: 12),
                      _buildServiceItem(
                        'Postres',
                        'Tortas, brownies, y más',
                        '\$2.50',
                        isSelected: true,
                      ),
                      const SizedBox(height: 12),
                      _buildServiceItem(
                        'Bebidas',
                        'Jugos naturales y café',
                        '\$1.00',
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),

            // Botón grande
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('¡Solicitando servicio a ${service.name}!'),
                      backgroundColor: const Color(0xFF90063A),
                    ),
                  );
                },
                icon: const Icon(Icons.send, size: 28),
                label: const Text(
                  'Solicitar Servicio',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF90063A),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 8,
                  minimumSize: const Size(double.infinity, 60),
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  static Widget _buildInfoRow(IconData icon, String title, String value) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF90063A), size: 26),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            Text(
              value,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ],
    );
  }

  static Widget _buildServiceItem(
    String title,
    String description,
    String price, {
    bool isSelected = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFFFF3E0) : Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? const Color(0xFFFF9800) : Colors.transparent,
          width: 2,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),
              ],
            ),
          ),
          if (isSelected)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF90063A),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Seleccionado',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          const SizedBox(width: 12),
          Text(
            price,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF90063A),
            ),
          ),
        ],
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
  final Set<String> _favorites = {};
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  List<Service> _services = []; // ← viene de Firestore
  bool _loading = true; // ← indicador de carga
  String? _error; // ← mensaje de error opcional

  @override
  void initState() {
    super.initState();

    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });

    _loadServicesFromFirestore(); // ← cargar Firestore al iniciar
  }

  Future<void> _loadServicesFromFirestore() async {
    try {
      final snap = await FirebaseFirestore.instance
          .collection('products')
          .where('isActive', isEqualTo: true)
          .get();

      final list = snap.docs.map((doc) {
        final data = doc.data();

        return Service(
          id: doc.id,
          letter: (data['title'] ?? '?')[0].toUpperCase(),
          name: data['title'] ?? 'Sin nombre',
          subtitle: data['description'] ?? '',
          price: (data['price'] is num) ? data['price'].toDouble() : 0.0,
          rating: 4.8, // si no tienes rating aún
          category: data['category'] ?? 'Otros',
        );
      }).toList();

      setState(() {
        _services = list;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
        _error = "Error cargando catálogo: $e";
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Service> get _favoriteServices =>
      _services.where((s) => _favorites.contains(s.id)).toList();

  List<Service> get _filteredServices {
    var filtered = _services.where(
      (s) =>
          _searchQuery.isEmpty ||
          s.name.toLowerCase().contains(_searchQuery) ||
          s.subtitle.toLowerCase().contains(_searchQuery),
    );

    if (_selectedCategoryIndex != 0) {
      final selectedCategory = _categories[_selectedCategoryIndex]['label'];
      filtered = filtered.where((s) => s.category == selectedCategory);
    }

    return filtered.toList();
  }

  List<Service> get _filteredTopServices => _filteredServices.take(2).toList();

  void _toggleFavorite(String id) {
    setState(() {
      _favorites.contains(id) ? _favorites.remove(id) : _favorites.add(id);
    });
  }

  void _navigateToDetail(Service service) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => DetailScreen(service: service)),
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
    final bottomPadding = MediaQuery.of(context).padding.bottom + 100;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator()) // ← loading
            : _error != null
            ? Center(child: Text(_error!)) // ← error
            : SingleChildScrollView(
                padding: EdgeInsets.only(bottom: bottomPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ----- TODO TU DISEÑO ORIGINAL -----
                    // HEADER
                    Container(
                      margin: const EdgeInsets.all(16),
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: const Color(0xFF90063A).withOpacity(0.95),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Hola, Alejandro',
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                '¿Qué necesitas hoy?',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    '/notifications',
                                  );
                                },
                                icon: const Icon(
                                  Icons.notifications,
                                  color: Colors.white,
                                  size: 28,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const CircleAvatar(
                                radius: 28,
                                backgroundColor: Colors.white,
                                child: Text(
                                  'U',
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF90063A),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // ------- BUSCADOR + FILTROS + GRID -------
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: 'Buscar servicios...',
                              prefixIcon: const Icon(
                                Icons.search,
                                color: Color(0xFF90063A),
                              ),
                              filled: true,
                              fillColor: const Color(
                                0xFF90063A,
                              ).withOpacity(0.08),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Categorías
                          SizedBox(
                            height: 44,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: _categories.length,
                              itemBuilder: (_, i) {
                                final cat = _categories[i];
                                final selected = _selectedCategoryIndex == i;
                                return GestureDetector(
                                  onTap: () => setState(
                                    () => _selectedCategoryIndex = i,
                                  ),
                                  child: Container(
                                    margin: const EdgeInsets.only(right: 10),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 18,
                                      vertical: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      color: selected
                                          ? const Color(0xFFFFF3E0)
                                          : const Color(0xFFF5F5F5),
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          cat['icon'],
                                          size: 18,
                                          color: selected
                                              ? const Color(0xFFFF9800)
                                              : Colors.grey[600],
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          cat['label'],
                                          style: TextStyle(
                                            fontWeight: selected
                                                ? FontWeight.w600
                                                : FontWeight.normal,
                                            color: selected
                                                ? const Color(0xFFFF9800)
                                                : Colors.grey[700],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 24),

                          // TOP DESTACADAS
                          Text(
                            _searchQuery.isEmpty
                                ? 'Top Destacadas'
                                : 'Resultados',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),

                          SizedBox(
                            height: 200,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: _filteredTopServices.length,
                              itemBuilder: (_, i) {
                                final service = _filteredTopServices[i];
                                return Padding(
                                  padding: EdgeInsets.only(
                                    right: i < _filteredTopServices.length - 1
                                        ? 12
                                        : 0,
                                  ),
                                  child: ServiceCard(
                                    service: service,
                                    isFavorite: _favorites.contains(service.id),
                                    onCardTap: () => _navigateToDetail(service),
                                    onHeartTap: () =>
                                        _toggleFavorite(service.id),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Lista principal
                          Text(
                            _searchQuery.isNotEmpty
                                ? 'Resultados (${_filteredServices.length})'
                                : '${_categories[_selectedCategoryIndex]['label']} los emprendimientos',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),

                          GridView.count(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisCount: 2,
                            childAspectRatio: 0.75,
                            crossAxisSpacing: 14,
                            mainAxisSpacing: 14,
                            children: _filteredServices
                                .map(
                                  (s) => ServiceCard(
                                    service: s,
                                    isFavorite: _favorites.contains(s.id),
                                    onCardTap: () => _navigateToDetail(s),
                                    onHeartTap: () => _toggleFavorite(s.id),
                                  ),
                                )
                                .toList(),
                          ),

                          const SizedBox(height: 24),

                          const Text(
                            'Favoritos',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),

                          _favoriteServices.isEmpty
                              ? Container(
                                  height: 180,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF8F8F8),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: const Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.favorite_border,
                                          size: 50,
                                          color: Colors.grey,
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          'Aún no tienes favoritos',
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : GridView.count(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  crossAxisCount: 2,
                                  childAspectRatio: 0.75,
                                  crossAxisSpacing: 14,
                                  mainAxisSpacing: 14,
                                  children: _favoriteServices
                                      .map(
                                        (s) => ServiceCard(
                                          service: s,
                                          isFavorite: true,
                                          onCardTap: () => _navigateToDetail(s),
                                          onHeartTap: () =>
                                              _toggleFavorite(s.id),
                                        ),
                                      )
                                      .toList(),
                                ),

                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

class ServiceCard extends StatelessWidget {
  final Service service;
  final bool isFavorite;
  final VoidCallback onCardTap;
  final VoidCallback onHeartTap;

  const ServiceCard({
    super.key,
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
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFF90063A),
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            CircleAvatar(
              radius: 26,
              backgroundColor: Colors.white,
              child: Text(
                service.letter,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF90063A),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              service.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              service.subtitle,
              style: const TextStyle(color: Colors.white70, fontSize: 12),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.star, size: 16, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text(
                      service.rating.toStringAsFixed(1),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: onHeartTap,
                  child: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '\$${service.price.toStringAsFixed(2)}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
