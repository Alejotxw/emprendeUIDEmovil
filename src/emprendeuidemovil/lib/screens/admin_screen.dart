import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

import '../providers/service_provider.dart';
import '../providers/user_role_provider.dart';
import '../providers/event_provider.dart';

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
                  else if (existingData != null && existingData['image'] != null && existingData['image'].toString().isNotEmpty)
                    Image.network(existingData['image'], height: 100, fit: BoxFit.cover, 
                      errorBuilder: (c,o,s) => const Icon(Icons.broken_image, size: 50)),
                  
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

  // FUNCIÓN AUXILIAR PARA PROCESAR EL GUARDADO (LOCAL - MOCK)
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
                Text('Guardando localmente...', style: TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
        ),
      ),
    );

    try {
      // SIMULAMOS UNA ESPERA DE RED PARA DAR FEEDBACK VISUAL
      await Future.delayed(const Duration(seconds: 1));

      String? finalImageUrl = existingData?['image'];
      if (_pickedImage != null) {
        // En un entorno real subiríamos a Storage, aqui usamos el path local
        finalImageUrl = _pickedImage!.path; 
      }

      // 3. Preparar el mapa de datos
      final eventData = {
        'title': _eventTitle,
        'datetime': _eventDateTime?.toIso8601String() ?? DateTime.now().toIso8601String(),
        'description': _eventDesc,
        'contact': _contactMethods,
        'image': finalImageUrl, 
        'status': isDraft ? 'draft' : 'published',
      };

      // 4. Guardar en LOCAL PROVIDER
      final eventProvider = Provider.of<EventProvider>(context, listen: false);
      
      if (docId == null) {
        eventProvider.addEvent(eventData);
      } else {
        eventProvider.updateEvent(docId, eventData);
      }
      
      debugPrint("DEBUG: Guardado local exitoso.");

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
      // 6. Manejo de errores
      if (mounted) Navigator.pop(context); // Cierra el Loading
      debugPrint("DEBUG ERROR: Error al guardar evento: $e");
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // FUNCIÓN PARA CONFIRMAR ELIMINACIÓN
  void _confirmDelete(BuildContext context, String docId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Evento'),
        content: const Text('¿Estás seguro de que deseas eliminar este evento?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            onPressed: () {
              Navigator.pop(context); // Cerrar diálogo
              Provider.of<EventProvider>(context, listen: false).deleteEvent(docId);
              ScaffoldMessenger.of(context).showSnackBar(
                 const SnackBar(content: Text('Evento eliminado correctamente'), backgroundColor: Colors.orange),
              );
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
    final eventProvider = Provider.of<EventProvider>(context); // Listen to events
    
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
                 _buildStatCard('Eventos Activos', '${eventProvider.events.length}', Colors.orange),
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
              child: eventProvider.events.isEmpty
                  ? const Center(child: Text('No hay eventos creados.'))
                  : ListView.builder(
                      itemCount: eventProvider.events.length,
                      itemBuilder: (context, index) {
                        final event = eventProvider.events[index];
                        final data = {
                          'title': event.title,
                          'datetime': event.datetime.toIso8601String(),
                          'description': event.description,
                          'contact': event.contact,
                          'image': event.image,
                          'status': event.status
                        };

                        return Card(
                          margin: const EdgeInsets.only(bottom: 10),
                          child: ListTile(
                            leading: event.image != null 
                              ? (event.image!.startsWith('http') 
                                 ? Image.network(event.image!, width: 50, height: 50, fit: BoxFit.cover, errorBuilder: (c,o,s) => const Icon(Icons.error)) 
                                 : Image.file(File(event.image!), width: 50, height: 50, fit: BoxFit.cover, errorBuilder: (c,o,s) => const Icon(Icons.image)))
                              : const Icon(Icons.image_not_supported),
                            title: Text(event.title),
                            subtitle: Row(
                              children: [
                                Text('${event.datetime.year}-${event.datetime.month}-${event.datetime.day}'),
                                const SizedBox(width: 10),
                                if (event.status == 'draft')
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
                                  onPressed: () => _showEventDialog(docId: event.id, existingData: data),
                                ),
                                 IconButton(
                                   icon: const Icon(Icons.delete_outline, color: Colors.red),
                                   onPressed: () => _confirmDelete(context, event.id),
                                 ),
                              ],
                            ),
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