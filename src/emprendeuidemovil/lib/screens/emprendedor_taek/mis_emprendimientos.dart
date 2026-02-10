import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:emprendeuidemovil/screens/emprendedor_taek/form_emprendimiento.dart';
import '../../providers/service_provider.dart';
import '../../providers/order_provider.dart';
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
      'location': service.location,
      'isDraft': false, 
      'services': [
        ...service.services.map((s) => {
          'name': s.name,
          'description': s.description,
          'price': s.price.toString(),
          'stock': s.stock.toString(),
          'type': 'service',
        }),
        ...service.products.map((p) => {
          'name': p.name,
          'description': p.description,
          'price': p.price.toString(),
          'stock': p.stock.toString(),
          'type': 'product',
        }),
      ],
      'transferData': service.transferData?.toMap(),
      'scheduleDays': service.scheduleDays,
      'openTime': service.openTime,
      'closeTime': service.closeTime,
    };
  }

  ImageProvider? _getImageProvider(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) return null;
    
    if (imagePath.startsWith('http')) {
      return NetworkImage(imagePath);
    }
    
    if (imagePath.length > 200) {
      try {
        return MemoryImage(base64Decode(imagePath));
      } catch (e) {
        debugPrint('Error decoding base64 image: $e');
        return null;
      }
    }
    
    final file = File(imagePath);
    if (file.existsSync()) {
      return FileImage(file);
    }
    
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final serviceProvider = Provider.of<ServiceProvider>(context);
    final myEmprendimientos = serviceProvider.myServices;

    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF121212) : Colors.white,
      body: Column(
        children: [
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
                         
                         final servicesList = (data['services'] as List).where((s) => s['type'] == 'service').map<ServiceItem>((s) => ServiceItem(
                           name: s['name'],
                           price: double.tryParse(s['price']) ?? 0.0,
                           description: s['description'],
                           stock: int.tryParse(s['stock'] ?? '0') ?? 0,
                         )).toList();

                         final productsList = (data['services'] as List).where((s) => s['type'] == 'product').map<ProductItem>((s) => ProductItem(
                           name: s['name'],
                           price: double.tryParse(s['price']) ?? 0.0,
                           description: s['description'],
                           stock: int.tryParse(s['stock'] ?? '0') ?? 0,
                         )).toList();

                         double basePrice = 0.0;
                         if (servicesList.isNotEmpty || productsList.isNotEmpty) {
                           final allPrices = [
                             ...servicesList.map((s) => s.price),
                             ...productsList.map((p) => p.price)
                           ];
                           basePrice = allPrices.reduce((a, b) => a < b ? a : b);
                         }

                         final serviceProvider = Provider.of<ServiceProvider>(context, listen: false);
                         final currentUser = serviceProvider.auth.currentUser;

                         if (currentUser == null) {
                           ScaffoldMessenger.of(context).showSnackBar(
                             const SnackBar(content: Text('Error: No has iniciado sesión. Reinicia la aplicación.')),
                           );
                           return;
                         }

                         final newService = ServiceModel(
                           id: '', // Let Firestore generate the ID or ServiceProvider handle it
                           name: data['title'],
                           subtitle: data['subtitle'],
                           category: data['category'],
                           price: basePrice,
                           rating: 5.0,
                           reviewCount: 0,
                           imageUrl: data['imagePath'] ?? '',
                           location: data['location'] ?? 'Sede Loja Universidad Internacional del Ecuador',
                           isMine: true,
                           ownerId: currentUser.uid,
                           services: servicesList,
                           products: productsList,
                           transferData: data['transferData'] != null ? TransferData.fromMap(data['transferData']) : null,
                           scheduleDays: List<String>.from(data['scheduleDays'] ?? []),
                           openTime: data['openTime'] ?? '09:00',
                           closeTime: data['closeTime'] ?? '18:00',
                         );


                         await serviceProvider.addService(newService);
                         
                         if (context.mounted) {
                           ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Emprendimiento creado exitosamente')),
                           );
                         }
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
                                    
                                    final servicesList = (data['services'] as List).where((s) => s['type'] == 'service').map<ServiceItem>((s) => ServiceItem(
                                      name: s['name'],
                                      price: double.tryParse(s['price']) ?? 0.0,
                                      description: s['description'],
                                      stock: int.tryParse(s['stock'] ?? '0') ?? 0,
                                    )).toList();

                                    final productsList = (data['services'] as List).where((s) => s['type'] == 'product').map<ProductItem>((s) => ProductItem(
                                      name: s['name'],
                                      price: double.tryParse(s['price']) ?? 0.0,
                                      description: s['description'],
                                      stock: int.tryParse(s['stock'] ?? '0') ?? 0,
                                    )).toList();

                                    double basePrice = 0.0;
                                    if (servicesList.isNotEmpty || productsList.isNotEmpty) {
                                      final allPrices = [
                                        ...servicesList.map((s) => s.price),
                                        ...productsList.map((p) => p.price)
                                      ];
                                      basePrice = allPrices.reduce((a, b) => a < b ? a : b);
                                    }

                                    final updatedService = service.copyWith(
                                      name: data['title'],
                                      subtitle: data['subtitle'],
                                      category: data['category'],
                                      price: basePrice,
                                      imageUrl: data['imagePath'] ?? service.imageUrl,
                                      location: data['location'] ?? service.location,
                                      services: servicesList,
                                      products: productsList,
                                      transferData: data['transferData'] != null ? TransferData.fromMap(data['transferData']) : service.transferData,
                                      scheduleDays: List<String>.from(data['scheduleDays'] ?? []),
                                      openTime: data['openTime'] ?? service.openTime,
                                      closeTime: data['closeTime'] ?? service.closeTime,
                                    );
                                    
                                    await serviceProvider.updateService(updatedService);
                                    
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Emprendimiento actualizado exitosamente')),
                                      );
                                    }
                                  } else if (result['action'] == 'delete') {
                                    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
                                    
                                    // Delete the service
                                    await serviceProvider.deleteService(service.id);
                                    
                                    // Also delete associated orders/requests
                                    await orderProvider.deleteOrdersForService(service.id);
                                    
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Emprendimiento y sus solicitudes eliminados')),
                                      );
                                    }
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
    final imageProvider = _getImageProvider(imagePath);

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
              image: imageProvider != null
                  ? DecorationImage(
                      image: imageProvider,
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
