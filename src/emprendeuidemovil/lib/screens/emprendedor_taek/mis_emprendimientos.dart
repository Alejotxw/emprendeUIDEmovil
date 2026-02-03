import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:emprendeuidemovil/screens/emprendedor_taek/form_emprendimiento.dart';
import '../../providers/service_provider.dart';
import '../../models/service_model.dart';

class MisEmprendimientosScreen extends StatefulWidget {
  const MisEmprendimientosScreen({super.key});

  @override
  State<MisEmprendimientosScreen> createState() => _MisEmprendimientosScreenState();
}

class _MisEmprendimientosScreenState extends State<MisEmprendimientosScreen> {
  // Helper to convert ServiceModel to Map for the form
  Map<String, dynamic> _serviceToMap(ServiceModel service) {
    return {
      'id': service.id,
      'title': service.name,
      'subtitle': service.subtitle,
      'category': service.category,
      'imagePath': service.imageUrl,
      'isDraft': false, // ServiceModel doesn't have isDraft yet
      'services': [
        ...service.services.map((s) => {
          'name': s.name,
          'description': s.description,
          'price': s.price.toString(),
          'type': 'service',
        }),
        ...service.products.map((p) => {
          'name': p.name,
          'description': p.description,
          'price': p.price.toString(),
          'type': 'product',
        }),
      ],
    };
  }

  @override
  Widget build(BuildContext context) {
    final serviceProvider = Provider.of<ServiceProvider>(context);
    final myEmprendimientos = serviceProvider.myServices;

    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF121212) : Colors.white,
      body: Column(
        children: [
          // Top Bar
          Container(
            padding: const EdgeInsets.only(top: 50, bottom: 20, left: 24, right: 24),
            decoration: const BoxDecoration(
              color: Color(0xFF83002A),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Emprendimientos',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const FormEmprendimientoScreen()),
                    );

                    if (result != null && result is Map<String, dynamic>) {
                      if (result['action'] == 'create') {
                         final data = result['data'];
                         
                         final newService = ServiceModel(
                           id: DateTime.now().millisecondsSinceEpoch.toString(),
                           name: data['title'],
                           subtitle: data['subtitle'],
                           category: data['category'],
                           price: 0.0,
                           rating: 5.0,
                           reviewCount: 0,
                           imageUrl: data['imagePath'] ?? '',
                           isMine: true,
                           services: (data['services'] as List).where((s) => s['type'] == 'service').map<ServiceItem>((s) => ServiceItem(
                             name: s['name'],
                             price: double.tryParse(s['price']) ?? 0.0,
                             description: s['description']
                           )).toList(),
                           products: (data['services'] as List).where((s) => s['type'] == 'product').map<ProductItem>((s) => ProductItem(
                             name: s['name'],
                             price: double.tryParse(s['price']) ?? 0.0,
                             description: s['description']
                           )).toList(),
                         );

                         serviceProvider.addService(newService);
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFA600),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                  ),
                  child: const Text(
                    'Crear',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // List of Emprendimientos
          Expanded(
            child: myEmprendimientos.isEmpty 
              ? Center(
                  child: Text(
                    "No tienes emprendimientos aún",
                    style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.white70 : Colors.black54),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: myEmprendimientos.length,
                  itemBuilder: (context, index) {
                    final service = myEmprendimientos[index];
                    return Column(
                      children: [
                        _buildEmprendimientoCard(
                          title: service.name,
                          subtitle: service.subtitle,
                          category: service.category,
                          isDraft: false, 
                          imagePath: service.imageUrl.startsWith('assets/') ? null : service.imageUrl,
                          onPressed: () async {
                             final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FormEmprendimientoScreen(
                                    entrepreneurship: _serviceToMap(service)
                                  ),
                                ),
                              );

                              if (result != null && result is Map<String, dynamic>) {
                                 if (result['action'] == 'update') {
                                    final data = result['data'];
                                    final updatedService = service.copyWith(
                                      name: data['title'],
                                      subtitle: data['subtitle'],
                                      category: data['category'],
                                      imageUrl: data['imagePath'] ?? service.imageUrl,
                                      services: (data['services'] as List).where((s) => s['type'] == 'service').map<ServiceItem>((s) => ServiceItem(
                                        name: s['name'],
                                        price: double.tryParse(s['price']) ?? 0.0,
                                        description: s['description']
                                      )).toList(),
                                      products: (data['services'] as List).where((s) => s['type'] == 'product').map<ProductItem>((s) => ProductItem(
                                        name: s['name'],
                                        price: double.tryParse(s['price']) ?? 0.0,
                                        description: s['description']
                                      )).toList(),
                                    );
                                    serviceProvider.updateService(updatedService);
                                 } else if (result['action'] == 'delete') {
                                    serviceProvider.deleteService(service.id);
                                 }
                              }
                          },
                        ),
                        const SizedBox(height: 16),
                        if (index == myEmprendimientos.length - 1)
                           const SizedBox(height: 80), // Padding for bottom nav
                      ],
                    );
                  },
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmprendimientoCard({
    required String title,
    required String subtitle,
    required String category,
    required bool isDraft,
    String? imagePath,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade800 : Colors.grey.shade400),
      ),
      child: Column(
        children: [
          // Image / Color Block
          Container(
            height: 120,
            width: double.infinity,
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF83002A), // Placeholder color
              borderRadius: BorderRadius.circular(16),
              image: imagePath != null
                  ? DecorationImage(
                      image: FileImage(File(imagePath)),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
          ),
          
          // Category Pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFFFECCF), // Light orange
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              category,
              style: const TextStyle(
                color: Color(0xFFFFA600),
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          
          const SizedBox(height: 8),

          // Title
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
            ),
          ),

          // Subtitle
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade400 : Colors.grey.shade600,
            ),
          ),

          const SizedBox(height: 16),

          // Action Button
          Padding(
            padding: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDraft ? Colors.grey : const Color(0xFFFFA600),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: Text(
                  isDraft ? 'Borrador' : 'Editar Emprendimiento',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
