import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/service_provider.dart';
import '../../widgets/service_card.dart';
import '../../l10n/app_localizations.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Consumer<ServiceProvider>(
      builder: (context, provider, child) {
        final favorites = provider.favorites;
        return Scaffold(
          appBar: AppBar(
            title: Text(t.favorites),
            backgroundColor: const Color(0xFFC8102E),
            foregroundColor: Colors.white,
          ),
          body: favorites.isEmpty
              ? Center(child: Text(t.emptyFavorites))
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
                      onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${t.viewService} ${service.name}'),
                        ),
                      ),
                    );
                  },
                ),
        );
      },
    );
  }
}