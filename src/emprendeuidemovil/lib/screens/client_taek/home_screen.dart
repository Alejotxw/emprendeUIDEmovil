import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/service_provider.dart';
import '../../models/service_model.dart';
import '../../widgets/service_card.dart';
import 'detail_screen.dart';  // Import para navegación a detalle
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../providers/notification_provider.dart'; // Ajusta la ruta a tu carpeta

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

  void _showNotificationsDialog(BuildContext context, NotificationProvider provider) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: const Text('Notificaciones'),
      content: SizedBox(
        width: double.maxFinite,
        child: provider.notifications.isEmpty
            ? const Text('No hay mensajes nuevos')
            : // Busca esta parte en tu home_screen.dart
              ListView.builder(
                shrinkWrap: true,
                itemCount: provider.notifications.length,
                itemBuilder: (context, index) {
                  final noti = provider.notifications[index];

                  return ListTile(
                    leading: const Icon(Icons.info_outline, color: Color(0xFFC8102E)),
                    title: Text(noti.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(noti.message),
                    trailing: Text(
                      "${noti.timestamp.hour}:${noti.timestamp.minute.toString().padLeft(2, '0')}",
                      style: const TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                  );
                },
              ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cerrar')),
      ],
    ),
  );
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> _categories = [
    'Bienestar', 'Eventos', 'Mascotas', 'Tecnologia', 'Gastronomia',
    'Moda', 'Diseño', 'Educación', 'Hogar', 'Movilidad',
  ];

  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

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
  }

  void _showEventDetails(Map<String, dynamic> event) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            Expanded(child: Text(event['title'] ?? 'Evento')),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (event['image'] != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(event['image'], height: 150, width: double.infinity, fit: BoxFit.cover),
              ),
            const SizedBox(height: 12),
            Text("📅 Fecha: ${event['datetime']?.toString().split('T')[0] ?? ''}", 
                 style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(event['description'] ?? 'Sin descripción'),
            const SizedBox(height: 8),
            Text("📞 Contacto: ${event['contact'] ?? 'No disponible'}",
                 style: const TextStyle(color: Colors.blueGrey, fontSize: 13)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ServiceProvider>(
      builder: (context, serviceProvider, child) {
        List<ServiceModel> filteredServices = serviceProvider.allServices;

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
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                      // FILA SUPERIOR: Nombre y Campana de Notificaciones
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Hola, Alejandro',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          // --- INICIO DE NOTIFICACIONES ---
                          Consumer<NotificationProvider>(
                            builder: (context, notiProvider, child) {
                              return Stack(
                                alignment: Alignment.center,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.notifications, color: Colors.white),
                                    onPressed: () => _showNotificationsDialog(context, notiProvider),
                                  ),
                                  if (notiProvider.notifications.isNotEmpty)
                                    Positioned(
                                      right: 8,
                                      top: 8,
                                      child: Container(
                                        padding: const EdgeInsets.all(2),
                                        decoration: BoxDecoration(
                                          color: Colors.orange, // Color llamativo para el contador
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                                        child: Text(
                                          '${notiProvider.notifications.length}',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                ],
                              );
                            },
                          ),
                          // --- FIN DE NOTIFICACIONES ---
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Autocomplete para sugerencias (Buscador)
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
                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: TextField(
                              controller: controller ?? _searchController,
                              focusNode: focusNode,
                              onChanged: (value) => setState(() => _searchQuery = value),
                              onSubmitted: (value) => setState(() => _searchQuery = value),
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                hintText: _searchQuery.isEmpty
                                    ? '¿Qué necesitas hoy? Busca servicios'
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
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  
                ),
              ),
              
            ),
          ),
          body: CustomScrollView(
            slivers: [
              // --- SECCIÓN DE EVENTOS (CARRUSEL) ---
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                .collection('events')
                .where('status', isEqualTo: 'published')
                .snapshots(),
                builder: (context, snapshot) {
                  // Si no hay datos o la lista está vacía, no muestra NADA
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const SliverToBoxAdapter(child: SizedBox.shrink());
                  }

                  final docs = snapshot.data!.docs;

                  return SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: CarouselSlider(
                        options: CarouselOptions(
                          height: 200,
                          // Solo activa el autoPlay si hay más de un evento
                          autoPlay: docs.length > 1, 
                          autoPlayInterval: const Duration(seconds: 5),
                          enlargeCenterPage: true,
                          // Evita el scroll infinito si solo hay un evento
                          enableInfiniteScroll: docs.length > 1,
                          viewportFraction: 0.85,
                        ),
                        items: docs.map((doc) {
                          final event = doc.data() as Map<String, dynamic>;
                          final imageUrl = event['image'] ?? '';

                          return GestureDetector(
                            onTap: () => _showEventDetails(event),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.grey[200], // Fondo mientras carga
                                image: imageUrl.isNotEmpty
                                    ? DecorationImage(
                                        image: NetworkImage(imageUrl),
                                        fit: BoxFit.cover,
                                      )
                                    : null,
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  gradient: LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.center,
                                    colors: [
                                      Colors.black.withOpacity(0.8),
                                      Colors.transparent
                                    ],
                                  ),
                                ),
                                padding: const EdgeInsets.all(12),
                                alignment: Alignment.bottomLeft,
                                child: Text(
                                  event['title'] ?? '',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  );
                },
              ),
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
      case 'Bienestar': return Icons.spa_outlined;
      case 'Eventos': return Icons.event_outlined;
      case 'Mascotas': return Icons.pets_outlined;
      case 'Tecnologia': return Icons.computer_outlined;
      case 'Gastronomia': return Icons.restaurant_outlined;
      case 'Moda': return Icons.checkroom_outlined;
      case 'Diseño': return Icons.brush_outlined;
      case 'Educación': return Icons.school_outlined;
      case 'Hogar': return Icons.home_outlined;
      case 'Movilidad': return Icons.directions_car_outlined;
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
}