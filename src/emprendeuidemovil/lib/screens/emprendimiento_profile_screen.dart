import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_assets.dart';
import '../models/contact_method_model.dart';
import '../models/user_model.dart';
import '../providers/ratings_provider.dart';
import '../widgets/contact_methods.dart';
import 'emprendedor_profile_screen.dart';

class EmprendimientoProfileScreen extends StatefulWidget {
  final Map<String, dynamic> emprendimiento;
  final UserModel emprendedor;

  const EmprendimientoProfileScreen({
    super.key,
    required this.emprendimiento,
    required this.emprendedor,
  });

  @override
  State<EmprendimientoProfileScreen> createState() => _EmprendimientoProfileScreenState();
}

class _EmprendimientoProfileScreenState extends State<EmprendimientoProfileScreen> {
  List<ContactMethodModel> _contactMethods = [];
  Map<String, dynamic>? _ratingStats;
  bool _isLoadingStats = true;

  @override
  void initState() {
    super.initState();
    _loadContactMethods();
    _loadRatingStats();
  }

  void _loadContactMethods() {
    // Convertir los métodos de contacto del emprendimiento a objetos ContactMethodModel
    final contactData = widget.emprendimiento['contactMethods'] as List<dynamic>? ?? [];

    setState(() {
      _contactMethods = contactData.map((contact) {
        return ContactMethodModel.fromMap(contact as Map<String, dynamic>);
      }).toList();
    });

    // Si no hay métodos de contacto definidos, crear algunos por defecto basados en la info del emprendedor
    if (_contactMethods.isEmpty) {
      _contactMethods = [
        if (widget.emprendedor.email.isNotEmpty)
          ContactMethodModel(
            id: 'email_${widget.emprendedor.id}',
            type: ContactMethodType.email,
            value: widget.emprendedor.email,
            label: 'Email',
            isPrimary: true,
          ),
      ];
    }
  }

  Future<void> _loadRatingStats() async {
    final ratingsProvider = Provider.of<RatingsProvider>(context, listen: false);
    final stats = await ratingsProvider.getRatingStats(widget.emprendedor.id);
    if (mounted) {
      setState(() {
        _ratingStats = stats;
        _isLoadingStats = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildTopBar(context),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildEmprendimientoHeader(),
                  const SizedBox(height: 24),
                  _buildEmprendimientoDetails(),
                  const SizedBox(height: 24),
                  _buildServicesSection(),
                  const SizedBox(height: 24),
                  _buildScheduleSection(),
                  const SizedBox(height: 24),
                  ContactMethodsCard(contactMethods: _contactMethods),
                  const SizedBox(height: 24),
                  _buildEmprendedorInfo(),
                  const SizedBox(height: 24),
                  _buildRatingSummary(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 50, bottom: 16, left: 24, right: 24),
      decoration: const BoxDecoration(
        color: Color(0xFFFFA600),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          const Expanded(
            child: Text(
              'Perfil del Emprendimiento',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 48), // Balance for back button
        ],
      ),
    );
  }

  Widget _buildEmprendimientoHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.business,
              size: 40,
              color: Colors.grey,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.emprendimiento['title'] ?? 'Sin título',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFA600).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    widget.emprendimiento['category'] ?? 'Sin categoría',
                    style: const TextStyle(
                      color: Color(0xFFFFA600),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.emprendimiento['subtitle'] ?? 'Sin descripción',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmprendimientoDetails() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Detalles del Emprendimiento',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          _buildDetailRow('Categoría', widget.emprendimiento['category'] ?? 'No especificada'),
          _buildDetailRow('Estado', widget.emprendimiento['status'] ?? 'Activo'),
          _buildDetailRow('Fecha de creación', _formatDate(widget.emprendimiento['createdAt'])),
        ],
      ),
    );
  }

  Widget _buildServicesSection() {
    final services = widget.emprendimiento['services'] as List<dynamic>? ?? [];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Servicios Ofrecidos',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          if (services.isEmpty)
            const Text(
              'No hay servicios registrados',
              style: TextStyle(
                color: Colors.grey,
                fontStyle: FontStyle.italic,
              ),
            )
          else
            ...services.map((service) => _buildServiceItem(service)),
        ],
      ),
    );
  }

  Widget _buildServiceItem(dynamic service) {
    final serviceMap = service as Map<String, dynamic>;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  serviceMap['name'] ?? 'Sin nombre',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  serviceMap['description'] ?? 'Sin descripción',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Text(
            '\$${serviceMap['price'] ?? '0.00'}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFFFFA600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleSection() {
    final schedule = widget.emprendimiento['schedule'] as Map<String, dynamic>? ?? {};

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Horario de Atención',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          _buildScheduleInfo(schedule),
        ],
      ),
    );
  }

  Widget _buildScheduleInfo(Map<String, dynamic> schedule) {
    final days = schedule['days'] as List<dynamic>? ?? [];
    final openTime = schedule['openTime'] ?? '09:00';
    final closeTime = schedule['closeTime'] ?? '18:00';

    return Column(
      children: [
        Row(
          children: [
            const Icon(Icons.access_time, color: Color(0xFFFFA600)),
            const SizedBox(width: 8),
            Text(
              '$openTime - $closeTime',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8.0,
          children: days.map<Widget>((day) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFFFA600).withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                day.toString(),
                style: const TextStyle(
                  color: Color(0xFFFFA600),
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildEmprendedorInfo() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Información del Emprendedor',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(25),
                ),
                child: const Icon(
                  Icons.person,
                  size: 25,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.emprendedor.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      widget.emprendedor.email,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {
                  // Navegar al perfil del emprendedor
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EmprendedorProfileScreen(emprendedor: widget.emprendedor),
                    ),
                  );
                },
                child: const Text(
                  'Ver Perfil',
                  style: TextStyle(
                    color: Color(0xFFFFA600),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRatingSummary() {
    if (_isLoadingStats) {
      return const Center(child: CircularProgressIndicator());
    }

    final average = _ratingStats?['average'] ?? 0.0;
    final total = _ratingStats?['total'] ?? 0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Calificaciones del Emprendedor',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Row(
                children: List.generate(5, (index) {
                  return Icon(
                    index < average.round() ? Icons.star : Icons.star_border,
                    size: 20,
                    color: Colors.amber,
                  );
                }),
              ),
              const SizedBox(width: 8),
              Text(
                average.toStringAsFixed(1),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '($total reseñas)',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(dynamic dateData) {
    if (dateData == null) return 'No especificada';

    try {
      if (dateData is DateTime) {
        return '${dateData.day}/${dateData.month}/${dateData.year}';
      } else if (dateData is String) {
        final date = DateTime.parse(dateData);
        return '${date.day}/${date.month}/${date.year}';
      }
    } catch (e) {
      // Handle parsing error
    }

    return 'No especificada';
  }
}