import 'package:flutter/material.dart';
import 'package:emprendeuidemovil/screens/emprendedor_taek/detalle_solicitud.dart';

class SolicitudesScreen extends StatefulWidget {
  const SolicitudesScreen({super.key});

  @override
  State<SolicitudesScreen> createState() => _SolicitudesScreenState();
}

class _SolicitudesScreenState extends State<SolicitudesScreen> {
  // Lista de solicitudes con estado mutable
  final List<Map<String, dynamic>> _solicitudes = [
    {
      'tag': 'Web',
      'title': 'Diseño Web',
      'description': 'Preparo postres y dulces.',
      'price': '5.00',
      'status': 'Aceptado',
      'statusColor': const Color(0xFF4CAF50),
      'notificationCount': 0,
      'requesterName': 'Juan Perez',
      'items': [
        {'name': 'Landing Page', 'detail': 'HTML/CSS', 'price': '5.00'}
      ],
      'paymentMethod': 'fisico',
    },
    {
      'tag': 'Diseño',
      'title': 'Diseño Grafico',
      'description': 'Publicidad',
      'price': '10.00',
      'status': 'Pendiente',
      'statusColor': Colors.grey,
      'notificationCount': 0,
      'requesterName': 'Maria Lopez',
      'items': [
        {'name': 'Logo Design', 'detail': 'Vector', 'price': '10.00'}
      ],
      'paymentMethod': 'fisico',
    },
    {
      'tag': 'Movil',
      'title': 'Comida Casera',
      'description': 'Postre',
      'price': '3.25',
      'status': 'Ver pedido',
      'statusColor': const Color(0xFFFFA600),
      'notificationCount': 1,
      'requesterName': 'Kevin Giron',
      'items': [
        {'name': 'Web', 'detail': 'React', 'price': '2.50'},
        {'name': 'Movil', 'detail': 'Flutter', 'price': '2.50'}
      ],
      'paymentMethod': 'fisico',
    },
    {
      'tag': 'Web',
      'title': 'Comida Casera',
      'description': 'Postre',
      'price': '6.50',
      'status': 'Ver pedido',
      'statusColor': const Color(0xFFFFA600),
      'notificationCount': 2,
      'requesterName': 'Ana Smith',
      'items': [
        {'name': 'Pastel', 'detail': 'Chocolate', 'price': '6.50'}
      ],
      'paymentMethod': 'fisico',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF121212) : Colors.white,
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
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.70,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
              ),
              itemCount: _solicitudes.length,
              itemBuilder: (context, index) {
                final solicitud = _solicitudes[index];
                return _buildSolicitudCard(
                  context,
                  index: index,
                  tag: solicitud['tag'],
                  title: solicitud['title'],
                  description: solicitud['description'],
                  price: solicitud['price'],
                  status: solicitud['status'],
                  statusColor: solicitud['statusColor'],
                  notificationCount: solicitud['notificationCount'],
                  requesterName: solicitud['requesterName'],
                  items: solicitud['items'],
                  paymentMethod: solicitud['paymentMethod'],
                );
              },
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
    required int index,
    required String tag,
    required String title,
    required String description,
    required String price,
    required String status,
    required Color statusColor,
    required int notificationCount,
    required String requesterName,
    required List<Map<String, String>> items,
    required String paymentMethod,
  }) {
    return GestureDetector(
      onTap: () async {
        // Navegar y esperar el resultado
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetalleSolicitudScreen(
              title: title,
              requesterName: requesterName,
              tag: tag,
              items: items,
              paymentMethod: paymentMethod,
              description: description,
            ),
          ),
        );

        // Si hay resultado, actualizar el estado
        if (result != null && mounted) {
          setState(() {
            _solicitudes[index]['status'] = result;
            if (result == 'Aceptado') {
              _solicitudes[index]['statusColor'] = const Color(0xFF4CAF50); // Verde
            } else if (result == 'Rechazado') {
              _solicitudes[index]['statusColor'] = const Color(0xFFD50000); // Rojo
            }
          });
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Theme.of(context).brightness == Brightness.dark ? Colors.grey[800]! : Colors.grey.shade400),
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
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
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
