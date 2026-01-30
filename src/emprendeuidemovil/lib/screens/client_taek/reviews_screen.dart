import 'package:flutter/material.dart';

class ReviewsScreen extends StatefulWidget {
  const ReviewsScreen({super.key});

  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  // Simulación de datos que vendrían de una base de datos
  List<Map<String, dynamic>> reviews = [
    {'id': 1, 'comment': '¡Excelente servicio!', 'rating': 5},
    {'id': 2, 'comment': 'La comida llegó un poco fría.', 'rating': 3},
  ];

  void _updateRating(int index, int newRating) {
    setState(() {
      reviews[index]['rating'] = newRating;
    });
  }

  void _updateComment(int index, String newText) {
    setState(() {
      reviews[index]['comment'] = newText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reseñas'),
        backgroundColor: const Color(0xFFC8102E),
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: reviews.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 4,
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- SECCIÓN DE ESTRELLAS ---
                  Row(
                    children: List.generate(5, (starIndex) {
                      return IconButton(
                        icon: Icon(
                          starIndex < reviews[index]['rating'] 
                              ? Icons.star 
                              : Icons.star_border,
                          color: Colors.amber,
                        ),
                        onPressed: () => _updateRating(index, starIndex + 1),
                      );
                    }),
                  ),
                  const SizedBox(height: 8),
                  // --- CUADRO DE TEXTO EDITABLE ---
                  TextFormField(
                    initialValue: reviews[index]['comment'],
                    decoration: const InputDecoration(
                      labelText: 'Tu comentario',
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFC8102E)),
                      ),
                    ),
                    maxLines: 2,
                    onChanged: (value) => _updateComment(index, value),
                  ),
                  const SizedBox(height: 8),
                  // --- ACCIONES (Borrar) ---
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.grey),
                      onPressed: () {
                        setState(() {
                          reviews.removeAt(index);
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}