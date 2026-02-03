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
                      final picked = await _picker.pickImage(
                        source: ImageSource.gallery,
                        imageQuality: 50, // Comprime la imagen
                      );
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
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFC8102E),
              foregroundColor: Colors.white,
            ),
            onPressed: () => _saveEvent(docId, existingData, isDraft: false),
            child: const Text('Publicar Evento'),
          )
        ],
      ),
    );
  }

  // FUNCIÓN AUXILIAR PARA PROCESAR EL GUARDADO (CENTRALIZADA)
  Future<void> _saveEvent(String? docId, Map<String, dynamic>? existingData, {required bool isDraft}) async {
    if (!_formKey.currentState!.validate()) return;
    
    _formKey.currentState!.save();
    
    // 1. Mostrar un indicador de carga (Loading)
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: Card(
          margin: EdgeInsets.symmetric(horizontal: 40),
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(color: Color(0xFFC8102E)),
                SizedBox(height: 20),
                Text('Publicando evento...', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text('Esto puede tardar unos segundos', style: TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
        ),
      ),
    );

    try {
      String? finalImageUrl = existingData?['image'];

      // 2. Subida de imagen a Firebase Storage (con Timeout y Logging)
      if (_pickedImage != null) {
        debugPrint("DEBUG: Preparando archivo para subir: ${_pickedImage!.path}");
        final file = File(_pickedImage!.path);
        final bytes = await file.readAsBytes(); // Leer bytes para mayor seguridad
        
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('events/${DateTime.now().millisecondsSinceEpoch}.jpg');
        
        debugPrint("DEBUG: Iniciando putData en storage...");
        final uploadTask = storageRef.putData(bytes);

        // Escuchar eventos de progreso
        uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
          double progress = 100 * (snapshot.bytesTransferred / snapshot.totalBytes);
          debugPrint("DEBUG: Progreso: ${progress.toStringAsFixed(2)}% (${snapshot.state})");
        });
        
        final TaskSnapshot snapshot = await uploadTask.timeout(const Duration(seconds: 45));
        
        if (snapshot.state == TaskState.success) {
          debugPrint("DEBUG: Subida exitosa. Obteniendo URL con reintentos...");
          
          // Lógica de reintento para getDownloadURL (algunas veces hay latencia)
          int retryCount = 0;
          while (retryCount < 3) {
            try {
              finalImageUrl = await snapshot.ref.getDownloadURL().timeout(const Duration(seconds: 10));
              debugPrint("DEBUG: URL obtenida: $finalImageUrl");
              break; 
            } catch (e) {
              retryCount++;
              debugPrint("DEBUG: Intento $retryCount de obtener URL falló: $e");
              if (retryCount >= 3) rethrow;
              await Future.delayed(const Duration(milliseconds: 500));
            }
          }
        } else {
          throw Exception("La subida falló con estado: ${snapshot.state}");
        }
      }

      // 3. Preparar el mapa de datos
      final eventData = {
        'title': _eventTitle,
        'datetime': _eventDateTime?.toIso8601String() ?? DateTime.now().toIso8601String(),
        'description': _eventDesc,
        'contact': _contactMethods,
        'image': finalImageUrl, 
        'status': isDraft ? 'draft' : 'published',
        'updatedAt': FieldValue.serverTimestamp(),
      };

      // 4. Guardar en Firestore (con Timeout y Logging)
      debugPrint("DEBUG: Guardando en Firestore...");
      if (docId == null) {
        await FirebaseFirestore.instance.collection('events').add(eventData)
            .timeout(const Duration(seconds: 20));
      } else {
        await FirebaseFirestore.instance.collection('events').doc(docId).update(eventData)
            .timeout(const Duration(seconds: 20));
      }
      debugPrint("DEBUG: Guardado en Firestore exitoso.");

      // 5. Cerrar diálogos y mostrar éxito
      if (mounted) {
        Navigator.pop(context); // Cierra el Loading
        Navigator.pop(context); // Cierra el Formulario
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isDraft ? 'Borrador guardado' : '¡Evento publicado con éxito!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      // 6. Manejo de errores detallado
      if (mounted) Navigator.pop(context); // Cierra el Loading
      debugPrint("DEBUG ERROR: Error al guardar evento: $e");
      
      String errorMsg = 'Error al publicar';
      if (e.toString().contains('timeout')) {
        errorMsg = 'Tiempo de espera agotado. Probablemente no hay internet o es muy lento.';
      } else if (e.toString().contains('permission-denied')) {
        errorMsg = 'Error de permisos en Firebase. Revisa las reglas de seguridad.';
      } else {
        errorMsg = 'Fallo: $e';
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMsg),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  // FUNCIÓN PARA CONFIRMAR ELIMINACIÓN
  void _confirmDelete(BuildContext context, String docId, String? imageUrl) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Evento'),
        content: const Text('¿Estás seguro de que deseas eliminar este evento? Esta acción no se puede deshacer.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            onPressed: () async {
              Navigator.pop(context); // Cerrar diálogo
              try {
                // 1. Eliminar de Firestore
                await FirebaseFirestore.instance.collection('events').doc(docId).delete();
                
                // 2. Opcional: Eliminar la imagen de Storage si existe
                if (imageUrl != null && imageUrl.contains('firebasestorage')) {
                  try {
                    await FirebaseStorage.instance.refFromURL(imageUrl).delete();
                  } catch (e) {
                    debugPrint("Error al borrar imagen de storage: $e");
                  }
                }
                
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Evento eliminado correctamente'), backgroundColor: Colors.orange),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error al eliminar: $e'), backgroundColor: Colors.red),
                  );
                }
              }
            },
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
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
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('events').snapshots(),
                  builder: (context, snapshot) {
                    final count = snapshot.hasData ? snapshot.data!.docs.length : 0;
                    return _buildStatCard('Eventos Activos', '$count', Colors.orange);
                  },
                ),
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
                                 onPressed: () => _confirmDelete(context, doc.id, data['image']),
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