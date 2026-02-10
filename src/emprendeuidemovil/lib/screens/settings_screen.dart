import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import '../providers/settings_provider.dart';
import '../providers/user_profile_provider.dart'; // Agregado
import 'dart:io'; // Agregado
import 'client_taek/edit_profile_screen.dart';  // Import para navegación a edición
import 'client_taek/support_screen.dart';
import 'client_taek/privacy_screen.dart';
import 'product_registration_screen.dart'; // Nueva pantalla de registro de producto

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _generalNotifications = true;
  bool _requestNotifications = false;
  String _selectedLanguage = 'Español';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Configuraciones'),
        backgroundColor: const Color(0xFFC8102E),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Mi Perfil
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Consumer<UserProfileProvider>(
                  builder: (context, userProfile, child) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: const Color(0xFFC8102E),
                              backgroundImage: _getProfileImage(userProfile.imagePath),
                              child: (userProfile.imagePath == null || userProfile.imagePath!.isEmpty)
                                  ? const Icon(Icons.person, color: Colors.white)
                                  : null,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Mi Perfil',
                                      style: TextStyle(
                                          fontSize: 18, fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 4),
                                  Text('Nombre: ${userProfile.name}',
                                      style: const TextStyle(fontSize: 16)),
                                  Text('Teléfono: ${userProfile.phone}',
                                      style: const TextStyle(fontSize: 16)),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.edit, color: Colors.white),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            onPressed: () {
                              // Navega a pantalla de edición completa
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EditProfileScreen(
                                          initialName: userProfile.name,
                                          initialPhone: userProfile.phone,
                                          initialImage: userProfile.imagePath,
                                        )),
                              );
                            },
                            label: const Text('Editar'),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Apariencia
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Apariencia', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Consumer<SettingsProvider>(
                      builder: (context, settings, child) {
                        return Column(
                          children: [
                            SwitchListTile(
                              title: const Text('Modo oscuro'),
                              subtitle: const Text('Cambiar entre tema claro y oscuro'),
                              value: settings.darkMode,
                              onChanged: (value) => settings.setDarkMode(value),
                              activeColor: const Color(0xFFC8102E),
                            ),
                            SwitchListTile(
                              title: const Text('Fuente grande'),
                              subtitle: const Text('Aumentar el tamaño del texto'),
                              value: settings.largeFont,
                              onChanged: (value) => settings.setLargeFont(value),
                              activeColor: const Color(0xFFC8102E),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Notificaciones generales
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Notificaciones generales', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    SwitchListTile(
                      title: const Text('Recibe actualizaciones importantes'),
                      value: _generalNotifications,
                      onChanged: (value) => setState(() => _generalNotifications = value),
                      activeColor: const Color(0xFFC8102E),
                    ),
                    SwitchListTile(
                      title: const Text('Estado de tus solicitudes'),
                      value: _requestNotifications,
                      onChanged: (value) => setState(() => _requestNotifications = value),
                      activeColor: const Color(0xFFC8102E),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Idioma
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Idioma', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Text('Actualmente solo disponible en '),
                        Chip(
                          label: const Text('Español'),
                          backgroundColor: Colors.orange[100],
                          labelStyle: const TextStyle(color: Color(0xFFC8102E)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Privacidad y Seguridad (navega a sub-pantalla)
            Card(
              child: ListTile(
                leading: const Icon(Icons.privacy_tip, color: Color(0xFFC8102E)),
                title: const Text('Privacidad y Seguridad'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PrivacyScreen()),  // Non-const para fix error
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            const SizedBox(height: 16),
            // Acerca de UIDE V1
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.warning, color: Colors.red, size: 24),
                    const SizedBox(height: 8),
                    const Text('Acerca de UIDE V1', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    const Text(
                      'Emprende UIDE V1\nMarketplace para la Comunidad UIDE\nUniversidad Internacional del Ecuador',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    const Center(
                      child: Text(
                        '© 2025 UIDE. Todos los derechos reservados.',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
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
  }

  ImageProvider? _getProfileImage(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) return null;
    
    if (imagePath.startsWith('data:image')) {
      try {
        final b64 = imagePath.split(',').last;
        return MemoryImage(base64Decode(b64));
      } catch (e) {
        return null;
      }
    }
    
    if (imagePath.startsWith('http')) {
      return NetworkImage(imagePath);
    }
    
    final file = File(imagePath);
    if (file.existsSync()) {
      return FileImage(file);
    }
    
    return null;
  }
}