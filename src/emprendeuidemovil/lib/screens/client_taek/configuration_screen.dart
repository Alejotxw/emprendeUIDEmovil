import 'package:flutter/material.dart';

class ConfigurationScreen extends StatelessWidget {
  const ConfigurationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Configuración', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            
            // --- SECCIÓN 1: EJEMPLO DE "MIS PEDIDOS" ---
            _buildSectionHeader('Actividad Reciente (Mis Pedidos)'),
            const SizedBox(height: 12),
            _buildOrderPreviewCard(
              serviceName: 'Limpieza de Muebles',
              date: 'Hoy, 10:30 AM',
              status: 'En camino',
              price: '30.00',
              statusColor: Colors.blue,
            ),

            const SizedBox(height: 30),

            // --- SECCIÓN 2: UNIÓN DE RESEÑAS CON RATING (EJEMPLO) ---
            _buildSectionHeader('Mis Valoraciones (Rating + Reseña)'),
            const SizedBox(height: 12),
            _buildMergedReviewCard(
              providerName: 'Pedro Técnico',
              service: 'Reparación Eléctrica',
              rating: 5,
              comment: 'Excelente atención, muy profesional y el precio fue justo.',
              date: '12 Ene 2026',
            ),
            
            const SizedBox(height: 30),

            // --- SECCIÓN 3: MENU DE CONFIGURACIÓN ---
            _buildSectionHeader('Ajustes de Cuenta'),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
              ),
              child: Column(
                children: [
                  _buildListTile(
                    icon: Icons.person_pin_outlined,
                    title: 'Editar Perfil',
                    subtitle: 'Cambia tu foto y datos personales',
                    onTap: () {
                      // Conecta con edit_profile_screen.dart
                    },
                  ),
                  const Divider(height: 1, indent: 50),
                  _buildListTile(
                    icon: Icons.star_outline,
                    title: 'Ver todas mis valoraciones',
                    subtitle: 'Gestiona tus reseñas y ratings unidos',
                    onTap: () {
                      // Aquí podrías dirigir a un histórico unificado
                    },
                  ),
                  const Divider(height: 1, indent: 50),
                  _buildListTile(
                    icon: Icons.history,
                    title: 'Historial de Pedidos',
                    subtitle: 'Revisa todos tus servicios pasados',
                    onTap: () {
                      // Conecta con orders_screen.dart
                    },
                  ),
                  const Divider(height: 1, indent: 50),
                  _buildListTile(
                    icon: Icons.shield_outlined,
                    title: 'Privacidad',
                    onTap: () {
                      // Conecta con privacy_screen.dart
                    },
                  ),
                  const Divider(height: 1, indent: 50),
                  _buildListTile(
                    icon: Icons.help_outline,
                    title: 'Soporte',
                    onTap: () {
                      // Conecta con support_screen.dart
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // BOTÓN CERRAR SESIÓN
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(foregroundColor: const Color.fromARGB(255, 150, 24, 15)),
                child: const Text('Cerrar Sesión', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // --- WIDGETS PERSONALIZADOS PARA DISEÑO ---

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey[600], letterSpacing: 0.8),
    );
  }

  // EJEMPLO DE CÓMO SE VERÍA "MIS PEDIDOS"
  Widget _buildOrderPreviewCard({
    required String serviceName,
    required String date,
    required String status,
    required String price,
    required Color statusColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Row(
        children: [
          CircleAvatar(backgroundColor: statusColor.withOpacity(0.1), child: Icon(Icons.handyman, color: statusColor)),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(serviceName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text(date, style: const TextStyle(color: Colors.grey, fontSize: 13)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('\$$price', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.green)),
              Text(status, style: TextStyle(color: statusColor, fontSize: 12, fontWeight: FontWeight.w600)),
            ],
          )
        ],
      ),
    );
  }

  // EJEMPLO DE UNIÓN RESEÑA + RATING
  Widget _buildMergedReviewCard({
    required String providerName,
    required String service,
    required int rating,
    required String comment,
    required String date,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2C3E50), // Color oscuro elegante
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(service, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              Row(
                children: List.generate(5, (index) => Icon(
                  index < rating ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                  size: 16,
                )),
              ),
            ],
          ),
          Text('Proveedor: $providerName', style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12)),
          const SizedBox(height: 10),
          Text(
            '"$comment"',
            style: const TextStyle(color: Colors.white, fontStyle: FontStyle.italic, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.bottomRight,
            child: Text(date, style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 11)),
          )
        ],
      ),
    );
  }

  Widget _buildListTile({required IconData icon, required String title, String? subtitle, required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.blueGrey[800]),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: subtitle != null ? Text(subtitle, style: const TextStyle(fontSize: 12)) : null,
      trailing: const Icon(Icons.chevron_right, size: 20),
      onTap: onTap,
    );
  }
}