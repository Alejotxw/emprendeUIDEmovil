import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Imports de tus pantallas
import 'package:emprendeuidemovil/screens/emprendedor_taek/comentarios_servicios.dart';
import 'package:emprendeuidemovil/screens/emprendedor_taek/configuracion_emprendedor.dart';


// Imports del modo cliente (ajusta si los nombres son diferentes)
import '../screens/client_taek/reviews_screen.dart';

import '../screens/client_taek/orders_screen.dart';
import '../screens/settings_screen.dart';

// Import del provider (¡OBLIGATORIO!)
import 'package:emprendeuidemovil/providers/user_role_provider.dart';
import 'package:emprendeuidemovil/providers/user_profile_provider.dart';
import 'dart:io'; // Para FileImage
import 'dart:convert'; // Para base64Decode
import 'package:firebase_auth/firebase_auth.dart'; // Added for signOut
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Escuchamos el rol directamente del provider
    return Consumer<UserRoleProvider>(
      builder: (context, roleProvider, child) {
        final currentRole = roleProvider.role;

        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: Column(
            children: [
              // Barra superior
              _buildTopBar(),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      _buildProfileInfo(),
                      const SizedBox(height: 24),

                      // Switch de rol (actualiza el provider al tocar)
                      _buildRoleSwitcher(context, roleProvider, currentRole),

                      const SizedBox(height: 32),

                      // Opciones según el rol
                      if (currentRole == UserRole.emprendedor) ..._buildEmprendedorOptions(context)
                      else ..._buildClienteOptions(context),

                      const SizedBox(height: 40),
                      _buildLogoutButton(context),
                      const SizedBox(height: 40),
                      const Text(
                        "TAEK versión 1.0",
                        style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 100), // Espacio para la bottom bar
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTopBar() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 50, bottom: 20, left: 24, right: 24),
      decoration: const BoxDecoration(
        color: Color(0xFF83002A),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: const Text(
        'Mi Perfil',
        style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildProfileInfo() {
    return Consumer<UserProfileProvider>(
      builder: (context, userProfile, child) {
        return Column(
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: const BoxDecoration(
                color: Color(0xFF83002A),
                shape: BoxShape.circle,
              ),
              clipBehavior: Clip.antiAlias,
              child: _buildProfileImage(userProfile.imagePath),
            ),
            const SizedBox(height: 16),
            Text(
              userProfile.name,
              style: const TextStyle(
                  color: Color(0xFF83002A),
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              FirebaseAuth.instance.currentUser?.email ?? 'No email',
              style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                  decoration: TextDecoration.underline),
            ),
            const SizedBox(height: 8),
            Text(
              userProfile.phone,
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ],
        );
      },
    );
  }

  Widget _buildRoleSwitcher(BuildContext context, UserRoleProvider roleProvider, UserRole currentRole) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => roleProvider.setRole(UserRole.cliente),
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              height: 45,
              decoration: BoxDecoration(
                color: currentRole == UserRole.cliente ? const Color(0xFFFFA600) : (Theme.of(context).brightness == Brightness.dark ? Colors.transparent : Colors.white),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: const Color(0xFFFFA600), width: 1),
              ),
              alignment: Alignment.center,
              child: Text(
                'Cliente',
                style: TextStyle(
                  color: currentRole == UserRole.cliente ? Colors.white : (Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () => roleProvider.setRole(UserRole.emprendedor),
            child: Container(
              margin: const EdgeInsets.only(left: 12),
              height: 45,
              decoration: BoxDecoration(
                color: currentRole == UserRole.emprendedor ? const Color(0xFFFFA600) : (Theme.of(context).brightness == Brightness.dark ? Colors.transparent : Colors.white),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: const Color(0xFFFFA600), width: 1),
              ),
              alignment: Alignment.center,
              child: Text(
                'Emprendedor',
                style: TextStyle(
                  color: currentRole == UserRole.emprendedor ? Colors.white : (Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildEmprendedorOptions(BuildContext context) {
    return [
      _buildMenuOption(
        context,
        'Reseñas',
        Icons.rate_review,
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ComentariosServiciosScreen())),
      ),
      const SizedBox(height: 16),
      _buildMenuOption(
        context,
        'Configuraciones',
        Icons.settings,
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ConfiguracionEmprendedorScreen())),
      ),
    ];
  }

  List<Widget> _buildClienteOptions(BuildContext context) {
    return [
      ListTile(
        leading: const Icon(Icons.rate_review, color: Color(0xFF83002A)),
        title: const Text('Reseñas'),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ReviewsScreen())),
      ),
      ListTile(
        leading: const Icon(Icons.shopping_cart, color: Color(0xFF83002A)),
        title: const Text('Mis Pedidos'),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const OrdersScreen())),
      ),
      ListTile(
        leading: const Icon(Icons.settings, color: Color(0xFF83002A)),
        title: const Text('Configuraciones'),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen())),
      ),
    ];
  }

  Widget _buildMenuOption(BuildContext context, String title, IconData icon, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade800 : Colors.grey.shade400),
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF83002A)),
            const SizedBox(width: 16),
            Expanded(
              child: Text(title, style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black, fontSize: 15, fontWeight: FontWeight.w500)),
            ),
            Icon(Icons.chevron_right, color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await FirebaseAuth.instance.signOut();
        if (context.mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        }
      },
      child: Container(
        width: 250,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark ? Colors.transparent : const Color.fromARGB(255, 255, 255, 255),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: const Color.fromARGB(255, 255, 33, 33), width: 1.5),
        ),
        alignment: Alignment.center,
        child: const Text(
          'CERRAR SESIÓN',
          style: TextStyle(color: Color.fromARGB(255, 255, 33, 33), fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildProfileImage(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) {
      return const Icon(Icons.person, size: 60, color: Colors.white);
    }
    
    // 1. Handle Base64
    if (imagePath.startsWith('data:image')) {
      try {
        final base64String = imagePath.split(',').last;
        return Image.memory(
          base64Decode(base64String),
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) =>
              const Icon(Icons.person, size: 60, color: Colors.white),
        );
      } catch (e) {
        return const Icon(Icons.person, size: 60, color: Colors.white);
      }
    }

    // 2. Handle Network URL
    if (imagePath.startsWith('http')) {
      return Image.network(
        imagePath,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
            const Icon(Icons.person, size: 60, color: Colors.white),
      );
    }

    // 3. Handle Local File (checking if it exists)
    final file = File(imagePath);
    if (file.existsSync()) {
      return Image.file(
        file,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
            const Icon(Icons.person, size: 60, color: Colors.white),
      );
    }

    // Fallback if local file doesn't exist (e.g. from another device)
    return const Icon(Icons.person, size: 60, color: Colors.white);
  }
}