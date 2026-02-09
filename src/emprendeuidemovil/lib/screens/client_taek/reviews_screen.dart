import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../providers/review_provider.dart';
import '../../providers/service_provider.dart';

class ReviewsScreen extends StatefulWidget {
  const ReviewsScreen({super.key});

  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  String? _userId;

  @override
  void initState() {
    super.initState();

    final user = FirebaseAuth.instance.currentUser;
    _userId = user?.uid;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      if (_userId != null) {
        context.read<ReviewProvider>().fetchReviewsByUser(_userId!);
      }
    });
  }

  @override
  void dispose() {
    Provider.of<ReviewProvider>(context, listen: false).clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis reseñas'),
        backgroundColor: const Color(0xFFC8102E),
        foregroundColor: Colors.white,
      ),
      body: Consumer<ReviewProvider>(
        builder: (context, reviewProvider, child) {
          if (_userId == null) {
            return const Center(child: Text('Usuario no autenticado'));
          }

          final reviews = reviewProvider.reviews;

          if (reviews.isEmpty) {
            return const Center(child: Text('No has realizado reseñas aún.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: reviews.length,
            itemBuilder: (context, index) {
              final review = reviews[index];

              final servicesProvider = context.read<ServiceProvider>();

              final service = servicesProvider.allServices
                  .where((s) => s.id == review.serviceId)
                  .toList();

              final serviceName = service.isNotEmpty
                  ? service.first.name
                  : "Servicio eliminado";

              return Card(
                elevation: 4,
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        serviceName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Row(
                        children: List.generate(5, (starIndex) {
                          return Icon(
                            starIndex < review.rating
                                ? Icons.star
                                : Icons.star_border,
                            color: Colors.amber,
                            size: 20,
                          );
                        }),
                      ),

                      const SizedBox(height: 8),

                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? const Color(0xFF2C2C2C)
                              : Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                ? Colors.grey.shade700
                                : Colors.grey.shade300,
                          ),
                        ),
                        child: Text(
                          review.comment.isEmpty
                              ? "Sin comentario"
                              : review.comment,
                          style: TextStyle(
                            fontSize: 14,
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                ? Colors.white70
                                : Colors.black87,
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        "Fecha: ${review.date.toLocal().toString().substring(0, 16)}",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
