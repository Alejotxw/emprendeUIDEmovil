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

                      // Opciones según el rol con diseño unificado
                      if (currentRole == UserRole.emprendedor) 
                        ..._buildEmprendedorOptions(context)
                      else 
                        ..._buildClienteOptions(context),

                      const SizedBox(height: 40),
                      _buildLogoutButton(context),
                      const SizedBox(height: 40),
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
    return Column(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: const BoxDecoration(
            color: Color(0xFF83002A),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.person, size: 60, color: Colors.white),
        ),
        const SizedBox(height: 16),
        const Text(
          'Sebastián Chocho',
          style: TextStyle(color: Color(0xFF83002A), fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const Text(
          'sechochosi@uide.edu.ec',
          style: TextStyle(color: Colors.grey, fontSize: 14, decoration: TextDecoration.underline),
        ),
      ],
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
                color: currentRole == UserRole.cliente ? const Color(0xFFFFA600) : Colors.white,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: const Color(0xFFFFA600), width: 1),
              ),
              alignment: Alignment.center,
              child: Text(
                'Cliente',
                style: TextStyle(
                  color: currentRole == UserRole.cliente ? Colors.white : Colors.black,
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
                color: currentRole == UserRole.emprendedor ? const Color(0xFFFFA600) : Colors.white,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: const Color(0xFFFFA600), width: 1),
              ),
              alignment: Alignment.center,
              child: Text(
                'Emprendedor',
                style: TextStyle(
                  color: currentRole == UserRole.emprendedor ? Colors.white : Colors.black,
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

  // VISTA EMPRENDEDOR ACTUALIZADA (Ahora se parece al cliente)
  List<Widget> _buildEmprendedorOptions(BuildContext context) {
    return [
      _buildMenuOption(
        'Comentarios de mis Servicios / Productos',
        icon: Icons.comment_outlined,
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ComentariosServiciosScreen())),
      ),
      const SizedBox(height: 12),
      _buildMenuOption(
        'Rating de mis Servicios / Productos',
        icon: Icons.star_outline,
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RatingServiciosEmprendedorScreen())),
      ),
      const SizedBox(height: 12),
      _buildMenuOption(
        'Configuraciones',
        icon: Icons.settings_outlined,
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ConfiguracionEmprendedorScreen())),
      ),
    ];
  }

  // VISTA CLIENTE ACTUALIZADA (Para que use el mismo widget base)
  List<Widget> _buildClienteOptions(BuildContext context) {
    return [
      _buildMenuOption(
        'Mis Reseñas',
        icon: Icons.rate_review_outlined,
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ReviewsScreen())),
      ),
      const SizedBox(height: 12),
      _buildMenuOption(
        'Rating de Servicios',
        icon: Icons.stars_outlined,
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RatingsScreen())),
      ),
      const SizedBox(height: 12),
      _buildMenuOption(
        'Mis Pedidos',
        icon: Icons.shopping_bag_outlined,
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const OrdersScreen())),
      ),
      const SizedBox(height: 12),
      _buildMenuOption(
        'Configuraciones',
        icon: Icons.settings_outlined,
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen())),
      ),
    ];
  }

  // WIDGET DE DISEÑO UNIFICADO
  Widget _buildMenuOption(String title, {IconData? icon, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15), // Diseño más limpio tipo Cliente
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: const Color(0xFF83002A), size: 24),
              const SizedBox(width: 16),
            ],
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
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
          border: Border.all(color: const Color(0xFFFF2121), width: 1.5),
        ),
        alignment: Alignment.center,
        child: const Text(
          'CERRAR SESIÓN',
          style: TextStyle(color: Color(0xFFFF2121), fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}