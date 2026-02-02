import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../providers/service_provider.dart';
import '../providers/user_role_provider.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  
  // Variables para el formulario
  String _eventTitle = '';
  DateTime? _eventDateTime;
  String _eventDesc = '';
  String _contactMethods = '';
  XFile? _pickedImage;

  // FUNCIÓN PARA CREAR O EDITAR EVENTOS
  void _showEventDialog({String? docId, Map<String, dynamic>? existingData}) {
    if (existingData != null) {
      _eventTitle = existingData['title'] ?? '';
      _eventDateTime = DateTime.tryParse(existingData['datetime'] ?? '');
      _eventDesc = existingData['description'] ?? '';
      _contactMethods = existingData['contact'] ?? '';
    } else {
      _eventTitle = ''; _eventDateTime = null; _eventDesc = ''; _contactMethods = '';
    }
    _pickedImage = null;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(docId == null ? 'Nuevo Evento' : 'Editar Evento'),
        content: StatefulBuilder(
          builder: (context, setStateDialog) => Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    initialValue: _eventTitle,
                    decoration: const InputDecoration(labelText: 'Título'),
                    onSaved: (v) => _eventTitle = v ?? '',
                    validator: (v) => (v == null || v.isEmpty) ? 'Requerido' : null,
                  ),
                  const SizedBox(height: 10),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(_eventDateTime == null 
                      ? 'Seleccionar Fecha y Hora' 
                      : _eventDateTime!.toLocal().toString().split('.')[0]),
                    trailing: const Icon(Icons.calendar_month),
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: _eventDateTime ?? DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                      );
                      if (date == null) return;
                      final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(_eventDateTime ?? DateTime.now()),
                      );
                      if (time == null) return;
                      setStateDialog(() {
                        _eventDateTime = DateTime(date.year, date.month, date.day, time.hour, time.minute);
                      });
                    },
                  ),
                  TextFormField(
                    initialValue: _eventDesc,
                    decoration: const InputDecoration(labelText: 'Descripción'),
                    maxLines: 2,
                    onSaved: (v) => _eventDesc = v ?? '',
                  ),
                  TextFormField(
                    initialValue: _contactMethods,
                    decoration: const InputDecoration(labelText: 'Contacto (WhatsApp/Tel)'),
                    onSaved: (v) => _contactMethods = v ?? '',
                  ),
                  
                  const SizedBox(height: 15),
                  if (_pickedImage != null)
                    Image.file(File(_pickedImage!.path), height: 100, fit: BoxFit.cover)
                  else if (existingData != null && existingData['image'] != null)
                    Image.network(existingData['image'], height: 100, fit: BoxFit.cover),
                  
                  TextButton.icon(
                    onPressed: () async {
                      final picked = await _picker.pickImage(source: ImageSource.gallery);
                      if (picked != null) setStateDialog(() => _pickedImage = picked);
                    },
                    icon: const Icon(Icons.photo_library),
                    label: const Text('Galería'),
                  ),
                ],
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                
                // 1. Mostrar un indicador de carga (Loading)
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => const Center(child: CircularProgressIndicator()),
                );

                try {
                  String? finalImageUrl = existingData?['image'];

                  // 2. Subida de imagen a Firebase Storage
                  if (_pickedImage != null) {
                    final file = File(_pickedImage!.path);
                    // Usamos un nombre único para evitar conflictos
                    final storageRef = FirebaseStorage.instance
                        .ref()
                        .child('events/${DateTime.now().millisecondsSinceEpoch}.jpg');
                    
                    // Esperamos a que la subida termine por completo
                    await storageRef.putFile(file);
                    
                    // Obtenemos la URL después de confirmar que el archivo existe
                    finalImageUrl = await storageRef.getDownloadURL();
                  }

                  // 3. Preparar el mapa de datos
                  final isDraft = false;
                  final eventData = {
                    'title': _eventTitle,
                    'datetime': _eventDateTime?.toIso8601String() ?? DateTime.now().toIso8601String(),
                    'description': _eventDesc,
                    'contact': _contactMethods,
                    'image': finalImageUrl, 
                    'status': isDraft ? 'draft' : 'published',
                    'updatedAt': FieldValue.serverTimestamp(),
                  };

                  // 4. Guardar en Firestore
                  if (docId == null) {
                    await FirebaseFirestore.instance.collection('events').add(eventData);
                  } else {
                    await FirebaseFirestore.instance.collection('events').doc(docId).update(eventData);
                  }

                  // 5. Cerrar diálogos y mostrar éxito
                  if (mounted) {
                    Navigator.pop(context); // Cierra el Loading
                    Navigator.pop(context); // Cierra el Formulario
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(isDraft ? 'Borrador guardado' : 'Evento publicado')),
                    );
                  }
                } catch (e) {
                  // 6. Manejo de errores real
                  if (mounted) Navigator.pop(context); // Cierra el Loading
                  debugPrint("Error al guardar: $e");
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error al publicar: ${e.toString()}')),
                  );
                }
              }
            },
            child: const Text('Publicar Evento'),
          )
        ],
      ),
    );
  }

  // FUNCIÓN AUXILIAR PARA PROCESAR EL GUARDADO
  Future<void> _saveEvent(String? docId, Map<String, dynamic>? existingData, {required bool isDraft}) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      
      // Mostrar indicador de carga
      showDialog(context: context, builder: (_) => const Center(child: CircularProgressIndicator()));

      try {
        String? finalImageUrl = existingData?['image'];
        if (_pickedImage != null) {
          final ref = FirebaseStorage.instance.ref().child('events/${DateTime.now().millisecondsSinceEpoch}.jpg');
          await ref.putFile(File(_pickedImage!.path));
          finalImageUrl = await ref.getDownloadURL();
        }

        final data = {
          'title': _eventTitle,
          'datetime': _eventDateTime?.toIso8601String() ?? DateTime.now().toIso8601String(),
          'description': _eventDesc,
          'contact': _contactMethods,
          'image': finalImageUrl,
          'status': isDraft ? 'draft' : 'published', // CAMPO NUEVO
          'updatedAt': FieldValue.serverTimestamp(),
        };

        if (docId == null) {
          await FirebaseFirestore.instance.collection('events').add(data);
        } else {
          await FirebaseFirestore.instance.collection('events').doc(docId).update(data);
        }

        Navigator.pop(context); // Quitar carga
        Navigator.pop(context); // Cerrar diálogo
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(isDraft ? 'Guardado como borrador' : 'Evento publicado')),
        );
      } catch (e) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final serviceProvider = Provider.of<ServiceProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel de Administración'),
        backgroundColor: const Color(0xFFC8102E),
        foregroundColor: Colors.white,
        actions: [
          TextButton.icon(
            onPressed: () {
              Provider.of<UserRoleProvider>(context, listen: false).setRole(UserRole.cliente);
              Navigator.pushReplacementNamed(context, '/login');
            },
            icon: const Icon(Icons.logout, color: Colors.white),
            label: const Text('Salir', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                _buildStatCard('Emprendimientos', '${serviceProvider.allServices.length}', Colors.blue),
                const SizedBox(width: 12),
                _buildStatCard('Eventos Activos', '...', Colors.orange), 
              ],
            ),
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Gestión de Eventos', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                FloatingActionButton.extended(
                  onPressed: () => _showEventDialog(),
                  label: const Text('Nuevo'),
                  icon: const Icon(Icons.add),
                  backgroundColor: const Color(0xFFC8102E),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('events').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('No hay eventos creados.'));
                  }

                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final doc = snapshot.data!.docs[index];
                      final data = doc.data() as Map<String, dynamic>;
                      return Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: ListTile(
                          leading: data['image'] != null 
                            ? Image.network(data['image'], width: 50, height: 50, fit: BoxFit.cover)
                            : const Icon(Icons.image_not_supported),
                          title: Text(data['title'] ?? 'Sin título'),
                          subtitle: Row(
                            children: [
                              Text(data['datetime']?.split('T')[0] ?? ''),
                              const SizedBox(width: 10),
                              if (data['status'] == 'draft')
                                Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(color: Colors.amber[100], borderRadius: BorderRadius.circular(5)),
                                  child: const Text('BORRADOR', style: TextStyle(fontSize: 10, color: Colors.orange)),
                                ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () => _showEventDialog(docId: doc.id, existingData: data),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline, color: Colors.red),
                                onPressed: () => FirebaseFirestore.instance.collection('events').doc(doc.id).delete(),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
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
          children: [
            Text(title, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12)),
            const SizedBox(height: 4),
            Text(value, style: TextStyle(color: color, fontSize: 22, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}