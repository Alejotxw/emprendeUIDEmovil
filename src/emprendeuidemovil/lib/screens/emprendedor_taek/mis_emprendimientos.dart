import 'package:flutter/material.dart';
import 'package:emprendeuidemovil/screens/emprendedor_taek/form_emprendimiento.dart';

class MisEmprendimientosScreen extends StatefulWidget {
  const MisEmprendimientosScreen({super.key});

  @override
  State<MisEmprendimientosScreen> createState() => _MisEmprendimientosScreenState();
}

class _MisEmprendimientosScreenState extends State<MisEmprendimientosScreen> {
  final List<Map<String, dynamic>> _emprendimientos = [
    {
      'title': 'Kevin Giron',
      'subtitle': 'Diseño web y Posters',
      'category': 'Diseño',
      'isDraft': false,
    },
    {
      'title': 'Kevin Giron',
      'subtitle': 'Diseño web y Posters',
      'category': 'Diseño',
      'isDraft': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Top Bar
          Container(
            padding: const EdgeInsets.only(top: 50, bottom: 20, left: 24, right: 24),
            decoration: const BoxDecoration(
              color: Color(0xFF83002A),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Emprendimientos',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const FormEmprendimientoScreen()),
                    );

                    if (result != null && result is Map<String, dynamic>) {
                      if (result['action'] == 'create') {
                         setState(() {
                           _emprendimientos.add(result['data']);
                         });
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFA600),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                  ),
                  child: const Text(
                    'Crear',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // List of Emprendimientos
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _emprendimientos.length,
              itemBuilder: (context, index) {
                final item = _emprendimientos[index];
                return Column(
                  children: [
                    _buildEmprendimientoCard(
                      title: item['title'],
                      subtitle: item['subtitle'],
                      category: item['category'],
                      isDraft: item['isDraft'],
                      onPressed: () async {
                         final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FormEmprendimientoScreen(entrepreneurship: item),
                            ),
                          );

                          if (result != null && result is Map<String, dynamic>) {
                            setState(() {
                               if (result['action'] == 'update') {
                                  _emprendimientos[index] = result['data'];
                               } else if (result['action'] == 'delete') {
                                  _emprendimientos.removeAt(index);
                               }
                            });
                          }
                      },
                    ),
                    const SizedBox(height: 16),
                    if (index == _emprendimientos.length - 1)
                       const SizedBox(height: 80), // Padding for bottom nav
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmprendimientoCard({
    required String title,
    required String subtitle,
    required String category,
    required bool isDraft,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade400),
      ),
      child: Column(
        children: [
          // Image / Color Block
          Container(
            height: 120,
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF83002A), // Placeholder color from image
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          
          // Category Pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFFFECCF), // Light orange
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              category,
              style: const TextStyle(
                color: Color(0xFFFFA600),
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          
          const SizedBox(height: 8),

          // Title
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),

          // Subtitle
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),

          const SizedBox(height: 16),

          // Action Button
          Padding(
            padding: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDraft ? Colors.grey : const Color(0xFFFFA600),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: Text(
                  isDraft ? 'Borrador' : 'Editar Emprendimiento',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}