import 'dart:io';
import 'package:flutter/material.dart';
import 'package:emprendeuidemovil/screens/emprendedor_taek/comentarios_servicios.dart';
import 'package:emprendeuidemovil/screens/emprendedor_taek/configuracion_emprendedor.dart';
import 'package:provider/provider.dart';
import 'package:emprendeuidemovil/providers/user_profile_provider.dart';
import '../login_screen.dart';


class EmprendedorPerfilScreen extends StatefulWidget {
  const EmprendedorPerfilScreen({super.key});

  @override
  State<EmprendedorPerfilScreen> createState() => _EmprendedorPerfilScreenState();
}

class _EmprendedorPerfilScreenState extends State<EmprendedorPerfilScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          // 1. Top Bar
          _buildTopBar(),

          // Body Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  // 2. Profile Info
                  _buildProfileInfo(),

                  const SizedBox(height: 24),
                  // 3. Role Switcher
                  _buildRoleSwitcher(),

                  const SizedBox(height: 32),
                  // 4. Menu Options
                  _buildMenuOption(
                    'Reseñas',
                    Icons.rate_review,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ComentariosServiciosScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildMenuOption('Configuraciones', Icons.settings, onTap: () async {
                      // Navigate directly - Provider handles the state
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ConfiguracionEmprendedorScreen(),
                        ),
                      );
                  }),

                  const SizedBox(height: 40),
                  // 5. Logout Button
                  _buildLogoutButton(context),
                  
                  const SizedBox(height: 40),
                  const Text(
                    "TAEK versión 1.0",
                         style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                  ),

                  // Add extra padding at bottom to account for the custom floating nav bar in main.dart
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
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
        style: TextStyle(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildProfileInfo() {
    return Consumer<UserProfileProvider>(
      builder: (context, userProfile, child) {
        return Column(
          children: [
            // Avatar
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: const Color(0xFF83002A),
                shape: BoxShape.circle,
                image: userProfile.imagePath != null
                    ? DecorationImage(
                        image: FileImage(File(userProfile.imagePath!)),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              clipBehavior: Clip.antiAlias,
              child: userProfile.imagePath == null
                  ? const Icon(Icons.person, size: 60, color: Colors.white)
                  : null,
            ),
            const SizedBox(height: 16),
            // Name
            Text(
              userProfile.name,
              style: const TextStyle(
                color: Color(0xFF83002A),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            // Email
            const Text(
              'sechochosi@uide.edu.ec',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
                decoration: TextDecoration.underline,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildRoleSwitcher() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Cliente Button
        Expanded(
          child: Container(
             margin: const EdgeInsets.only(right: 12),
            height: 45,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: const Color(0xFFFFA600), width: 1),
            ),
             alignment: Alignment.center,
            child: const Text(
              'Cliente',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
        // Emprendedor Button
        Expanded(
          child: Container(
            height: 45,
             margin: const EdgeInsets.only(left: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFA600),
              borderRadius: BorderRadius.circular(25),
            ),
             alignment: Alignment.center,
            child: const Text(
              'Emprendedor',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuOption(String title, IconData icon, {VoidCallback? onTap}) {
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
              child: Text(
                title,
                style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(Icons.chevron_right, color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      ),
      child: Container(
        width: 250,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: const Color.fromARGB(255, 255, 33, 33), width: 1.5),
        ),
        alignment: Alignment.center,
        child: const Text(
          'CERRAR SESION',
          style: TextStyle(
            color: Color.fromARGB(255, 255, 33, 33),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
