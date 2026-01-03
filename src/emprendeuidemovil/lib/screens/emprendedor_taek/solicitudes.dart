import 'package:flutter/material.dart';
import 'package:emprendeuidemovil/screens/emprendedor_taek/detalle_solicitud.dart';

class SolicitudesScreen extends StatelessWidget {
  const SolicitudesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 50, bottom: 20, left: 24, right: 24),
            decoration: const BoxDecoration(
              color: Color(0xFF83002A),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: const Center(
              child: Text(
                'Ver Solicitudes',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          
          Expanded(
            child: GridView.count(
              padding: const EdgeInsets.all(16),
              crossAxisCount: 2,
              childAspectRatio: 0.70, // Adjust for card height
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: [
                _buildSolicitudCard(
                  context, // Pass context for navigation
                  tag: 'Web',
                  title: 'Diseño Web',
                  description: 'Preparo postres y dulces.',
                  price: '5.00',
                  status: 'Aceptado',
                  statusColor: const Color(0xFF4CAF50),
                  notificationCount: 0,
                  requesterName: 'Juan Perez', // Dummy data
                  items: [
                     {'name': 'Landing Page', 'detail': 'HTML/CSS', 'price': '5.00'}
                  ],
                ),
                _buildSolicitudCard(
                  context,
                  tag: 'Diseño',
                  title: 'Diseño Grafico',
                  description: 'Publicidad',
                  price: '10.00',
                  status: 'Pendiente',
                  statusColor: Colors.grey,
                  notificationCount: 0,
                  requesterName: 'Maria Lopez',
                  items: [
                     {'name': 'Logo Design', 'detail': 'Vector', 'price': '10.00'}
                  ],
                ),
                _buildSolicitudCard(
                  context,
                  tag: 'Movil',
                  title: 'Comida Casera',
                  description: 'Postre',
                  price: '3.25',
                  status: 'Ver pedido',
                  statusColor: const Color(0xFFFFA600),
                  notificationCount: 1,
                  requesterName: 'Kevin Giron',
                   items: [
                     {'name': 'Web', 'detail': 'React', 'price': '2.50'}, // Matching image content just for demo despite "Comida" title
                     {'name': 'Movil', 'detail': 'Flutter', 'price': '2.50'}
                  ],
                  // Override title/tag to match image if needed, but keeping card data for now
                ),
                _buildSolicitudCard(
                  context,
                  tag: 'Web',
                  title: 'Comida Casera',
                  description: 'Postre',
                  price: '6.50',
                  status: 'Ver pedido',
                  statusColor: const Color(0xFFFFA600),
                  notificationCount: 2,
                  requesterName: 'Ana Smith',
                  items: [
                     {'name': 'Pastel', 'detail': 'Chocolate', 'price': '6.50'}
                  ],
                ),
              ],
            ),
          ),
          
          // Bottom padding to avoid overlap with bottom nav
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildSolicitudCard(
    BuildContext context, {
    required String tag,
    required String title,
    required String description,
    required String price,
    required String status,
    required Color statusColor,
    required int notificationCount,
    required String requesterName,
    required List<Map<String, String>> items,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetalleSolicitudScreen(
              title: title,
              requesterName: requesterName,
              tag: tag,
              items: items,
              paymentMethod: 'fisico', // Default for demo
              description: description,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade400),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          // Image Placeholder (Red Box)
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              height: 80,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF83002A),
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tag and Notification Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFE0B2), // Light yellow/orange
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        tag,
                        style: const TextStyle(
                          color: Color(0xFFFFA600),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (notificationCount > 0)
                      Container(
                        width: 24,
                        height: 24,
                        decoration: const BoxDecoration(
                          color: Color(0xFFFDD835), // Yellow circle
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          notificationCount.toString(),
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
                
                const SizedBox(height: 8),
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        description,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    Text(
                      '\$$price',
                      style: const TextStyle(
                         fontSize: 14,
                         fontWeight: FontWeight.bold,
                         color: Color(0xFF83002A),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 12),
                Center(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: statusColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      status,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          )
        ],
      ),
    )); // Close GestureDetector & Container
  }
}