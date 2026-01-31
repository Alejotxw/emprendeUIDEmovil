import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../providers/service_provider.dart';
import '../providers/user_role_provider.dart';
// Use named routes to navigate to login to avoid circular imports

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final List<Map<String, String>> _events = [];

  final _formKey = GlobalKey<FormState>();
  String _eventTitle = '';
  DateTime? _eventDateTime;
  String _eventDesc = '';
  String _contactMethods = '';
  XFile? _pickedImage;
  final ImagePicker _picker = ImagePicker();

  void _showCreateEventDialog() {
    _eventTitle = '';
    _eventDateTime = null;
    _eventDesc = '';
    _contactMethods = '';
    _pickedImage = null;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Crear Evento'),
        content: StatefulBuilder(
          builder: (context, setStateDialog) => Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Título'),
                    onSaved: (v) => _eventTitle = v ?? '',
                    validator: (v) => (v == null || v.isEmpty) ? 'Ingrese un título' : null,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Text(_eventDateTime == null ? 'Seleccione fecha y hora' : '${_eventDateTime!.toLocal()}'),
                      ),
                      TextButton(
                        child: const Text('Pick'),
                        onPressed: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2100),
                          );
                          if (date == null) return;
                          final time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                          if (time == null) return;
                          setStateDialog(() {
                            _eventDateTime = DateTime(date.year, date.month, date.day, time.hour, time.minute);
                          });
                        },
                      ),
                    ],
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Descripción'),
                    onSaved: (v) => _eventDesc = v ?? '',
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Formas de contacto (teléfono, email, link)'),
                    onSaved: (v) => _contactMethods = v ?? '',
                  ),
                  const SizedBox(height: 8),
                  if (_pickedImage != null) ...[
                    Image.file(File(_pickedImage!.path), height: 120),
                    const SizedBox(height: 8),
                  ],
                  Row(
                    children: [
                      ElevatedButton.icon(
                        icon: const Icon(Icons.photo),
                        label: const Text('Seleccionar imagen'),
                        onPressed: () async {
                          final picked = await _picker.pickImage(source: ImageSource.gallery, maxWidth: 1200);
                          if (picked != null) {
                            setStateDialog(() => _pickedImage = picked);
                          }
                        },
                      ),
                      const SizedBox(width: 8),
                      if (_pickedImage != null)
                        TextButton(
                          child: const Text('Quitar'),
                          onPressed: () => setStateDialog(() => _pickedImage = null),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                String? imageUrl;
                if (_pickedImage != null) {
                  try {
                    final file = File(_pickedImage!.path);
                    final ref = FirebaseStorage.instance.ref().child('events/${DateTime.now().millisecondsSinceEpoch}_${_pickedImage!.name}');
                    await ref.putFile(file);
                    imageUrl = await ref.getDownloadURL();
                  } catch (e) {
                    // ignore upload error for now
                  }
                }

                final map = {
                  'title': _eventTitle,
                  'datetime': _eventDateTime?.toIso8601String() ?? DateTime.now().toIso8601String(),
                  'description': _eventDesc,
                  'contact': _contactMethods,
                  if (imageUrl != null) 'image': imageUrl,
                };

                // Save to Firestore
                try {
                  await FirebaseFirestore.instance.collection('events').add(map);
                } catch (e) {
                  // ignore Firestore error for now
                }

                setState(() {
                  final local = <String, String>{
                    'title': _eventTitle,
                    'date': _eventDateTime?.toString() ?? '',
                    'desc': _eventDesc,
                    'contact': _contactMethods,
                    'image': imageUrl ?? '',
                  };
                  _events.add(local);
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Crear'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final serviceProvider = Provider.of<ServiceProvider>(context);
    final totalEmprendimientos = serviceProvider.allServices.length;
    final averageRating = totalEmprendimientos == 0
        ? 0.0
        : serviceProvider.allServices.map((s) => s.rating).reduce((a, b) => a + b) / totalEmprendimientos;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel Admin'),
        actions: [
          IconButton(
            tooltip: 'Cerrar sesión',
            icon: const Icon(Icons.logout),
            onPressed: () {
              Provider.of<UserRoleProvider>(context, listen: false).setRole(UserRole.cliente);
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Estadísticas', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildStatCard('Emprendimientos', totalEmprendimientos.toString(), Colors.blue),
                const SizedBox(width: 12),
                _buildStatCard('Rating prom.', averageRating.toStringAsFixed(1), Colors.green),
                const SizedBox(width: 12),
                _buildStatCard('Categorías', serviceProvider.allServices.map((s) => s.category).toSet().length.toString(), Colors.orange),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Eventos', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                ElevatedButton.icon(
                  onPressed: _showCreateEventDialog,
                  icon: const Icon(Icons.add),
                  label: const Text('Crear Evento'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: _events.isEmpty
                  ? const Center(child: Text('No hay eventos creados'))
                  : ListView.separated(
                      itemCount: _events.length,
                      separatorBuilder: (_, __) => const Divider(),
                      itemBuilder: (context, index) {
                        final e = _events[index];
                        return ListTile(
                          title: Text(e['title'] ?? ''),
                          subtitle: Text('${e['date'] ?? ''}\n${e['desc'] ?? ''}'),
                          isThreeLine: true,
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline),
                            onPressed: () => setState(() => _events.removeAt(index)),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(color: color, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Text(value, style: TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
