import 'package:flutter/material.dart';
<<<<<<< Updated upstream

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
                        '${service.rating.toStringAsFixed(1)}',
                        style: const TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '(${service.rating >= 4.5 ? 'Muy recomendado' : 'Bueno'})',
                        style: const TextStyle(fontSize: 14, color: Colors.white70),
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
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Información', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF90063A))),
                      const SizedBox(height: 16),
                      _buildInfoRow(Icons.access_time, 'Horario', 'Lun-Vie 10:00 - 16:00'),
                      const SizedBox(height: 12),
                      _buildInfoRow(Icons.location_on, 'Ubicación', 'Campus UIDE, Cafetería'),
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
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.menu_book, color: Color(0xFF90063A)),
                          const SizedBox(width: 10),
                          const Text('Servicios Disponibles', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildServiceItem('Almuerzos', 'Menú del día con sopa y seco', '\$2.50'),
                      const SizedBox(height: 12),
                      _buildServiceItem('Postres', 'Tortas, brownies, y más', '\$2.50', isSelected: true),
                      const SizedBox(height: 12),
                      _buildServiceItem('Bebidas', 'Jugos naturales y café', '\$1.00'),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),

            // Botón grande y bonito
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
                label: const Text('Solicitar Servicio', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF90063A),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
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

  Widget _buildInfoRow(IconData icon, String title, String value) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF90063A), size: 26),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 14, color: Colors.grey)),
            Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          ],
        ),
      ],
    );
  }

  Widget _buildServiceItem(String title, String description, String price, {bool isSelected = false}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFFFF3E0) : Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isSelected ? const Color(0xFFFF9800) : Colors.transparent, width: 2),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(description, style: const TextStyle(fontSize: 13, color: Colors.grey)),
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
              child: const Text('Seleccionado', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
            ),
          const SizedBox(width: 12),
          Text(price, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF90063A))),
        ],
      ),
    );
  }
}
=======
import 'package:provider/provider.dart';
import '../providers/service_provider.dart';
import '../widgets/service_card.dart';
import '../models/service_model.dart';
import 'detail_screen.dart';  // Import para navegación a detalle
>>>>>>> Stashed changes

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> _categories = [
    'Comida', 'Tutorías', 'Portafolios', 'Consultas', 'Diseños', 'Libros',
    'Plantillas', 'Idioma', 'Redacciones', 'Prototipos', 'Investigaciones',
    'Arte', 'Presentaciones', 'Accesorios',
  ];

  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

<<<<<<< Updated upstream
  @override
  void initState() {
    super.initState();
    _searchController.addListener(() => setState(() => _searchQuery = _searchController.text.toLowerCase()));
=======
  // Sugerencias para autocomplete (categorías + nombres de servicios comunes)
  List<String> _getSuggestions(String query) {
    final lowerQuery = query.toLowerCase();
    final suggestions = <String>[];
    // Sugiere categorías que coincidan
    suggestions.addAll(_categories.where((cat) => cat.toLowerCase().contains(lowerQuery)).toList());
    // Sugiere nombres de servicios (del provider)
    final provider = Provider.of<ServiceProvider>(context, listen: false);
    suggestions.addAll(provider.allServices
        .where((s) => s.name.toLowerCase().contains(lowerQuery))
        .map((s) => s.name)
        .take(5));  // Limita a 5 para no sobrecargar
    return suggestions.isNotEmpty ? suggestions : ['No hay opciones exactas. Prueba con "${lowerQuery}" relacionado'];
>>>>>>> Stashed changes
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

<<<<<<< Updated upstream
  final List<Service> _services = [
    Service(id: '1', letter: 'D', name: 'Delicias Caseras', subtitle: 'Comidas preparadas con amor', price: 30.00, rating: 4.8, category: 'Comida'),
    Service(id: '2', letter: 'M', name: 'Diseño Pro', subtitle: 'Diseño gráfico profesional para proyectos', price: 30.00, rating: 4.8, category: 'Diseño'),
    Service(id: '3', letter: 'T', name: 'Delicias Caseras', subtitle: 'Postres deliciosos preparados con amor', price: 5.00, rating: 2.5, category: 'Comida'),
    Service(id: '4', letter: 'A', name: 'Servicios de Comida', subtitle: 'Platos caseros preparados con amor', price: 8.00, rating: 2.5, category: 'Comida'),
    Service(id: '5', letter: 'G', name: 'Comidas Caseras', subtitle: 'Delicias caseras', price: 6.00, rating: 2.5, category: 'Comida'),
    Service(id: '6', letter: 'F', name: 'Delicias Caseras', subtitle: 'Servicios de comida preparados con amor', price: 7.00, rating: 2.5, category: 'Comida'),
    Service(id: '7', letter: 'W', name: 'Web Design', subtitle: 'Diseño web moderno y responsive', price: 100.00, rating: 4.7, category: 'Diseño'),
    Service(id: '8', letter: 'L', name: 'Logo Maker', subtitle: 'Creación de logos únicos y creativos', price: 40.00, rating: 4.6, category: 'Diseño'),
    Service(id: '9', letter: 'P', name: 'Pasteles Personalizados', subtitle: 'Pasteles para ocasiones especiales', price: 25.00, rating: 4.9, category: 'Comida'),
    Service(id: '10', letter: 'A', name: 'App Development', subtitle: 'Desarrollo de aplicaciones móviles personalizadas', price: 150.00, rating: 4.9, category: 'Tecnologia'),
    Service(id: '11', letter: 'S', name: 'Software Solutions', subtitle: 'Soluciones de software a medida', price: 200.00, rating: 4.7, category: 'Tecnologia'),
    Service(id: '12', letter: 'H', name: 'Handmade Crafts', subtitle: 'Artesanías hechas a mano únicas', price: 15.00, rating: 4.5, category: 'Artesanias'),
    Service(id: '13', letter: 'J', name: 'Joyas Artesanales', subtitle: 'Joyas personalizadas con materiales naturales', price: 50.00, rating: 4.8, category: 'Artesanias'),
  ];

  List<Service> get _favoriteServices => _services.where((s) => _favorites.contains(s.id)).toList();

  List<Service> get _filteredServices {
    var filtered = _services.where((s) =>
        _searchQuery.isEmpty ||
        s.name.toLowerCase().contains(_searchQuery) ||
        s.subtitle.toLowerCase().contains(_searchQuery));

    if (_selectedCategoryIndex != 0) {
      final selectedCategory = _categories[_selectedCategoryIndex]['label'];
      filtered = filtered.where((s) => s.category == selectedCategory);
    }
    return filtered.toList();
  }

  List<Service> get _filteredTopServices => _filteredServices.take(2).toList();

  void _toggleFavorite(String id) {
    setState(() => _favorites.contains(id) ? _favorites.remove(id) : _favorites.add(id));
  }

  void _navigateToDetail(Service service) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => DetailScreen(service: service)));
  }

  final List<Map<String, dynamic>> _categories = [
    {'label': 'Todas', 'icon': Icons.apps},
    {'label': 'Comida', 'icon': Icons.restaurant},
    {'label': 'Diseño', 'icon': Icons.design_services},
    {'label': 'Tecnologia', 'icon': Icons.developer_mode},
    {'label': 'Artesanias', 'icon': Icons.palette},
  ];

=======
>>>>>>> Stashed changes
  @override
  Widget build(BuildContext context) {
    return Consumer<ServiceProvider>(
      builder: (context, serviceProvider, child) {
        List<ServiceModel> filteredServices = serviceProvider.allServices;

<<<<<<< Updated upstream
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: bottomPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
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
                        Text('Hola, Alejandro', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white)),
                        Text('¿Qué necesitas hoy?', style: TextStyle(fontSize: 16, color: Colors.white70)),
                      ],
                    ),
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.white,
                      child: const Text('U', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF90063A))),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Buscar servicios...',
                        prefixIcon: const Icon(Icons.search, color: Color(0xFF90063A)),
                        filled: true,
                        fillColor: const Color(0xFF90063A).withOpacity(0.08),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
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
                            onTap: () => setState(() => _selectedCategoryIndex = i),
                            child: Container(
                              margin: const EdgeInsets.only(right: 10),
                              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                              decoration: BoxDecoration(
                                color: selected ? const Color(0xFFFFF3E0) : const Color(0xFFF5F5F5),
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: Row(
                                children: [
                                  Icon(cat['icon'], size: 18, color: selected ? const Color(0xFFFF9800) : Colors.grey[600]),
                                  const SizedBox(width: 6),
                                  Text(cat['label'], style: TextStyle(fontWeight: selected ? FontWeight.w600 : FontWeight.normal, color: selected ? const Color(0xFFFF9800) : Colors.grey[700])),
                                ],
                              ),
=======
        if (_searchQuery.isNotEmpty) {
          filteredServices = serviceProvider.allServices.where((service) {
            final query = _searchQuery.toLowerCase();
            return service.name.toLowerCase().contains(query) ||
                   service.subtitle.toLowerCase().contains(query) ||
                   service.category.toLowerCase().contains(query);
          }).toList();
        }

        final topServices = serviceProvider.allServices.take(2).toList();
        final hasExactResults = filteredServices.isNotEmpty;
        final suggestionText = _searchQuery.isNotEmpty && !hasExactResults
            ? 'Opciones relacionadas: ${_getSuggestions(_searchQuery).first}'
            : '';

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(140.0),
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFFC8102E),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(0),
                  bottomRight: Radius.circular(0),
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Hola, Alejandro',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Autocomplete para sugerencias
                      Autocomplete<String>(
                        optionsBuilder: (TextEditingValue textEditingValue) {
                          if (textEditingValue.text.isEmpty) return const Iterable<String>.empty();
                          return _getSuggestions(textEditingValue.text);
                        },
                        onSelected: (String selection) {
                          setState(() {
                            _searchQuery = selection;
                            _searchController.text = selection;
                          });
                        },
                        fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                          _searchController.text = _searchQuery;
                          return TextField(
                            controller: controller ?? _searchController,
                            focusNode: focusNode,
                            onChanged: (value) => setState(() => _searchQuery = value),
                            onSubmitted: (value) => setState(() => _searchQuery = value),
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: _searchQuery.isEmpty
                                  ? '¿Qué necesitas hoy? Busca servicios o emprendimientos'
                                  : null,
                              hintStyle: const TextStyle(color: Colors.white70, fontSize: 14),
                              prefixIcon: const Icon(Icons.search, color: Colors.white70),
                              suffixIcon: _searchQuery.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(Icons.clear, color: Colors.white70),
                                      onPressed: () {
                                        _searchController.clear();
                                        setState(() => _searchQuery = '');
                                      },
                                    )
                                  : null,
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
>>>>>>> Stashed changes
                            ),
                          );
                        },
                      ),
<<<<<<< Updated upstream
                    ),
                    const SizedBox(height: 24),

                    // Top Destacadas (AQUÍ ESTABA EL FIX)
                    Text(_searchQuery.isEmpty ? 'Top Destacadas' : 'Resultados', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 200, // antes 180 → ahora 200 = SIN OVERFLOW
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _filteredTopServices.length,
                        itemBuilder: (_, i) {
                          final service = _filteredTopServices[i];
                          return Padding(
                            padding: EdgeInsets.only(right: i < _filteredTopServices.length - 1 ? 12 : 0),
                            child: ServiceCard(
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

                    Text(
                      _searchQuery.isNotEmpty ? 'Resultados (${_filteredServices.length})' : '${_categories[_selectedCategoryIndex]['label']} los emprendimientos',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),

                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      childAspectRatio: 0.75,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                      children: _filteredServices.map((s) => ServiceCard(
                            service: s,
                            isFavorite: _favorites.contains(s.id),
                            onCardTap: () => _navigateToDetail(s),
                            onHeartTap: () => _toggleFavorite(s.id),
                          )).toList(),
                    ),

                    const SizedBox(height: 24),
                    const Text('Favoritos', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),

                    _favoriteServices.isEmpty
                        ? Container(
                            height: 180,
                            decoration: BoxDecoration(color: const Color(0xFFF8F8F8), borderRadius: BorderRadius.circular(16)),
                            child: const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.favorite_border, size: 50, color: Colors.grey),
                                  SizedBox(height: 10),
                                  Text('Aún no tienes favoritos', style: TextStyle(color: Colors.grey)),
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
                            children: _favoriteServices.map((s) => ServiceCard(
                                  service: s,
                                  isFavorite: true,
                                  onCardTap: () => _navigateToDetail(s),
                                  onHeartTap: () => _toggleFavorite(s.id),
                                )).toList(),
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
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4))],
        ),
        child: Column(
          children: [
            CircleAvatar(
              radius: 26,
              backgroundColor: Colors.white,
              child: Text(service.letter, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF90063A))),
            ),
            const SizedBox(height: 12),
            Text(service.name, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 4),
            Text(service.subtitle, style: const TextStyle(color: Colors.white70, fontSize: 12), maxLines: 2, overflow: TextOverflow.ellipsis),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.star, size: 16, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text(service.rating.toStringAsFixed(1), style: const TextStyle(color: Colors.white)),
                  ],
                ),
                GestureDetector(
                  onTap: onHeartTap,
                  child: Icon(isFavorite ? Icons.favorite : Icons.favorite_border, color: Colors.white, size: 22),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text('\$${service.price.toStringAsFixed(2)}', style: const TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
=======
                    ],
                  ),
                ),
              ),
            ),
          ),
          body: CustomScrollView(
            slivers: [
              // Categorías SIEMPRE visibles
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _categories.map((category) => Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: _buildCategoryChip(category, () => _onCategoryTap(category)),
                      )).toList(),
                    ),
                  ),
                ),
              ),
              // Título TOP/Resultados con sugerencia si no hay resultados
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _searchQuery.isEmpty ? 'TOP Destacadas' : (hasExactResults ? 'Resultados de búsqueda ($_searchQuery)' : 'Opciones sugeridas'),
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFFC8102E)),
                      ),
                      if (suggestionText.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            suggestionText,
                            style: const TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              // Grid TOP/Resultados (con navegación a detalle)
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.78,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final servicesToShow = _searchQuery.isEmpty ? topServices : filteredServices;
                      if (index >= servicesToShow.length) return null;
                      final service = servicesToShow[index];
                      return ServiceCard(
                        service: service,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailScreen(service: service),
                          ),
                        ),
                      );
                    },
                    childCount: _searchQuery.isEmpty ? topServices.length : filteredServices.length,
                  ),
                ),
              ),
              // Sección "Todos"/Más resultados (con navegación a detalle)
              if (_searchQuery.isEmpty || filteredServices.isNotEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    child: Text(
                      _searchQuery.isEmpty ? 'Todos los Emprendimientos' : 'Más resultados',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFFC8102E)),
                    ),
                  ),
                ),
              if (_searchQuery.isEmpty || filteredServices.isNotEmpty)
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.78,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        int startIndex = _searchQuery.isEmpty ? topServices.length : 0;
                        if (index + startIndex >= filteredServices.length) return null;
                        final service = filteredServices[index + startIndex];
                        return ServiceCard(
                          service: service,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailScreen(service: service),
                            ),
                          ),
                        );
                      },
                      childCount: _searchQuery.isNotEmpty ? filteredServices.length : (serviceProvider.allServices.length - topServices.length),
                    ),
                  ),
                ),
              // No resultados con sugerencia
              if (_searchQuery.isNotEmpty && filteredServices.isEmpty)
                SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('No se encontraron resultados exactos.'),
                        const SizedBox(height: 8),
                        Text('Opciones sugeridas: ${_getSuggestions(_searchQuery).join(', ')}'),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCategoryChip(String label, VoidCallback onTap) {
    IconData icon = _getCategoryIcon(label);
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Círculo con ícono
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFF5E8E8),  // Fondo rojo claro
              border: Border.all(color: const Color(0xFFC8102E), width: 1),  // Borde rojo
            ),
            child: Icon(
              icon,
              size: 24,
              color: const Color(0xFFC8102E),
            ),
          ),
          const SizedBox(height: 4),  // Pegado abajo
          // Nombre de categoría
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFFC8102E),
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Comida': return Icons.restaurant_outlined;
      case 'Tutorías': return Icons.school_outlined;
      case 'Portafolios': return Icons.folder_outlined;
      case 'Consultas': return Icons.chat_bubble_outline;
      case 'Diseños': return Icons.design_services_outlined;
      case 'Libros': return Icons.menu_book_outlined;
      case 'Plantillas': return Icons.description_outlined;
      case 'Idioma': return Icons.language_outlined;
      case 'Redacciones': return Icons.edit_outlined;
      case 'Prototipos': return Icons.build_outlined;
      case 'Investigaciones': return Icons.search_outlined;
      case 'Arte': return Icons.palette_outlined;
      case 'Presentaciones': return Icons.slideshow_outlined;
      case 'Accesorios': return Icons.shopping_bag_outlined;
      default: return Icons.category_outlined;
    }
  }

  void _onCategoryTap(String category) {
    final provider = Provider.of<ServiceProvider>(context, listen: false);
    final filtered = provider.getServicesByCategory(category);
    setState(() {
      _searchQuery = category;
      _searchController.text = category;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Mostrando ${filtered.length} servicios en $category')),
    );
  }

  void _showServiceDetail(ServiceModel service) {
    // Esta función ya no se usa directamente; navegación en onTap
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Detalles de ${service.name}')),
    );
  }
>>>>>>> Stashed changes
}