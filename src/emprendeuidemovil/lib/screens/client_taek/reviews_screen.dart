import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import '../../providers/review_provider.dart';

class ReviewsScreen extends StatelessWidget {
  const ReviewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reseñas'),
        backgroundColor: const Color(0xFFC8102E),
        foregroundColor: Colors.white,
      ),
      body: Consumer<ReviewProvider>(
        builder: (context, reviewProvider, child) {
          final reviews = reviewProvider.reviews;

          if (reviews.isEmpty) {
            return const Center(child: Text("No has realizado reseñas aún."));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: reviews.length,
            itemBuilder: (context, index) {
              final review = reviews[index];
              return Card(
                elevation: 4,
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // --- ENCABEZADO (Servicio/Emprendimiento) ---
                      Text(
                        review.serviceName,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 8),

                      // --- SECCIÓN DE ESTRELLAS (Solo lectura por ahora, o editable si agregamos update en provider) ---
                      Row(
                        children: List.generate(5, (starIndex) {
                          return Icon(
                            starIndex < review.rating ? Icons.star : Icons.star_border,
                            color: Colors.amber,
                          );
                        }),
                      ),
                      const SizedBox(height: 8),

                      // --- CUADRO DE TEXTO (Solo lectura para visualizar lo enviado) ---
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          // Ajuste para Dark Mode
                          color: Theme.of(context).brightness == Brightness.dark 
                              ? const Color(0xFF2C2C2C) 
                              : Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Theme.of(context).brightness == Brightness.dark 
                                ? Colors.grey.shade700 
                                : Colors.grey.shade300
                          ),
                        ),
                        child: Text(
                          review.comment,
                          style: TextStyle(
                            fontSize: 14,
                            // Ensure text is readable on the background
                            color: Theme.of(context).brightness == Brightness.dark 
                                ? Colors.white70 
                                : Colors.black87,
                          ),
                        ),
                      ),

                      // --- RESPUESTA DEL EMPRENDEDOR ---
                      if (review.response != null) ...[
                        const SizedBox(height: 12),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF3E0), // Naranja muy claro
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.orange.shade200),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Respuesta del Emprendedor:",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold, 
                                  fontSize: 12, 
                                  color: Color(0xFFE65100)
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                review.response!,
                                style: const TextStyle(fontSize: 14, color: Colors.black87),
                              ),
                            ],
                          ),
                        ),
                      ],
                      
                      const SizedBox(height: 8),
                      // --- ACCIONES DE EDICIÓN Y ELIMINACIÓN ---
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => _showEditDialog(context, review),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _confirmDelete(context, review.id),
                          ),
                        ],
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

  void _showEditDialog(BuildContext context, dynamic review) {
    final TextEditingController commentController = TextEditingController(text: review.comment);
    int rating = review.rating;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text('Editar Reseña'), // Fixed title
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                   Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return IconButton(
                        onPressed: () {
                          setStateDialog(() {
                            rating = index + 1;
                          });
                        },
                        icon: Icon(
                          index < rating ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                          size: 32,
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: commentController,
                    decoration: const InputDecoration(
                      labelText: 'Comentario',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (commentController.text.isNotEmpty) {
                      Provider.of<ReviewProvider>(context, listen: false)
                          .updateReview(review.id, commentController.text, rating);
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Reseña actualizada')),
                      );
                    }
                  },
                  child: const Text('Guardar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, String reviewId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Reseña'),
        content: const Text('¿Estás seguro de que deseas eliminar esta reseña?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Provider.of<ReviewProvider>(context, listen: false).deleteReview(reviewId);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Reseña eliminada')),
              );
            },
            child: const Text('Eliminar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}