import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/service_provider.dart';
import '../../widgets/service_card.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ServiceProvider>(
      builder: (context, provider, child) {
        final favorites = provider.favorites;
        return Scaffold(
          appBar: AppBar(
            title: const Text('Mis Favoritos'),
            backgroundColor: const Color.fromARGB(255, 131, 0, 41),
            foregroundColor: Colors.white,
          ),
          body: favorites.isEmpty
              ? const Center(child: Text('No hay favoritos. ¡Agrega en Home!'))
              : GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.78,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: favorites.length,
                  itemBuilder: (context, index) {
                    final service = favorites[index];
                    return ServiceCard(
                      service: service,
                      onTap: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Ver ${service.name}'))),
                    );
                  },
                ),
        );
      },
    );
  }
}