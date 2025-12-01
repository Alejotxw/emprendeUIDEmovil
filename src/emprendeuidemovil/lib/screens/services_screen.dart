import 'package:flutter/material.dart';
import 'emprendimiento_form.dart';


class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        title: const Text(
          'Mis Servicios',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF90063a),
        elevation: 0,

        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CrearEmprendimientoScreen(),
                ),
              );
            },
          ),
        ],


        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: const Color(0xFFdaa520),
          tabs: const [
            Tab(text: 'Solicitudes'),
            Tab(text: 'Publicados'),
          ],
        ),
      ),

      body: TabBarView(
        controller: _tabController,
        children: [
          _SolicitudesTab(),
          _PublicadosTab(),
        ],
      ),
    );
  }
}

// ---------------- TAB SOLICITUDES ----------------

class _SolicitudesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> _requests = [
      {
        'title': 'Diseño de logo',
        'user': 'Roberto Sánchez',
        'description':
            'Necesito un logo moderno para mi cafetería estudiantil.',
        'date': '2025-11-15',
        'quantity': '1',
        'status': 'Pendiente',
      },
      {
        'title': 'Edición de video',
        'user': 'Laura Mendoza',
        'description': 'Video de presentación para un proyecto.',
        'date': '2025-11-14',
        'quantity': '1',
        'status': 'Aceptada',
      },
      {
        'title': 'Diseño de logo',
        'user': 'José Paredes',
        'description': 'Logo para equipo universitario.',
        'date': '2025-11-10',
        'quantity': '1',
        'status': 'Rechazada',
      },
    ];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.builder(
        itemCount: _requests.length,
        itemBuilder: (context, index) {
          final request = _requests[index];
          final isPending = request['status'] == 'Pendiente';
          final isAccepted = request['status'] == 'Aceptada';
          final isRejected = request['status'] == 'Rechazada';

          return Card(
            color: Colors.white,
            margin: const EdgeInsets.only(bottom: 16),
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título y chip de estado
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          request['title'],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF90063a),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: isPending
                              ? Colors.orange[100]
                              : isAccepted
                                  ? Colors.green[100]
                                  : Colors.red[100],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          request['status'],
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: isPending
                                ? Colors.orange
                                : isAccepted
                                    ? Colors.green
                                    : Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),
                  Text(
                    request['user'],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 8),
                  Text(
                    request['description'],
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),

                  const SizedBox(height: 12),
                  Text(
                    'Fecha: ${request['date']} - Cantidad: ${request['quantity']}',
                  ),

                  if (isPending) ...[
                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFdaa520),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: const Text('Aceptar'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(
                                  color: Color(0xFF90063a), width: 2),
                              foregroundColor: const Color(0xFF90063a),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: const Text('Rechazar'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// ---------------- TAB PUBLICADOS ----------------

class _PublicadosTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> _publishedServices = [
      {
        'title': 'Diseño de logos profesionales',
        'price': '\$25',
        'orders': '32 pedidos',
        'icon': Icons.design_services,
      },
      {
        'title': 'Edición de videos',
        'price': '\$20',
        'orders': '15 pedidos',
        'icon': Icons.video_library,
      },
    ];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        itemCount: _publishedServices.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.85,
        ),
        itemBuilder: (context, index) {
          final service = _publishedServices[index];
          return Card(
            color: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF90063a).withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      service['icon'],
                      size: 40,
                      color: const Color(0xFF90063a),
                    ),
                  ),

                  const SizedBox(height: 12),

                  Expanded(
                    child: Text(
                      service['title'],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF90063a),
                      ),
                    ),
                  ),

                  Text(
                    service['price'],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFdaa520),
                    ),
                  ),

                  const SizedBox(height: 4),
                  Text(
                    service['orders'],
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
