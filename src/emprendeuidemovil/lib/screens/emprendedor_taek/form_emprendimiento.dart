import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FormEmprendimientoScreen extends StatefulWidget {
  final Map<String, dynamic>? entrepreneurship;

  const FormEmprendimientoScreen({super.key, this.entrepreneurship});

  @override
  State<FormEmprendimientoScreen> createState() => _FormEmprendimientoScreenState();
}

class _FormEmprendimientoScreenState extends State<FormEmprendimientoScreen> {
  // Controllers
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  
  // Service Controllers
  final TextEditingController _serviceNameController = TextEditingController();
  final TextEditingController _serviceDescController = TextEditingController();
  final TextEditingController _servicePriceController = TextEditingController();
  final TextEditingController _serviceStockController = TextEditingController();

  // Bank Data Controllers
  final TextEditingController _bankNameController = TextEditingController();
  final TextEditingController _accountNumberController = TextEditingController();
  final TextEditingController _holderNameController = TextEditingController();
  final TextEditingController _cedulaController = TextEditingController();
  String _accountType = 'Ahorros'; // 'Ahorros' | 'Corriente'

  // State
  String _selectedCategory = 'Comida';
  List<Map<String, String>> _services = [];
  String _newItemType = 'service'; // 'service' | 'product'
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  // Schedule State
  final List<String> _days = ['Lun', 'Mar', 'Mie', 'Jue', 'Vie', 'Sab', 'Dom'];
  final Set<String> _selectedDays = {'Lun', 'Mar', 'Mie', 'Jue', 'Vie'};
  TimeOfDay _openTime = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _closeTime = const TimeOfDay(hour: 18, minute: 0);

  bool _isUploading = false;
  String? _imageUrl;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.entrepreneurship?['title'] ?? '');
    _descriptionController = TextEditingController(text: widget.entrepreneurship?['subtitle'] ?? '');
    _selectedCategory = widget.entrepreneurship?['category'] ?? 'Comida';
    
    final initialPath = widget.entrepreneurship?['imagePath'];
    if (initialPath != null && initialPath.isNotEmpty) {
      if (initialPath.startsWith('http') || initialPath.length > 200) {
        _imageUrl = initialPath;
      } else {
        _selectedImage = File(initialPath);
      }
    }
    
    if (widget.entrepreneurship != null && widget.entrepreneurship!['services'] != null) {
       _services = List<Map<String, String>>.from(widget.entrepreneurship!['services'].map((item) {
         // Ensure type cast is correct and map keys match
         return Map<String, String>.from(item);
       }));
    } else {
       _services = [];
    }

    // Initialize Bank Data
    if (widget.entrepreneurship != null && widget.entrepreneurship!['transferData'] != null) {
      final transfer = widget.entrepreneurship!['transferData'];
      _bankNameController.text = transfer['bankName'] ?? '';
      _accountNumberController.text = transfer['accountNumber'] ?? '';
      _holderNameController.text = transfer['holderName'] ?? '';
      _cedulaController.text = transfer['cedula'] ?? '';
      _accountType = transfer['accountType'] ?? 'Ahorros';
    }

    // Initialize Schedule
    if (widget.entrepreneurship != null) {
      if (widget.entrepreneurship!['scheduleDays'] != null) {
        _selectedDays.clear();
        _selectedDays.addAll(List<String>.from(widget.entrepreneurship!['scheduleDays']));
      }
      
      if (widget.entrepreneurship!['openTime'] != null) {
        _openTime = _parseTime(widget.entrepreneurship!['openTime']);
      }
      if (widget.entrepreneurship!['closeTime'] != null) {
        _closeTime = _parseTime(widget.entrepreneurship!['closeTime']);
      }
    }
  }

  ImageProvider _getImageProvider(String path) {
    if (path.startsWith('http')) {
      return NetworkImage(path);
    } else if (path.length > 200) {
       try {
         return MemoryImage(base64Decode(path));
       } catch (e) {
         print("Error decoding base64 image: $e");
         return const AssetImage('assets/LOGO.png');
       }
    } else {
      return FileImage(File(path));
    }
  }

  TimeOfDay _parseTime(String timeString) {
    try {
      final parts = timeString.split(':');
      if (parts.length == 2) {
        return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
      }
    } catch (e) {
      print("Error parsing time $timeString: $e");
    }
    return const TimeOfDay(hour: 9, minute: 0);
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

  Future<void> _saveAndExit({bool isDraft = false}) async {
    if (_isUploading) return;

    setState(() {
      _isUploading = true;
    });

    String? finalImagePath = _imageUrl;

    try {
      if (_selectedImage != null) {
         print("Convirtiendo imagen a Base64...");
         List<int> imageBytes = await _selectedImage!.readAsBytes();
         // Add a prefix if you want, but standard base64 string is fine too.
         // Usually for display in Flutter MemoryImage(base64Decode(string)) works with clean base64.
         // However, keeping consistent with web data URI format might be useful, or just raw base64.
         // Let's store just the raw base64 string, but check if we need to resize it.
         // Storing full resolution images in Firestore as Base64 is BAD for performance and cost.
         // But the user insisted.
         
         finalImagePath = base64Encode(imageBytes);
         print("Imagen convertida a Base64 (longitud: ${finalImagePath.length})");
      }
    } catch (e) {
      print("Error convirtiendo imagen: $e");
      if (mounted) {
         ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(content: Text('Error procesando la imagen: $e')),
         );
      }
    }


    final data = {
      'title': _nameController.text.isNotEmpty ? _nameController.text : 'Borrador',
      'subtitle': _descriptionController.text,
      'category': _selectedCategory,
      'services': _services,
      'location': 'Loja Ecuador (Campus UIDE)',
      'isDraft': isDraft,
      'imagePath': finalImagePath,
      'transferData': {
        'bankName': _bankNameController.text,
        'accountNumber': _accountNumberController.text,
        'accountType': _accountType,
        'holderName': _holderNameController.text,
        'cedula': _cedulaController.text,
      },
      'scheduleDays': _selectedDays.toList(),
      // Save as HH:mm 24h format
      'openTime': '${_openTime.hour}:${_openTime.minute.toString().padLeft(2, '0')}',
      'closeTime': '${_closeTime.hour}:${_closeTime.minute.toString().padLeft(2, '0')}',
    };

    if (!isDraft && _nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Ingresa el nombre del emprendimiento")));
      return;
    }

    Navigator.pop(context, {
      'action': widget.entrepreneurship != null ? 'update' : 'create',
      'data': data,
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _saveAndExit(isDraft: true);
        return false;
      },
      child: Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF121212) : Colors.white,
      body: _isUploading 
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF83002A)))
          : Column(
        children: [
          _buildTopBar(context),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   // Information Header
                   Text(
                     "Información Basica",
                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black),
                   ),
                   const SizedBox(height: 16),

                   // Image Picker
                   GestureDetector(
                     onTap: _pickImage,
                     child: Container(
                       height: 180,
                       width: double.infinity,
                       decoration: BoxDecoration(
                         color: _selectedImage == null 
                             ? (Theme.of(context).brightness == Brightness.dark ? const Color(0xFF1E1E1E) : Colors.grey.shade100)
                             : null,
                         borderRadius: BorderRadius.circular(20),
                         border: Border.all(color: Colors.grey.shade300),
                         image: _selectedImage != null
                             ? DecorationImage(
                                 image: FileImage(_selectedImage!),
                                 fit: BoxFit.cover,
                               )
                             : (_imageUrl != null 
                                 ? DecorationImage(
                                     image: _getImageProvider(_imageUrl!),
                                     fit: BoxFit.cover,
                                   )
                                 : null),
                       ),
                       child: (_selectedImage == null && _imageUrl == null)
                           ? Column(
                               mainAxisAlignment: MainAxisAlignment.center,
                               children: [
                                 Icon(Icons.add_a_photo, 
                                   size: 50, 
                                   color: Theme.of(context).brightness == Brightness.dark ? Colors.grey : Colors.grey.shade400
                                 ),
                                 const SizedBox(height: 10),
                                 Text(
                                   "Agregar Imagen del Emprendimiento",
                                   style: TextStyle(
                                     color: Theme.of(context).brightness == Brightness.dark ? Colors.grey : Colors.grey.shade500
                                   ),
                                 ),
                               ],
                             )
                           : Stack(
                               children: [
                                 Positioned(
                                   right: 10,
                                   top: 10,
                                   child: Container(
                                     padding: const EdgeInsets.all(4),
                                     decoration: const BoxDecoration(
                                       color: Colors.black54,
                                       shape: BoxShape.circle,
                                     ),
                                     child: const Icon(Icons.edit, color: Colors.white, size: 20),
                                   ),
                                 ),
                               ],
                             ),
                     ),
                   ),
                   const SizedBox(height: 20),

                   // Name Input
                   const Text("Nombre del emprendimiento", style: TextStyle(fontWeight: FontWeight.bold)),
                   const SizedBox(height: 8),
                   TextField(
                     controller: _nameController,
                     style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black),
                     decoration: InputDecoration(
                       filled: true,
                       fillColor: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF1E1E1E) : Colors.white,
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
                   const Text("Categoria", style: TextStyle(fontWeight: FontWeight.bold)),
                   const SizedBox(height: 12),
                    // First row - 5 categories
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildCategoryItem("Bienestar", Icons.spa),
                        _buildCategoryItem("Eventos", Icons.event),
                        _buildCategoryItem("Mascotas", Icons.pets),
                        _buildCategoryItem("Tecnología", Icons.computer),
                        _buildCategoryItem("Gastronomía", Icons.restaurant),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Second row - 4 categories
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildCategoryItem("Moda", Icons.checkroom),
                        _buildCategoryItem("Diseño", Icons.brush),
                        _buildCategoryItem("Educación", Icons.school),
                        _buildCategoryItem("Movilidad", Icons.directions_car),
                      ],
                    ),
                   const SizedBox(height: 20),

                   // Description
                   const Text("Descripción", style: TextStyle(fontWeight: FontWeight.bold)),
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
                   const Text("Ubicación", style: TextStyle(fontWeight: FontWeight.bold)),
                   const SizedBox(height: 8),
                   Container(
                     width: double.infinity,
                     padding: const EdgeInsets.all(16),
                     decoration: BoxDecoration(
                       color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF1E1E1E) : Colors.grey.shade100,
                       borderRadius: BorderRadius.circular(15),
                       border: Border.all(color: Colors.grey.shade300),
                     ),
                     child: Row(
                       children: [
                         const Icon(Icons.location_on, color: Color(0xFF83002A), size: 30),
                         const SizedBox(width: 12),
                         Expanded(
                           child: Text(
                             "Loja Ecuador (Campus UIDE)",
                             style: TextStyle(
                                 fontSize: 14,
                                 fontWeight: FontWeight.bold,
                                 color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black87),
                           ),
                         ),
                       ],
                     ),
                   ),
                   const SizedBox(height: 20),

                   // Schedule
                   const Text("Horario de Atención", style: TextStyle(fontWeight: FontWeight.bold)),
                   const SizedBox(height: 8),
                   _buildSchedulePicker(),
                   const SizedBox(height: 20),

                   // Services Header
                   Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                       const Text("Servicios / Productos", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                       Container(
                         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                         decoration: BoxDecoration(
                           color: const Color(0xFFFFA600),
                           borderRadius: BorderRadius.circular(15),
                         ),
                         child: Text(
                           "${_services.length} Servicios",
                           style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                         ),
                       )
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

                   const SizedBox(height: 30),
                   const Divider(),
                   const SizedBox(height: 10),
                   const Text(
                     "Datos Bancarios para Transferencias",
                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF83002A)),
                   ),
                   const SizedBox(height: 16),
                   _buildBankForm(),

                   const SizedBox(height: 40),

                   // Action Buttons
                   Row(
                     children: [
                       Expanded(
                          child: OutlinedButton(
                            onPressed: () => _saveAndExit(isDraft: true),
                           style: OutlinedButton.styleFrom(
                             padding: const EdgeInsets.symmetric(vertical: 16),
                             side: const BorderSide(color: Color(0xFF83002A)),
                             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                           ),
                           child: const Text("Guardar Borrador", style: TextStyle(color: Color(0xFF83002A), fontWeight: FontWeight.bold)),
                         ),
                       ),
                       const SizedBox(width: 12),
                       Expanded(
                          child: ElevatedButton(
                            onPressed: () => _saveAndExit(isDraft: false),
                           style: ElevatedButton.styleFrom(
                             padding: const EdgeInsets.symmetric(vertical: 16),
                             backgroundColor: const Color(0xFF83002A),
                             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                           ),
                           child: Text(
                             widget.entrepreneurship != null ? "Guardar Cambios" : "Crear Emprendimiento", 
                             style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)
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
                                 content: const Text("¿Estás seguro de que quieres eliminar este emprendimiento?"),
                                 actions: [
                                   TextButton(
                                     onPressed: () => Navigator.pop(context), 
                                     child: const Text("Cancelar")
                                   ),
                                   TextButton(
                                     onPressed: () {
                                       Navigator.pop(context); // Close dialog
                                       Navigator.pop(context, {'action': 'delete'}); // Return delete action
                                     }, 
                                     child: const Text("Eliminar", style: TextStyle(color: Colors.red))
                                   ),
                                 ],
                               )
                             );
                          },
                          child: const Text("Eliminar Emprendimiento", style: TextStyle(color: Colors.red)),
                        ),
                      )
                   ],
                   const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
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
            onPressed: () => _saveAndExit(isDraft: true),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
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
              color: isSelected ? (isDark ? Colors.grey.shade800 : Colors.grey.shade100) : (isDark ? const Color(0xFF1E1E1E) : Colors.white),
              border: Border.all(
                color: isSelected ? const Color(0xFF83002A) : (isDark ? Colors.grey : Colors.black),
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Icon(
              icon,
              color: isSelected ? const Color(0xFF83002A) : (isDark ? Colors.white : Colors.black),
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
          const Text("Días:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: _days.map((day) {
              final isSelected = _selectedDays.contains(day);
              return ChoiceChip(
                label: Text(day),
                selected: isSelected,
                selectedColor: const Color(0xFF83002A),
                backgroundColor: Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade800 : null,
                labelStyle: TextStyle(
                  color: isSelected 
                      ? Colors.white 
                      : (Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black),
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
          const Text("Horas:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
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
          color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF1E1E1E) : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          children: [
            Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
            const SizedBox(height: 4),
            Text(
              time.format(context),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black),
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
        color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF1E1E1E) : Colors.white,
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
              style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
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
                    Expanded(
                      child: Text(
                        service['name']!,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                            color: service['type'] == 'product' ? Colors.blue.shade100 : Colors.green.shade100,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: service['type'] == 'product' ? Colors.blue : Colors.green),
                        ),
                        child: Text(
                            service['type'] == 'product' ? 'Producto' : 'Servicio',
                            style: TextStyle(
                                fontSize: 10, 
                                fontWeight: FontWeight.bold,
                                color: service['type'] == 'product' ? Colors.blue.shade900 : Colors.green.shade900,
                            ),
                        ),
                    ),
                    const SizedBox(width: 8),
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
                        child: const Icon(Icons.close, color: Colors.red, size: 16),
                      ),
                    ),
                  ],
                ),
                Text(service['description']!, style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
                const SizedBox(height: 8),
                Row(
                    children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFA600),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text(
                            "\$${service['price']}",
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                        ),
                        if (service['stock'] != null && service['stock']!.isNotEmpty) ...[
                            const SizedBox(width: 12),
                            Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                decoration: BoxDecoration(
                                    color: Colors.grey.shade300,
                                    borderRadius: BorderRadius.circular(15),
                                ),
                                child: Text(
                                    "Stock: ${service['stock']}",
                                    style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12),
                                ),
                            ),
                        ]
                    ],
                )
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
          const Text("Agregar nuevo item:", style: TextStyle(color: Colors.black54, fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          // Type Selector
          Row(
            children: [
                Expanded(
                    child: GestureDetector(
                        onTap: () => setState(() => _newItemType = 'service'),
                        child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                                color: _newItemType == 'service' ? const Color(0xFFFFA600) : Colors.white,
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(color: const Color(0xFFFFA600))
                            ),
                            alignment: Alignment.center,
                            child: Text(
                                "Servicio",
                                style: TextStyle(
                                    fontWeight: _newItemType == 'service' ? FontWeight.bold : FontWeight.normal,
                                    color: _newItemType == 'service' ? Colors.white : const Color(0xFFFFA600)
                                )
                            ),
                        ),
                    ),
                ),
                const SizedBox(width: 12),
                Expanded(
                    child: GestureDetector(
                        onTap: () => setState(() => _newItemType = 'product'),
                        child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                                color: _newItemType == 'product' ? const Color(0xFFFFA600) : Colors.white,
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(color: const Color(0xFFFFA600))
                            ),
                            alignment: Alignment.center,
                            child: Text(
                                "Producto",
                                style: TextStyle(
                                    fontWeight: _newItemType == 'product' ? FontWeight.bold : FontWeight.normal,
                                    color: _newItemType == 'product' ? Colors.white : const Color(0xFFFFA600)
                                )
                            ),
                        ),
                    ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          _buildFormInput(_serviceNameController, "Nombre del ${_newItemType == 'product' ? 'producto' : 'servicio'}"),
          const SizedBox(height: 12),
          _buildFormInput(_serviceDescController, "Descripción breve"),
          const SizedBox(height: 12),
          _buildFormInput(_servicePriceController, "Precio (Ej: \$5.00)", keyboardType: TextInputType.number),
          if (_newItemType == 'product') ...[
              const SizedBox(height: 12),
              _buildFormInput(_serviceStockController, "Cantidad en Stock", keyboardType: TextInputType.number),
          ],
          const SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              onPressed: () {
                 if (_serviceNameController.text.isNotEmpty && _servicePriceController.text.isNotEmpty) {
                   setState(() {
                     _services.add({
                       'name': _serviceNameController.text,
                       'description': _serviceDescController.text,
                       'price': _servicePriceController.text,
                       'stock': _newItemType == 'product' ? _serviceStockController.text : '',
                       'type': _newItemType,
                     });
                     _serviceNameController.clear();
                     _serviceDescController.clear();
                     _servicePriceController.clear();
                     _serviceStockController.clear();
                   });
                 }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFA600),
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              child: const Text("Agregar Item", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildFormInput(TextEditingController controller, String hint, {TextInputType? keyboardType}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black),
      decoration: InputDecoration(
        filled: true,
        fillColor: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF1E1E1E) : Colors.white,
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade500),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50, // Compress image to avoid large base64 strings
      maxWidth: 800, // Limit width to 800px
    );
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
        // Clear old URL if new image is picked
        _imageUrl = null; 
      });
    }
  }

  Widget _buildBankForm() {
    return Column(
      children: [
        _buildTextField(_bankNameController, 'Nombre del Banco', Icons.account_balance),
        const SizedBox(height: 12),
        _buildTextField(_accountNumberController, 'Número de Cuenta', Icons.numbers, keyboardType: TextInputType.number),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: RadioListTile<String>(
                title: const Text('Ahorros'),
                value: 'Ahorros',
                groupValue: _accountType,
                onChanged: (val) => setState(() => _accountType = val!),
                activeColor: const Color(0xFF83002A),
                contentPadding: EdgeInsets.zero,
              ),
            ),
            Expanded(
              child: RadioListTile<String>(
                title: const Text('Corriente'),
                value: 'Corriente',
                groupValue: _accountType,
                onChanged: (val) => setState(() => _accountType = val!),
                activeColor: const Color(0xFF83002A),
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
        _buildTextField(_holderNameController, 'Nombre del Titular', Icons.person),
        const SizedBox(height: 12),
        _buildTextField(_cedulaController, 'Cédula / RUC', Icons.badge),
      ],
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {TextInputType? keyboardType}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFF83002A)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF1E1E1E) : Colors.grey[100],
      ),
    );
  }
}
