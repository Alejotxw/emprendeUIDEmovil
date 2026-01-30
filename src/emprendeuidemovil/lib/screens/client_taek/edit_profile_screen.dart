import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import '../../providers/user_profile_provider.dart';

class EditProfileScreen extends StatefulWidget {
  final String initialName;
  final String initialPhone;
  final String? initialImage;

  const EditProfileScreen({
    super.key,
    required this.initialName,
    required this.initialPhone,
    this.initialImage,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  String? _imagePath;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
    _phoneController = TextEditingController(text: widget.initialPhone);
    _imagePath = widget.initialImage;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Perfil'),
        backgroundColor: const Color(0xFFC8102E),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Avatar con opción de editar
            GestureDetector(
              onTap: _pickImage,
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: const Color(0xFFC8102E),
                    backgroundImage: _imagePath != null
                        ? FileImage(File(_imagePath!))
                        : null,
                    child: _imagePath == null
                        ? const Icon(Icons.person, size: 60, color: Colors.white)
                        : null,
                  ),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Colors.orange,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.camera_alt,
                        color: Colors.white, size: 20),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // Nombre Completo
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nombre Completo',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 16),
            
            // Celular
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Celular',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.phone),
                prefixText: 'e.j. ',
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 40),
            
            // Botones Cancelar / Guardar Cambios
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  onPressed: () {
                    // Actualizar provider
                    context.read<UserProfileProvider>().updateProfile(
                          name: _nameController.text,
                          phone: _phoneController.text,
                          imagePath: _imagePath,
                        );
                    
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Cambios guardados')));
                    Navigator.pop(context);
                  },
                  child: const Text('Guardar Cambios'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}