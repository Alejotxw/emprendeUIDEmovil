import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import '../providers/service_provider.dart';
import '../models/service_model.dart';

class ServiceCard extends StatelessWidget {
  final ServiceModel service;
  final VoidCallback onTap;

  const ServiceCard({
    super.key,
    required this.service,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ServiceProvider>(
      builder: (context, provider, child) {
        final isFav = provider.isFavorite(service.id);
        IconData getIcon() {
          switch (service.category) {
            case 'Comida': return Icons.restaurant;
            case 'Diseños': return Icons.design_services;
            case 'Consultas': return Icons.chat;
            case 'Libros': return Icons.menu_book;
            case 'Plantillas': return Icons.description;
            case 'Idioma': return Icons.language;
            case 'Redacciones': return Icons.edit;
            case 'Prototipos': return Icons.build;
            case 'Investigaciones': return Icons.search;
            case 'Arte': return Icons.palette;
            case 'Presentaciones': return Icons.slideshow;
            case 'Accesorios': return Icons.shopping_bag;  // Corregido: bolsa para accesorios
            default: return Icons.category;
          }
        }
        
        ImageProvider? getImageProvider(String imageUrl) {
            // Logic to determine image provider
            if (imageUrl.isEmpty || imageUrl.contains('placeholder')) return null;
            final file = File(imageUrl);
            if (file.existsSync()) return FileImage(file);
            if (imageUrl.startsWith('http')) return NetworkImage(imageUrl);
            if (imageUrl.startsWith('assets/')) return AssetImage(imageUrl);
            return null; // Fallback to icon if path is invalid/not found
        }

        final imageProvider = getImageProvider(service.imageUrl);

        return GestureDetector(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark ? Colors.grey[850] : Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 1, blurRadius: 4, offset: const Offset(0, 2))],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                      Container(
                        height: 100,
                        decoration: BoxDecoration(
                          color: const Color(0xFFC8102E).withOpacity(0.8),
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                          image: imageProvider != null 
                              ? DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: imageProvider == null 
                            ? Center(child: Icon(getIcon(), size: 40, color: Colors.white))
                            : null,
                      ),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: GestureDetector(
                        onTap: () => provider.toggleFavorite(service.id),
                        child: Icon(
                          isFav ? Icons.favorite : Icons.favorite_border,
                          color: isFav ? Colors.red : Colors.white70,
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(service.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black), maxLines: 1, overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 2),
                        Text(service.subtitle, style: const TextStyle(fontSize: 11, color: Colors.grey), maxLines: 1, overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.star, size: 14, color: Colors.amber),
                            Text('${service.rating} (${service.reviewCount})', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text('\$${service.price.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFFC8102E))),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}