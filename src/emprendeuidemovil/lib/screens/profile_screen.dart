import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Imports de tus pantallas
import 'package:emprendeuidemovil/screens/emprendedor_taek/comentarios_servicios.dart';
import 'package:emprendeuidemovil/screens/emprendedor_taek/configuracion_emprendedor.dart';
import 'package:emprendeuidemovil/screens/emprendedor_taek/rating_servicios_emprendedor.dart';

// Imports del modo cliente
import '../screens/client_taek/reviews_screen.dart';
import '../screens/client_taek/ratings_screen.dart';
import '../screens/client_taek/orders_screen.dart';
import '../screens/settings_screen.dart';

// Import del provider
import 'package:emprendeuidemovil/providers/user_role_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserRoleProvider>(
      builder: (context, roleProvider, child) {
        final currentRole = roleProvider.role;

        return Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            children: [
              _buildTopBar(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      _buildProfileInfo(),
                      const SizedBox(height: 24),
                      _buildRoleSwitcher(context, roleProvider, currentRole),
                      const SizedBox(height: 32),

                      // Opciones según el rol
                      if (currentRole == UserRole.emprendedor) 
                        ..._buildEmprendedorOptions(context)
                      else 
                        ..._buildClienteOptions(context),

                      const SizedBox(height: 40),
                      _buildLogoutButton(context),
                      const SizedBox(height: 20),
                      const Text(
                        "TAEK versión 1.0",
                        style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 100),
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
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
      ),
      child: const Text(
        'Mi Perfil',
        style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildProfileInfo() {
    return Column(
      children: [
        Container(
          width: 100, height: 100,
          decoration: const BoxDecoration(color: Color(0xFF83002A), shape: BoxShape.circle),
          child: const Icon(Icons.person, size: 60, color: Colors.white),
        ),
        const SizedBox(height: 16),
        const Text('Sebastián Chocho', style: TextStyle(color: Color(0xFF83002A), fontSize: 20, fontWeight: FontWeight.bold)),
        const Text('sechochosi@uide.edu.ec', style: TextStyle(color: Colors.grey, fontSize: 14, decoration: TextDecoration.underline)),
      ],
    );
  }

  Widget _buildRoleSwitcher(BuildContext context, UserRoleProvider roleProvider, UserRole currentRole) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center, // CORREGIDO AQUÍ
      children: [
        _buildRoleButton('Cliente', currentRole == UserRole.cliente, () => roleProvider.setRole(UserRole.cliente)),
        const SizedBox(width: 30),
        _buildRoleButton('Emprendedor', currentRole == UserRole.emprendedor, () => roleProvider.setRole(UserRole.emprendedor)),
      ],
    );
  }

  Widget _buildRoleButton(String text, bool isSelected, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFFFA600) : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFFFA600)),
          ),
          alignment: Alignment.center,
          child: Text(text, style: TextStyle(color: isSelected ? Colors.white : Colors.black, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  // --- SECCIÓN CLIENTE: UNIFICACIÓN Y EJEMPLOS ---

  List<Widget> _buildClienteOptions(BuildContext context) {
    return [
      // 1. UNIFICACIÓN DE BOTONES
      ListTile(
        leading: const Icon(Icons.star_rate_rounded, color: Color(0xFF83002A)),
        title: const Text('Mis Valoraciones'),
        trailing: const Icon(Icons.arrow_forward_ios, size: 18),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ReviewsScreen())),
      ),

      // 2. MIS PEDIDOS
      ListTile(
        leading: const Icon(Icons.shopping_bag_outlined, color: Color(0xFF83002A)),
        title: const Text('Mis Pedidos'),
        trailing: const Icon(Icons.arrow_forward_ios, size: 18),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const OrdersScreen())),
      ),

      // 3. CONFIGURACIONES
      ListTile(
        leading: const Icon(Icons.settings_outlined, color: Color(0xFF83002A)),
        title: const Text('Configuraciones'),
        trailing: const Icon(Icons.arrow_forward_ios, size: 18),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen())),
      ),
    ];
  }

  Widget _buildVisualExample({required String label, required Widget child}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.blueGrey)),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }

  // --- RESTO DE FUNCIONALIDADES INTACTAS ---

  List<Widget> _buildEmprendedorOptions(BuildContext context) {
    return [
      _buildMenuOption('Comentarios de mis Servicios / Productos', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ComentariosServiciosScreen()))),
      const SizedBox(height: 16),
      _buildMenuOption('Rating de mis Servicios / Productos', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RatingServiciosEmprendedorScreen()))),
      const SizedBox(height: 16),
      _buildMenuOption('Configuraciones', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ConfiguracionEmprendedorScreen()))),
    ];
  }

  Widget _buildMenuOption(String title, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.grey.shade400),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: Text(title, style: const TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.w500))),
            const Icon(Icons.chevron_right, color: Colors.black),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushReplacementNamed(context, "/"),
      child: Container(
        width: 250,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: const Color.fromARGB(255, 255, 33, 33), width: 1.5),
        ),
        alignment: Alignment.center,
        child: const Text('CERRAR SESIÓN', style: TextStyle(color: Color.fromARGB(255, 255, 33, 33), fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    );
  }
}