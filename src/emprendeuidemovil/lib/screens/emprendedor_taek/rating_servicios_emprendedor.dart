import 'package:flutter/material.dart';

class RatingServiciosEmprendedorScreen extends StatelessWidget {
  const RatingServiciosEmprendedorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Custom Top Bar with Back Button
          _buildTopBar(context),
          
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
              children: [
                _buildRatingCard(
                  title: 'Comida Casera',
                  name: 'Romny Rios',
                  type: 'Postre',
                  rating: 3,
                ),
                const SizedBox(height: 16),
                _buildRatingCard(
                  title: 'Comida Casera',
                  name: 'Romny Rios',
                  type: 'Postre',
                  rating: 3,
                ),
                const SizedBox(height: 16),
                _buildRatingCard(
                  title: 'Comida Casera',
                  name: 'Romny Rios',
                  type: 'Postre',
                  rating: 3,
                ),
                // Add padding at the bottom for safety
                const SizedBox(height: 40),
              ],
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
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.undo, color: Colors.white, size: 30), // Using undo icon to match the curved arrow in the image
            onPressed: () => Navigator.pop(context),
          ),
          const Expanded(
            child: Text(
              'Rating de mis Servicos /\nProductos',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 40), // Balance the back button spacing
        ],
      ),
    );
  }

  Widget _buildRatingCard({
    required String title,
    required String name,
    required String type,
    required int rating,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade400, width: 1),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            name,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 14, color: Colors.black),
              children: [
                const TextSpan(
                  text: 'Servicio/producto: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: type),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Icon(
                  index < rating ? Icons.star : Icons.star_border,
                  color: const Color(0xFFFFA600), // Gold/Amber color
                  size: 32,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}