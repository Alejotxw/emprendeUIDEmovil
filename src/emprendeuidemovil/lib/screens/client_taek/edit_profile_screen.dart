import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _nameController = TextEditingController(
    text: 'Sebastián Chocho',
  );
  final TextEditingController _phoneController = TextEditingController(
    text: '09931762',
  );

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(t.myProfile),
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
              decoration: InputDecoration(
                labelText: t.nameLabel,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            // Celular
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: t.phoneLabel,
                border: const OutlineInputBorder(),
                prefixText: 'e.j. ',
              ),
              keyboardType: TextInputType.phone,
            ),
            const Spacer(),
            // Botones Cancelar / Guardar Cambios
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 12,
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: Text(t.cancel),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 12,
                    ),
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(t.save)));
                    Navigator.pop(context);
                  },
                  child: Text(t.save),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}