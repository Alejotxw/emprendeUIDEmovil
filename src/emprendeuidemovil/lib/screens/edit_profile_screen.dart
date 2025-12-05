// lib/screens/edit_profile_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends StatefulWidget {
  final String currentName;
  final String currentPhone;
  final String? currentPhoto; // NUEVO

  const EditProfileScreen({
    super.key,
    required this.currentName,
    required this.currentPhone,
    this.currentPhoto, // NUEVO
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  File? _selectedImage; // FOTO NUEVA

  final Color primary = const Color(0xFF90063a);
  final Color accent = const Color(0xFFdaa520);

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.currentName);
    _phoneController = TextEditingController(text: widget.currentPhone);

    // Cargar foto existente si existe
    if (widget.currentPhoto != null) {
      _selectedImage = File(widget.currentPhoto!);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  // FUNCION PARA ELEGIR IMAGEN
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: primary,
        title: const Text("Editar Perfil", style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: () {
              final Map<String, dynamic> result = {
                'name': _nameController.text.trim(),
                'phone': _phoneController.text.trim(),
                'photo': _selectedImage?.path, // ⬅ AGREGADO
              };
              Navigator.pop(context, result);
            },
            child: const Text(
              "Guardar",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // FOTO DE PERFIL EDITABLE
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 55,
                backgroundColor: primary,
                backgroundImage:
                    _selectedImage != null ? FileImage(_selectedImage!) : null,
                child: _selectedImage == null
                    ? const Icon(Icons.camera_alt, color: Colors.white, size: 40)
                    : null,
              ),
            ),
            const SizedBox(height: 30),

            _buildTextField(
              controller: _nameController,
              label: "Nombre completo",
              icon: Icons.person,
            ),

            const SizedBox(height: 20),

            _buildTextField(
              controller: _phoneController,
              label: "Teléfono",
              icon: Icons.phone,
              keyboardType: TextInputType.phone,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: primary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: accent, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
