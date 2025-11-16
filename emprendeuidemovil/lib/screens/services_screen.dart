import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/counter_provider.dart'; // Import del Provider

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> with SingleTickerProviderStateMixin {
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
      appBar: AppBar(
        title: const Text('Mis Servicios'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.purple, Colors.blue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Abriendo formulario para crear servicio')),
              );
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: 'Solicitudes'),
            Tab(text: 'Publicados'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Tab 1: Solicitudes
          _SolicitudesTab(),
          // Tab 2: Publicados
          _PublicadosTab(),
        ],
      ),
    );
  }
}

// Tab para Solicitudes (con Provider en botones)
class _SolicitudesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Datos simulados para solicitudes
    final List<Map<String, dynamic>> _requests = [
      {
        'title': 'Diseño de logo',
        'user': 'Roberto Sánchez',
        'description': 'Necesito un logo moderno para mi cafetería estudiantil. Los colores principales serán café y crema.',
        'date': '2025-11-15',
        'quantity': '1',
        'status': 'Pendiente',
      },
      {
        'title': 'Edición de video',
        'user': 'Laura Mendoza',
        'description': 'Video de presentación para proyecto de clase, duración aproximada de 3 minutos.',
        'date': '2025-11-14',
        'quantity': '1',
        'status': 'Aceptada',
      },
      {
        'title': 'Diseño de logo',
        'user': 'José Paredes',
        'description': 'Logo para equipo de fútbol universitario.',
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
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          request['title'],
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Cambiando estado de ${request['title']}')),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: isPending ? Colors.orange[100] : isAccepted ? Colors.green[100] : Colors.red[100],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                isPending ? Icons.pending : isAccepted ? Icons.check_circle : Icons.cancel,
                                color: isPending ? Colors.orange : isAccepted ? Colors.green : Colors.red,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                request['status'],
                                style: TextStyle(
                                  color: isPending ? Colors.orange : isAccepted ? Colors.green : Colors.red,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    request['user'],
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    request['description'],
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Fecha: ${request['date']} - Cantidad: ${request['quantity']}',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600), // Fix: shade600
                  ),
                  if (isPending) ...[
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Solicitud aceptada'), backgroundColor: Colors.green),
                              );
                              // Decrementa el contador global
                              Provider.of<CounterProvider>(context, listen: false).decrement();
                            },
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                            child: const Text('Aceptar', style: TextStyle(color: Colors.white)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Solicitud rechazada'), backgroundColor: Colors.red),
                              );
                              // Decrementa si rechazas también
                              Provider.of<CounterProvider>(context, listen: false).decrement();
                            },
                            style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
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

// Tab para Publicados
class _PublicadosTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Datos simulados para servicios publicados
    final List<Map<String, dynamic>> _publishedServices = [
      {
        'title': 'Diseño de logos profesionales',
        'price': r'$25',
        'orders': '32 pedidos',
        'icon': Icons.design_services,
        'category': 'Diseño',
      },
      {
        'title': 'Edición de videos',
        'price': r'$20',
        'orders': '15 pedidos',
        'icon': Icons.video_library,
        'category': 'Tecnología',
      },
    ];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.85,
        ),
        itemCount: _publishedServices.length,
        itemBuilder: (context, index) {
          final service = _publishedServices[index];
          return GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Abriendo detalles de ${service['title']}')),
              );
            },
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.purple[50],
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        service['icon'],
                        size: 40,
                        color: Colors.purple,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: Text(
                        service['title'],
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      service['price'],
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      service['orders'],
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}