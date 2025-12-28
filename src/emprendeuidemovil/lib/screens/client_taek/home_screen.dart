import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/service_provider.dart';
import '../../models/service_model.dart';
import '../../widgets/service_card.dart';
import 'detail_screen.dart';
import '../../l10n/app_localizations.dart'; // Para traducciones

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

  List<String> _getSuggestions(String query) {
    final lowerQuery = query.toLowerCase();
    final suggestions = <String>[];

    suggestions.addAll(
      _categories.where((cat) => cat.toLowerCase().contains(lowerQuery)),
    );

    final provider = Provider.of<ServiceProvider>(context, listen: false);
    suggestions.addAll(
      provider.allServices
          .where((s) => s.name.toLowerCase().contains(lowerQuery))
          .map((s) => s.name)
          .take(5),
    );

    final t = AppLocalizations.of(context)!;
    return suggestions.isNotEmpty
        ? suggestions
        : [t.noServices.replaceFirst("{query}", lowerQuery)];
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Consumer<ServiceProvider>(
      builder: (context, serviceProvider, child) {
        // Filtrado por búsqueda
        List<ServiceModel> filteredServices = serviceProvider.allServices;
        if (_searchQuery.isNotEmpty) {
          final query = _searchQuery.toLowerCase();
          filteredServices = serviceProvider.allServices.where((service) {
            return service.name.toLowerCase().contains(query) ||
                service.subtitle.toLowerCase().contains(query) ||
                service.category.toLowerCase().contains(query);
          }).toList();
        }

        final topServices = serviceProvider.allServices.take(2).toList();
        final hasResults = filteredServices.isNotEmpty;

        return Scaffold(
          backgroundColor: colorScheme.surface,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(140.0),
            child: Container(
              decoration: BoxDecoration(color: colorScheme.primary),
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
                            '${t.hello}, Alejandro',
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
                      Autocomplete<String>(
                        optionsBuilder: (TextEditingValue textEditingValue) {
                          if (textEditingValue.text.isEmpty) {
                            return const Iterable<String>.empty();
                          }
                          return _getSuggestions(textEditingValue.text);
                        },
                        onSelected: (String selection) {
                          setState(() {
                            _searchQuery = selection;
                            _searchController.text = selection;
                          });
                        },
                        fieldViewBuilder:
                            (context, controller, focusNode, onFieldSubmitted) {
                          return TextField(
                            controller: controller ?? _searchController,
                            focusNode: focusNode,
                            onChanged: (value) =>
                                setState(() => _searchQuery = value),
                            onSubmitted: (value) =>
                                setState(() => _searchQuery = value),
                            style: TextStyle(color: colorScheme.onPrimary),
                            decoration: InputDecoration(
                              hintText: _searchQuery.isEmpty
                                  ? t.services + " o emprendimientos"
                                  : null,
                              hintStyle: TextStyle(
                                color: colorScheme.onPrimary.withOpacity(0.7),
                                fontSize: 14,
                              ),
                              prefixIcon: Icon(
                                Icons.search,
                                color: colorScheme.onPrimary.withOpacity(0.7),
                              ),
                              suffixIcon: _searchQuery.isNotEmpty
                                  ? IconButton(
                                      icon: Icon(
                                        Icons.clear,
                                        color: colorScheme.onPrimary
                                            .withOpacity(0.7),
                                      ),
                                      onPressed: () {
                                        _searchController.clear();
                                        setState(() => _searchQuery = '');
                                      },
                                    )
                                  : null,
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 12),
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
              // Categorías
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _categories
                          .map(
                            (category) => Padding(
                              padding: const EdgeInsets.only(right: 12),
                              child: _buildCategoryChip(category, colorScheme),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
              ),
              // Título principal
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  child: Text(
                    _searchQuery.isEmpty
                        ? t.dashboard // o 'TOP Destacadas'
                        : (hasResults
                            ? '${t.availableServices} ($_searchQuery)'
                            : t.noServices),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: colorScheme.primary,
                    ),
                  ),
                ),
              ),
              // Grid: TOP o resultados de búsqueda
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
                      final servicesToShow =
                          _searchQuery.isEmpty ? topServices : filteredServices;
                      if (index >= servicesToShow.length) return null;
                      final service = servicesToShow[index];
                      return ServiceCard(
                        service: service,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                DetailScreen(service: service),
                          ),
                        ),
                      );
                    },
                    childCount: _searchQuery.isEmpty
                        ? topServices.length
                        : filteredServices.length,
                  ),
                ),
              ),
              // Sección "Todos" / "Más resultados"
              if (_searchQuery.isEmpty || hasResults)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                    child: Text(
                      _searchQuery.isEmpty
                          ? 'Todos los Emprendimientos'
                          : 'Más resultados',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: colorScheme.primary,
                      ),
                    ),
                  ),
                ),
              if (_searchQuery.isEmpty || hasResults)
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.78,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final startIndex =
                            _searchQuery.isEmpty ? topServices.length : 0;
                        final totalServices = _searchQuery.isEmpty
                            ? serviceProvider.allServices
                            : filteredServices;
                        if (index + startIndex >= totalServices.length) {
                          return null;
                        }
                        final service = totalServices[index + startIndex];
                        return ServiceCard(
                          service: service,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  DetailScreen(service: service),
                            ),
                          ),
                        );
                      },
                      childCount: _searchQuery.isEmpty
                          ? (serviceProvider.allServices.length -
                              topServices.length)
                          : filteredServices.length,
                    ),
                  ),
                ),
              // Sin resultados
              if (_searchQuery.isNotEmpty && !hasResults)
                SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(t.noServices),
                        const SizedBox(height: 12),
                        Text(
                          '${t.availableServices}: ${_getSuggestions(_searchQuery).join(', ')}',
                          style: TextStyle(color: colorScheme.primary),
                          textAlign: TextAlign.center,
                        ),
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

  Widget _buildCategoryChip(String label, ColorScheme colorScheme) {
    IconData icon = _getCategoryIcon(label);
    return GestureDetector(
      onTap: () => _onCategoryTap(label),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colorScheme.surfaceVariant,
              border: Border.all(color: colorScheme.primary, width: 1),
            ),
            child: Icon(icon, size: 24, color: colorScheme.primary),
          ),
          const SizedBox(height: 4),
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
    // (mismo switch que antes)
    switch (category) {
      case 'Comida':
        return Icons.restaurant_outlined;
      case 'Tutorías':
        return Icons.school_outlined;
      // ... resto igual
      default:
        return Icons.category_outlined;
    }
  }

  void _onCategoryTap(String category) {
    final provider = Provider.of<ServiceProvider>(context, listen: false);
    final filtered = provider.getServicesByCategory(category);
    final t = AppLocalizations.of(context)!;

    setState(() {
      _searchQuery = category;
      _searchController.text = category;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${t.availableServices}: ${filtered.length} en $category'),
      ),
    );
  }
}