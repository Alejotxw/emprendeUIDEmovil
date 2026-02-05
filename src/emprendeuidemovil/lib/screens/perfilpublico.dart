import 'package:flutter/material.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import '../models/service_model.dart';
import '../providers/user_profile_provider.dart';

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
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(context),
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
                  const SizedBox(height: 16),
                  _buildSectionTitle('Detalles de Contacto'),
                  _buildInfoCard(
                    context,
                    icon: Icons.category,
                    title: 'Categoría',
                    content: service.category,
                  ),
                  _buildInfoCard(
                    context,
                    icon: Icons.location_on,
                    title: 'Ubicación Física',
                    content: 'Quito, Ecuador (Campus UIDE)',
                  ),
                  const SizedBox(height: 16),
                  _buildSectionTitle('Estadísticas'),
                  _buildRatingSection(),
                  const SizedBox(height: 24),
                  _buildSocialMediaButtons(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Encabezado con foto y nombre
  Widget _buildHeader(BuildContext context) {
    return Consumer<UserProfileProvider>(
      builder: (context, userProfile, child) {
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
                  backgroundImage: userProfile.imagePath != null
                      ? FileImage(File(userProfile.imagePath!))
                      : null,
                  child: userProfile.imagePath == null
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
              Text(
                userProfile.name.isNotEmpty ? userProfile.name : 'Emprendedor UIDE',
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ],
          ),
        );
      },
    );
  }

  ImageProvider _getImage(String imageUrl) {
    if (imageUrl.isEmpty || imageUrl.contains('placeholder')) {
      return const AssetImage('assets/food_placeholder.png');
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
    
    return AssetImage(imageUrl);
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

  // Sección de Rating
  Widget _buildRatingSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.star, color: Colors.orange, size: 30),
          const SizedBox(width: 10),
          Text(
            '${service.rating}',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 10),
          const Text('Calificación promedio del servicio'),
        ],
      ),
    );
  }

  // Botones de Redes Sociales
  Widget _buildSocialMediaButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _socialIcon(Icons.phone, Colors.green),
        _socialIcon(Icons.camera_alt, Colors.purple), // Instagram
        _socialIcon(Icons.language, Colors.blue), // Web/Facebook
      ],
    );
  }

  Widget _socialIcon(IconData icon, Color color) {
    return CircleAvatar(
      backgroundColor: color.withOpacity(0.1),
      radius: 25,
      child: IconButton(
        icon: Icon(icon, color: color),
        onPressed: () {
          // Aquí podrías usar url_launcher en el futuro
        },
      ),
    );
  }
}