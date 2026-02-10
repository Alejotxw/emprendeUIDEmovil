import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:provider/provider.dart';
import '../models/service_model.dart';
import '../providers/review_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class PerfilPublicoScreen extends StatelessWidget {
  final ServiceModel service;

  const PerfilPublicoScreen({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil del Emprendedor'),
        backgroundColor: const Color(0xFFC8102E),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: FutureBuilder<DocumentSnapshot?>(
        future: service.ownerId.isEmpty 
            ? Future.value(null) 
            : FirebaseFirestore.instance.collection('users').doc(service.ownerId).get(),
        builder: (context, snapshot) {
          String entrepreneurName = 'Emprendedor UIDE';
          String entrepreneurPhone = 'No disponible';
          String entrepreneurEmail = 'No disponible';
          String? entrepreneurImagePath;
          bool showEmail = true;
          bool showPhone = true;
          
          if (snapshot.hasData && snapshot.data != null && snapshot.data!.exists) {
            final data = snapshot.data!.data() as Map<String, dynamic>;
            entrepreneurName = data['nombre'] ?? data['name'] ?? entrepreneurName;
            entrepreneurPhone = data['phone'] ?? entrepreneurPhone;
            entrepreneurEmail = data['email'] ?? entrepreneurEmail;
            entrepreneurImagePath = data['imagePath'];
            showEmail = data['showEmail'] ?? true;
            showPhone = data['showPhone'] ?? true;
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                _buildHeader(context, entrepreneurName, entrepreneurImagePath),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle('Sobre el Emprendimiento'),
                      _buildInfoCard(
                        context,
                        icon: Icons.description,
                        title: 'Descripción',
                        content: service.subtitle,
                      ),
                      _buildInfoCard(
                        context,
                        icon: Icons.category,
                        title: 'Categoría',
                        content: service.category,
                      ),
                      const SizedBox(height: 16),
                      _buildSectionTitle('Detalles de Contacto'),
                      _buildInfoCard(
                        context,
                        icon: Icons.location_on,
                        title: 'Ubicación Física',
                        content: 'Loja Ecuador (Campus UIDE)',
                      ),
                      if (showPhone && entrepreneurPhone != 'No disponible')
                        _buildInfoCard(
                          context,
                          icon: Icons.phone,
                          title: 'Teléfono',
                          content: entrepreneurPhone,
                        ),
                      if (showEmail && entrepreneurEmail != 'No disponible')
                        _buildInfoCard(
                          context,
                          icon: Icons.email,
                          title: 'Correo Electrónico',
                          content: entrepreneurEmail,
                        ),
                      const SizedBox(height: 16),
                      _buildSectionTitle('Reseñas'),
                      _buildReviewsSection(),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }


  // Encabezado con foto y nombre
  Widget _buildHeader(BuildContext context, String entrepreneurName, String? entrepreneurImagePath) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 30),
      decoration: const BoxDecoration(
        color: Color(0xFFC8102E),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.white,
            child: CircleAvatar(
              radius: 46,
              backgroundColor: const Color(0xFF83002A),
              backgroundImage: _getImage(entrepreneurImagePath ?? service.imageUrl),
              child: (entrepreneurImagePath == null && service.imageUrl.isEmpty)
                  ? const Icon(Icons.person, color: Colors.white, size: 40)
                  : null,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            service.name,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            entrepreneurName,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
      ),
    );
  }


  ImageProvider _getImage(String imageUrl) {
    if (imageUrl.isEmpty || imageUrl.contains('placeholder')) {
      return const AssetImage('assets/LOGO.png');
    }

    if (imageUrl.startsWith('data:image')) {
      try {
        final base64String = imageUrl.split(',').last;
        return MemoryImage(base64Decode(base64String));
      } catch (e) {
        print("Error decoding base64 image: $e");
        return const AssetImage('assets/LOGO.png');
      }
    }
    
    // Check if it is a file path
    final file = File(imageUrl);
    if (file.existsSync()) {
      return FileImage(file);
    }

    // Default to network/asset based on checking logic or generic
    if (imageUrl.startsWith('http')) {
      return NetworkImage(imageUrl);
    }
    
     if (imageUrl.startsWith('assets/')) {
        return AssetImage(imageUrl);
    }
    
    return const AssetImage('assets/food_placeholder.png');
  }

  // Títulos de sección
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  // Tarjetas informativas
  Widget _buildInfoCard(BuildContext context,
      {required IconData icon, required String title, required String content}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFFC8102E)),
        title: Text(
          title,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        subtitle: Text(
          content,
          style: TextStyle(
              fontSize: 16, 
              fontWeight: FontWeight.w500, 
              color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black87),
        ),
      ),
    );
  }

  // Sección de Reseñas
   Widget _buildReviewsSection() {
    return Consumer<ReviewProvider>(
      builder: (context, reviewProvider, child) {
         final reviews = reviewProvider.reviews.where((r) {
             return r.serviceId == service.id || 
                    r.serviceName == service.name || 
                    r.serviceName == service.id;
         }).toList();

         if (reviews.isEmpty) {
           return Container(
             width: double.infinity,
             padding: const EdgeInsets.all(16),
             decoration: BoxDecoration(
               color: Colors.orange.withOpacity(0.1),
               borderRadius: BorderRadius.circular(12),
               border: Border.all(color: Colors.orange.withOpacity(0.3)),
             ),
             child: const Center(
               child: Text(
                 'Aún no hay reseñas',
                 style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic, color: Colors.orange),
               ),
             ),
           );
         }

         return Column(
           children: reviews.map((r) => Container(
             margin: const EdgeInsets.only(bottom: 12),
             padding: const EdgeInsets.all(12),
             decoration: BoxDecoration(
               color: Theme.of(context).brightness == Brightness.dark ? Colors.grey[800] : Colors.grey[50],
               borderRadius: BorderRadius.circular(8),
               border: Border.all(color: Colors.grey.withOpacity(0.3)),
             ),
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     Text(r.userName, style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black)),
                     Row(
                       children: List.generate(5, (index) => Icon(
                         index < r.rating ? Icons.star : Icons.star_border,
                         color: Colors.amber,
                         size: 16,
                       )),
                     )
                   ],
                 ),
                 const SizedBox(height: 4),
                 Text(r.comment, style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.white70 : Colors.black87)),
               ],
             ),
           )).toList(),
         );
      },
    );
  }
}
