import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
        final colorScheme = Theme.of(context).colorScheme;

        IconData getIcon() {
          switch (service.category) {
            case 'Comida':
              return Icons.restaurant;
            case 'Tutorías':
              return Icons.school;
            case 'Portafolios':
              return Icons.folder;
            case 'Consultas':
              return Icons.chat;
            case 'Diseños':
              return Icons.design_services;
            case 'Libros':
              return Icons.menu_book;
            case 'Plantillas':
              return Icons.description;
            case 'Idioma':
              return Icons.language;
            case 'Redacciones':
              return Icons.edit;
            case 'Prototipos':
              return Icons.build;
            case 'Investigaciones':
              return Icons.search;
            case 'Arte':
              return Icons.palette;
            case 'Presentaciones':
              return Icons.slideshow;
            case 'Accesorios':
              return Icons.shopping_bag;
            default:
              return Icons.category;
          }
        }

        return GestureDetector(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.shadow.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Container(
                      height: 100,
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withOpacity(0.8),
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                      ),
                      child: Center(
                        child: Icon(
                          getIcon(),
                          size: 40,
                          color: colorScheme.onPrimary,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: GestureDetector(
                        onTap: () => provider.toggleFavorite(service.id),
                        child: Icon(
                          isFav ? Icons.favorite : Icons.favorite_border,
                          color: isFav ? Colors.red : colorScheme.onPrimary.withOpacity(0.7),
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          service.name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: colorScheme.onSurface,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          service.subtitle,
                          style: TextStyle(
                            fontSize: 12,
                            color: colorScheme.onSurfaceVariant,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            Icon(Icons.star, size: 16, color: Colors.amber),
                            const SizedBox(width: 4),
                            Text(
                              '${service.rating} (${service.reviewCount})',
                              style: TextStyle(
                                fontSize: 12,
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '\$${service.price.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: colorScheme.primary,
                          ),
                        ),
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