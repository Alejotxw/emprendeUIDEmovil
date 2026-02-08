import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../providers/review_provider.dart';

class ComentariosServiciosScreen extends StatefulWidget {
  const ComentariosServiciosScreen({super.key});

  @override
  State<ComentariosServiciosScreen> createState() =>
      _ComentariosServiciosScreenState();
}

class _ComentariosServiciosScreenState
    extends State<ComentariosServiciosScreen> {
  // ⚠️ DEBE coincidir con el ownerId que mandas al crear la reseña
  final String ownerId = "TEMP_OWNER_ID";

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ReviewProvider>(
        context,
        listen: false,
      ).fetchReviewsByOwner(ownerId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          _buildTopBar(context),
          Expanded(
            child: Consumer<ReviewProvider>(
              builder: (context, reviewProvider, child) {
                final reviews = reviewProvider.reviews;

                if (reviews.isEmpty) {
                  return const Center(child: Text("No hay reseñas aún."));
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: reviews.length,
                  itemBuilder: (context, index) {
                    final review = reviews[index];

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: CommentCard(
                        reviewId: review.id,
                        serviceId: review.serviceId,
                        userName: review.userName,
                        time: DateFormat('HH:mm dd/MM').format(review.date),
                        comment: review.comment,
                        rating: review.rating,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 50, bottom: 20, left: 16, right: 16),
      decoration: const BoxDecoration(
        color: Color(0xFF83002A),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 8),
          const Expanded(
            child: Text(
              'Reseñas',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 40),
        ],
      ),
    );
  }
}

class CommentCard extends StatelessWidget {
  final String reviewId;
  final String serviceId;
  final String userName;
  final String time;
  final String comment;
  final int rating;

  const CommentCard({
    super.key,
    required this.reviewId,
    required this.serviceId,
    required this.userName,
    required this.time,
    required this.comment,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? Colors.grey.shade800 : Colors.grey.shade400,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Servicio: $serviceId",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Text(
                userName,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                time,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: List.generate(5, (index) {
              return Icon(
                index < rating ? Icons.star : Icons.star_border,
                color: const Color(0xFFFFA600),
                size: 20,
              );
            }),
          ),
          const SizedBox(height: 12),
          Text(
            comment.isEmpty ? "Sin comentario" : comment,
            style: TextStyle(
              fontSize: 15,
              color: isDark ? Colors.white70 : Colors.black,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
