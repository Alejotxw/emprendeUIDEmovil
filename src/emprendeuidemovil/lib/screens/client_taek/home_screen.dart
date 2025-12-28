import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/service_provider.dart';
import '../../models/service_model.dart';
import '../../widgets/service_card.dart';
import 'detail_screen.dart';  // Import para navegación a detalle

class HomeScreen extends StatefulWidget {
  final VoidCallback toggleTheme;
  const HomeScreen({super.key, required this.toggleTheme});

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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
          backgroundColor: colorScheme.surface,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(140.0),
            child: Container(
              decoration: BoxDecoration(
                color: colorScheme.primary,
                borderRadius: const BorderRadius.only(
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Hola, Alejandro',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: colorScheme.onPrimary,
                            ),
                          ),
                          IconButton(
                            onPressed: widget.toggleTheme,
                            icon: Icon(
                              isDark ? Icons.light_mode : Icons.dark_mode,
                              color: colorScheme.onPrimary,
                            ),
                          ),
                        ],
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
                            style: TextStyle(color: colorScheme.onPrimary),
                            decoration: InputDecoration(
                              hintText: _searchQuery.isEmpty
                                  ? '¿Qué necesitas hoy? Busca servicios o emprendimientos'
                                  : null,
                              hintStyle: TextStyle(color: colorScheme.onPrimary.withOpacity(0.7), fontSize: 14),
                              prefixIcon: Icon(Icons.search, color: colorScheme.onPrimary.withOpacity(0.7)),
                              suffixIcon: _searchQuery.isNotEmpty
                                  ? IconButton(
                                      icon: Icon(Icons.clear, color: colorScheme.onPrimary.withOpacity(0.7)),
                                      onPressed: () {
                                        _searchController.clear();
                                        setState(() => _searchQuery = '');
                                      },
                                    )
                                  : null,
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
              // Categorías SIEMPRE visibles
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _categories.map((category) => Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: _buildCategoryChip(category, () => _onCategoryTap(category), colorScheme),
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
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: colorScheme.primary),
                      ),
                      if (suggestionText.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            suggestionText,
                            style: TextStyle(fontSize: 14, color: colorScheme.onSurfaceVariant),
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
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: colorScheme.primary),
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

  Widget _buildCategoryChip(String label, VoidCallback onTap, ColorScheme colorScheme) {
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
              color: colorScheme.surfaceVariant,  // Fondo adaptado
              border: Border.all(color: colorScheme.primary, width: 1),  // Borde primario
            ),
            child: Icon(
              icon,
              size: 24,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(height: 4),  // Pegado abajo
          // Nombre de categoría
          Text(
            label,
            style: TextStyle(
              color: colorScheme.primary,
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
}