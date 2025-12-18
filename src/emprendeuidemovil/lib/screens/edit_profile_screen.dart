<<<<<<< Updated upstream
// lib/screens/edit_profile_screen.dart
import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  final String currentName;
  final String currentPhone;

  const EditProfileScreen({
    super.key,
    required this.currentName,
    required this.currentPhone,
  });
=======
import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});
>>>>>>> Stashed changes

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
<<<<<<< Updated upstream
  late TextEditingController _nameController;
  late TextEditingController _phoneController;

  final Color primary = const Color(0xFF90063a);
  final Color accent = const Color(0xFFdaa520);

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.currentName);
    _phoneController = TextEditingController(text: widget.currentPhone);
  }
=======
  final TextEditingController _nameController = TextEditingController(text: 'Sebastián Chocho');
  final TextEditingController _phoneController = TextEditingController(text: '09931762');
>>>>>>> Stashed changes

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
<<<<<<< Updated upstream
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
              final Map<String, String> result = {
                'name': _nameController.text.trim(),
                'phone': _phoneController.text.trim(),
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
            const CircleAvatar(
              radius: 50,
              backgroundColor: Color(0xFF90063a),
              child: Text(
                "S",
                style: TextStyle(fontSize: 40, color: Colors.white),
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
=======
      appBar: AppBar(
        title: const Text('Mi Perfil'),
        backgroundColor: const Color(0xFFC8102E),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Avatar
            const CircleAvatar(
              radius: 50,
              backgroundColor: Color(0xFFC8102E),
              child: Icon(Icons.person, size: 50, color: Colors.white),
            ),
            const SizedBox(height: 16),
            // Nombre Completo
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nombre Completo',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            // Celular
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Celular',
                border: OutlineInputBorder(),
                prefixText: 'e.j. ',
              ),
              keyboardType: TextInputType.phone,
            ),
            const Spacer(),
            // Botones Cancelar / Guardar Cambios (centrados uno al lado del otro)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Cambios guardados')));
                    Navigator.pop(context);
                  },
                  child: const Text('Guardar Cambios'),
                ),
              ],
            ),
>>>>>>> Stashed changes
          ],
        ),
      ),
    );
  }
<<<<<<< Updated upstream

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
=======
>>>>>>> Stashed changes
}