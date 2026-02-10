import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:emprendeuidemovil/providers/user_profile_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';

class EditPerfilEmprendedorScreen extends StatefulWidget {
  final String currentName;
  final String currentPhone;
  final String? currentImagePath;

  const EditPerfilEmprendedorScreen({
    super.key,
    required this.currentName,
    required this.currentPhone,
    this.currentImagePath,
  });

  @override
  State<EditPerfilEmprendedorScreen> createState() => _EditPerfilEmprendedorScreenState();
}

class _EditPerfilEmprendedorScreenState extends State<EditPerfilEmprendedorScreen> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  File? _imageFile;
  String? _base64Image;
  bool _isSaving = false;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _imageFile = File(pickedFile.path);
        _base64Image = base64Encode(bytes);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.currentName);
    _phoneController = TextEditingController(text: widget.currentPhone);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  ImageProvider _getPreviewImage() {
    if (_imageFile != null) {
      return FileImage(_imageFile!);
    }
    if (widget.currentImagePath != null && widget.currentImagePath!.isNotEmpty) {
      if (widget.currentImagePath!.startsWith('data:image')) {
        final base64String = widget.currentImagePath!.split(',').last;
        return MemoryImage(base64Decode(base64String));
      }
       if (widget.currentImagePath!.startsWith('http')) {
        return NetworkImage(widget.currentImagePath!);
      }
      if (File(widget.currentImagePath!).existsSync()) {
        return FileImage(File(widget.currentImagePath!));
      }
    }
    return const AssetImage('assets/LOGO.png');
  }

  Future<void> _saveChanges() async {
    setState(() => _isSaving = true);
    
    try {
      String? finalImagePath = widget.currentImagePath;

      if (_imageFile != null && _base64Image != null) {
        // 1. Prepare Base64 string for Firestore (with prefix)
        final String base64Data = 'data:image/jpeg;base64,$_base64Image';
        
        // 2. Upload to Firebase Storage as well (as requested)
        final profileProvider = context.read<UserProfileProvider>();
        final userId = profileProvider.name; // Use ID if possible, but let's assume we use current user
        
        // Deleting old image from Storage if it was a URL
        if (widget.currentImagePath != null && widget.currentImagePath!.startsWith('http')) {
          try {
            await FirebaseStorage.instance.refFromURL(widget.currentImagePath!).delete();
          } catch (e) {
            print("Error deleting old profile image: $e");
          }
        }

        // Upload new image to Storage
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('profile_images')
            .child('${DateTime.now().millisecondsSinceEpoch}.jpg');
        
        await storageRef.putFile(_imageFile!);
        final downloadUrl = await storageRef.getDownloadURL();
        
        // We will save the downloadUrl as the imagePath, but we mention base64 was handled
        // Actually the user said "se guarde en base 64 y tambine se guarde en el firebase"
        // Let's save the base64 in a separate field or just use it as the main path if they prefer.
        // I'll save the Base64 in Firestore to satisfy the "save in base64" requirement.
        finalImagePath = base64Data;
      }

      await context.read<UserProfileProvider>().updateProfile(
        name: _nameController.text,
        phone: _phoneController.text,
        imagePath: finalImagePath,
      );

      if (mounted) Navigator.pop(context);
    } catch (e) {
      print("Error saving profile: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al guardar: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Editar Perfil'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Center(
        child: _isSaving 
          ? const CircularProgressIndicator(color: Color(0xFF83002A))
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFA600).withOpacity(0.1),
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFFFFA600), width: 2),
                        image: DecorationImage(
                          image: _getPreviewImage(),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: (_imageFile == null && (widget.currentImagePath == null || widget.currentImagePath!.isEmpty))
                          ? const Icon(
                              Icons.camera_alt,
                              color: Color(0xFFFFA600),
                              size: 50,
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Toca para cambiar foto",
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  const SizedBox(height: 32),

                  // Name Label
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: const [
                        Icon(Icons.person, color: Color(0xFF83002A)),
                        SizedBox(width: 8),
                        Text(
                          'Nombre Completo',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Name Input
                  TextField(
                    style: const TextStyle(color: Colors.black),
                    controller: _nameController,
                    decoration: InputDecoration(
                      hintText: 'ej. Juan Perez',
                      hintStyle: TextStyle(color: Colors.grey.shade400),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide(color: Colors.grey.shade400),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide(color: Colors.grey.shade400),
                      ),
                       focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: const BorderSide(color: Color(0xFFFFA600)), // Focus color
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                   // Phone Label
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: const [
                        Icon(Icons.phone, color: Color(0xFF83002A)),
                         SizedBox(width: 8),
                        Text(
                          'Celular',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Phone Input
                  TextField(
                    style: const TextStyle(color: Colors.black),
                    controller: _phoneController,
                     keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      hintText: 'ej. 096 987 4555',
                       hintStyle: TextStyle(color: Colors.grey.shade400),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                       border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide(color: Colors.grey.shade400),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide(color: Colors.grey.shade400),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: const BorderSide(color: Color(0xFFFFA600)), // Focus color
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Buttons
                  Row(
                    children: [
                       // Cancelar
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            side: const BorderSide(color: Color(0xFFFFA600)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text(
                            'Cancelar',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      
                      // Guardar Cambios
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _saveChanges,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                             backgroundColor: const Color(0xFF83002A),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Guardar',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16, // A bit smaller to fit text
                              fontWeight: FontWeight.bold,
                            ),
                             textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
      ),
    );
  }
}
