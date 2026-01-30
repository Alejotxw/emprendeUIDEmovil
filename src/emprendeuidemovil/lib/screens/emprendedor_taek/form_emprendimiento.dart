import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FormEmprendimientoScreen extends StatefulWidget {
  final Map<String, dynamic>? entrepreneurship;

  const FormEmprendimientoScreen({super.key, this.entrepreneurship});

  @override
  State<FormEmprendimientoScreen> createState() =>
      _FormEmprendimientoScreenState();
}

class _FormEmprendimientoScreenState extends State<FormEmprendimientoScreen> {
  // Controllers
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;

  // Service Controllers
  final TextEditingController _serviceNameController = TextEditingController();
  final TextEditingController _serviceDescController = TextEditingController();
  final TextEditingController _servicePriceController = TextEditingController();

  // State
  String _selectedCategory = 'Comida';
  List<Map<String, String>> _services = [];

  // Schedule State
  final List<String> _days = ['Lun', 'Mar', 'Mie', 'Jue', 'Vie', 'Sab', 'Dom'];
  final Set<String> _selectedDays = {'Lun', 'Mar', 'Mie', 'Jue', 'Vie'};
  TimeOfDay _openTime = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _closeTime = const TimeOfDay(hour: 18, minute: 0);

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.entrepreneurship?['title'] ?? '',
    );
    _descriptionController = TextEditingController(
      text: widget.entrepreneurship?['subtitle'] ?? '',
    );
    _selectedCategory = widget.entrepreneurship?['category'] ?? 'Comida';

    // Initialize services if present (you'd need to parse them if they were passed,
    // but for now, we'll just start with the default or empty if not provided logic
    // or keep the dummy data if creating new)
    if (widget.entrepreneurship != null) {
      // In a real app we would parse services from the passed object
      // For this demo, we'll just keep the list empty or minimal to avoid complex parsing errors
      // unless we change the data structure in MisEmprendimientosScreen
      _services = [
        {
          'name': 'Ejemplo Servicio',
          'description': 'Descripción ejemplo',
          'price': '10.00',
        },
      ];
    } else {
      _services = [
        {'name': 'Postres', 'description': 'Sabrosos', 'price': '5.00'},
        {'name': 'Sopas', 'description': 'Almuerzos', 'price': '3.00'},
      ];
    }
  }

  Future<void> _selectTime(BuildContext context, bool isOpenTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isOpenTime ? _openTime : _closeTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF83002A),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (isOpenTime) {
          _openTime = picked;
        } else {
          _closeTime = picked;
        }
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
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Information Header
                  const Text(
                    "Información Basica",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  // Name Input
                  const Text(
                    "Nombre del emprendimiento",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      hintText: 'Ej. Delicias Caseras',
                      hintStyle: TextStyle(color: Colors.grey.shade400),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Categories
                  const Text(
                    "Categoria",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildCategoryItem("Comida", Icons.restaurant),
                      _buildCategoryItem("Tecnologia", Icons.computer),
                      _buildCategoryItem("Diseño", Icons.brush),
                      _buildCategoryItem("Artesanias", Icons.cut),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Description
                  const Text(
                    "Descripción",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _descriptionController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: 'Describe tu emprendimiento',
                      hintStyle: TextStyle(color: Colors.grey.shade400),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Location (Placeholder)
                  const Text(
                    "Ubicación",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 150,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.grey.shade200,
                      image: const DecorationImage(
                        image: NetworkImage(
                          "https://upload.wikimedia.org/wikipedia/commons/thumb/b/bd/Google_Maps_Logo_2020.svg/2275px-Google_Maps_Logo_2020.svg.png",
                        ), // Placeholder or nice map image assets
                        fit: BoxFit.cover,
                        opacity: 0.6,
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.location_on,
                        color: const Color(0xFF83002A),
                        size: 40,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Schedule
                  const Text(
                    "Horario de Atención",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  _buildSchedulePicker(),
                  const SizedBox(height: 20),

                  // Services Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Servicios / Productos",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFA600),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text(
                          "${_services.length} Servicios",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Services List
                  ..._services.asMap().entries.map((entry) {
                    return _buildServiceCard(entry.key + 1, entry.value);
                  }).toList(),

                  const SizedBox(height: 20),

                  // Add New Service Form
                  _buildAddServiceForm(),

                  const SizedBox(height: 40),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            side: const BorderSide(color: Color(0xFF83002A)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text(
                            "Guardar Borrador",
                            style: TextStyle(
                              color: Color(0xFF83002A),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_nameController.text.trim().isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Ingresa el nombre del emprendimiento",
                                  ),
                                ),
                              );
                              return;
                            }

                            try {
                              await FirebaseFirestore.instance
                                  .collection('products')
                                  .add({
                                    'title': _nameController.text.trim(),
                                    'description': _descriptionController.text
                                        .trim(),
                                    'category': _selectedCategory,
                                    'services': _services,
                                    'schedule': {
                                      'days': _selectedDays.toList(),
                                      'open': _openTime.format(context),
                                      'close': _closeTime.format(context),
                                    },
                                    'createdAt': FieldValue.serverTimestamp(),
                                    'updatedAt': FieldValue.serverTimestamp(),
                                    'isActive': true,
                                  });

                              if (!mounted) return;

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Emprendimiento creado correctamente",
                                  ),
                                ),
                              );

                              Navigator.pop(context);
                            } catch (e) {
                              if (!mounted) return;

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Error al guardar: $e")),
                              );
                            }
                          },

                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: const Color(0xFF83002A),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Text(
                            widget.entrepreneurship != null
                                ? "Guardar Cambios"
                                : "Crear Emprendimiento",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (widget.entrepreneurship != null) ...[
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        onPressed: () {
                          // Confirm delete
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text("Eliminar Emprendimiento"),
                              content: const Text(
                                "¿Estás seguro de que quieres eliminar este emprendimiento?",
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text("Cancelar"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context); // Close dialog
                                    Navigator.pop(context, {
                                      'action': 'delete',
                                    }); // Return delete action
                                  },
                                  child: const Text(
                                    "Eliminar",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        child: const Text(
                          "Eliminar Emprendimiento",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),
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
      width: double.infinity,
      padding: const EdgeInsets.only(top: 50, bottom: 20, left: 16, right: 16),
      decoration: const BoxDecoration(
        color: Color(0xFF83002A),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 8),
          const Expanded(
            child: Text(
              'Crear Emprendimiento',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(String name, IconData icon) {
    bool isSelected = _selectedCategory == name;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategory = name;
        });
      },
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? Colors.grey.shade100 : Colors.white,
              border: Border.all(
                color: isSelected ? const Color(0xFF83002A) : Colors.black,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Icon(
              icon,
              color: isSelected ? const Color(0xFF83002A) : Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSchedulePicker() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Días:",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: _days.map((day) {
              final isSelected = _selectedDays.contains(day);
              return ChoiceChip(
                label: Text(day),
                selected: isSelected,
                selectedColor: const Color(0xFF83002A),
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedDays.add(day);
                    } else {
                      _selectedDays.remove(day);
                    }
                  });
                },
              );
            }).toList(),
          ),
          const Divider(height: 24),
          const Text(
            "Horas:",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildTimeSelector("Apertura", _openTime, true),
              const Icon(Icons.arrow_forward, color: Colors.grey),
              _buildTimeSelector("Cierre", _closeTime, false),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSelector(String label, TimeOfDay time, bool isOpenTime) {
    return InkWell(
      onTap: () => _selectTime(context, isOpenTime),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 4),
            Text(
              time.format(context),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceCard(int index, Map<String, String> service) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF83002A), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Number Badge
          Container(
            width: 50,
            height: 50,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFF83002A),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              "$index",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      service['name']!,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          _services.removeAt(index - 1);
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.red),
                        ),
                        child: const Icon(
                          Icons.close,
                          color: Colors.red,
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  service['description']!,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFA600),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    "\$${service['price']}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddServiceForm() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF6E5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFFFA600), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Agregar nuevo servicio:",
            style: TextStyle(
              color: Colors.black54,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildFormInput(_serviceNameController, "Nombre del servicio"),
          const SizedBox(height: 12),
          _buildFormInput(_serviceDescController, "Descripción breve"),
          const SizedBox(height: 12),
          _buildFormInput(
            _servicePriceController,
            "Precio (Ej: \$5.00)",
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              onPressed: () {
                if (_serviceNameController.text.isNotEmpty &&
                    _servicePriceController.text.isNotEmpty) {
                  setState(() {
                    _services.add({
                      'name': _serviceNameController.text,
                      'description': _serviceDescController.text,
                      'price': _servicePriceController.text,
                    });
                    _serviceNameController.clear();
                    _serviceDescController.clear();
                    _servicePriceController.clear();
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFA600),
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                "Agregar Servicio",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormInput(
    TextEditingController controller,
    String hint, {
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade500),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
      ),
    );
  }
}
