import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';

import '../providers/service_provider.dart';
import '../providers/user_role_provider.dart';
import '../providers/event_provider.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  
  // Variables para el formulario de eventos
  String _eventTitle = '';
  DateTime? _startDateTime;
  DateTime? _endDateTime;
  String _eventDesc = '';
  String _contactMethods = '';
  XFile? _pickedImage;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // ... (Keep existing private helper methods like _showEventDialog, _buildInputLabel, etc.)

  void _showEventDialog({String? docId, Map<String, dynamic>? existingData}) {
    if (existingData != null) {
      _eventTitle = existingData['title'] ?? '';
      _startDateTime = DateTime.tryParse(existingData['startDateTime'] ?? '');
      _endDateTime = DateTime.tryParse(existingData['endDateTime'] ?? '');
      _eventDesc = existingData['description'] ?? '';
      _contactMethods = existingData['contact'] ?? '';
    } else {
      _eventTitle = ''; 
      _startDateTime = null; 
      _endDateTime = null;
      _eventDesc = ''; 
      _contactMethods = '';
    }
    _pickedImage = null;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF121212) : Colors.white,
        insetPadding: const EdgeInsets.all(20),
        child: StatefulBuilder(
          builder: (context, setStateDialog) => Container(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      docId == null ? 'Nuevo Evento' : 'Editar Evento',
                      style: TextStyle(
                        fontSize: 22, 
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildInputLabel('Título'),
                    const SizedBox(height: 8),
                    _buildStyledTextField(
                      initialValue: _eventTitle,
                      hint: 'Título del evento',
                      onSaved: (v) => _eventTitle = v ?? '',
                      validator: (v) => (v == null || v.isEmpty) ? 'Requerido' : null,
                    ),
                    const SizedBox(height: 15),
                    
                    _buildInputLabel('Fecha y Hora de Inicio'),
                    const SizedBox(height: 8),
                    _buildDateTimePicker(
                      label: _startDateTime == null ? 'Seleccionar Inicio' : _formatDateTime(_startDateTime!),
                      selectedDate: _startDateTime,
                      onTap: () async {
                        final dt = await _pickDateTime(context, _startDateTime);
                        if (dt != null) setStateDialog(() => _startDateTime = dt);
                      }
                    ),

                    const SizedBox(height: 15),
                    _buildInputLabel('Fecha y Hora de Finalización'),
                    const SizedBox(height: 8),
                    _buildDateTimePicker(
                      label: _endDateTime == null ? 'Seleccionar Finalización' : _formatDateTime(_endDateTime!),
                      selectedDate: _endDateTime,
                      onTap: () async {
                        final dt = await _pickDateTime(context, _endDateTime);
                        if (dt != null) setStateDialog(() => _endDateTime = dt);
                      }
                    ),

                    const SizedBox(height: 15),
                    _buildInputLabel('Descripción'),
                    const SizedBox(height: 8),
                    _buildStyledTextField(
                      initialValue: _eventDesc,
                      hint: 'Descripción del evento',
                      maxLines: 3,
                      onSaved: (v) => _eventDesc = v ?? '',
                    ),
                    
                    const SizedBox(height: 15),
                    _buildInputLabel('Contacto (WhatsApp/Tel)'),
                    const SizedBox(height: 8),
                    _buildStyledTextField(
                      initialValue: _contactMethods,
                      hint: 'Ej: 0991234567',
                      onSaved: (v) => _contactMethods = v ?? '',
                    ),
                    
                    const SizedBox(height: 15),
                    GestureDetector(
                      onTap: () async {
                        final picked = await _picker.pickImage(
                          source: ImageSource.gallery,
                          imageQuality: 30,
                          maxWidth: 800,
                          maxHeight: 800,
                        );
                        if (picked != null) setStateDialog(() => _pickedImage = picked);
                      },
                      child: Container(
                        height: 120,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF1E1E1E) : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.grey.shade300),
                          image: _pickedImage != null 
                             ? DecorationImage(image: FileImage(File(_pickedImage!.path)), fit: BoxFit.cover)
                             : (existingData != null && existingData['image'] != null && existingData['image'].toString().isNotEmpty
                                ? DecorationImage(image: existingData['image'].toString().startsWith('http') 
                                    ? NetworkImage(existingData['image']) 
                                    : FileImage(File(existingData['image'])) as ImageProvider, fit: BoxFit.cover)
                                : null),
                        ),
                        child: _pickedImage == null && (existingData == null || existingData['image'] == null || existingData['image'].toString().isEmpty)
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add_a_photo, size: 40, color: Colors.grey.shade400),
                                const SizedBox(height: 8),
                                Text("Añadir Imagen", style: TextStyle(color: Colors.grey.shade500))
                              ],
                            )
                          : null,
                      ),
                    ),
                    
                    const SizedBox(height: 30),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              side: const BorderSide(color: Color(0xFFC8102E)),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                            ),
                            child: const Text('Cancelar', style: TextStyle(color: Color(0xFFC8102E), fontWeight: FontWeight.bold)),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFC8102E),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            onPressed: () {
                               if (_startDateTime == null || _endDateTime == null) {
                                 ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Selecciona fecha de inicio y fin')));
                                 return;
                               }
                               _saveEvent(docId, existingData, isDraft: false);
                            },
                            child: const Text('Publicar', style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputLabel(String label) {
    return Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14));
  }

  Widget _buildStyledTextField({
    String? initialValue,
    String? hint,
    int maxLines = 1,
    required FormFieldSetter<String> onSaved,
    FormFieldValidator<String>? validator,
  }) {
    return TextFormField(
      initialValue: initialValue,
      maxLines: maxLines,
      decoration: InputDecoration(
        filled: true,
        fillColor: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF1E1E1E) : Colors.white,
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade400),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      onSaved: onSaved,
      validator: validator,
    );
  }

  Widget _buildDateTimePicker({required String label, required DateTime? selectedDate, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                color: selectedDate == null ? Colors.grey.shade400 : (Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black87)
              ),
            ),
            Icon(Icons.calendar_month, color: Color(0xFFC8102E)),
          ],
        ),
      ),
    );
  }

  Future<DateTime?> _pickDateTime(BuildContext context, DateTime? initial) async {
    final date = await showDatePicker(
      context: context,
      initialDate: initial ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFC8102E),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: const Color(0xFFC8102E)), // Button text color
            ),
          ),
          child: child!,
        );
      },
    );
    if (date == null) return null;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initial ?? DateTime.now()),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFC8102E),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
             textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: const Color(0xFFC8102E)), // Button text color
            ),
          ),
          child: child!,
        );
      },
    );
    if (time == null) return null;
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  String _formatDateTime(DateTime dt) {
    return "${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";
  }

  Future<void> _saveEvent(String? docId, Map<String, dynamic>? existingData, {required bool isDraft}) async {
    if (!_formKey.currentState!.validate()) return;
    
    _formKey.currentState!.save();
    
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
              ],
            ),
          ),
        ),
      ),
    );

    try {
      String? finalImageUrl = existingData?['image'];
      
      if (_pickedImage != null) {
        // Convertir imagen a Base64 para que sea visible en todos los dispositivos
        final bytes = await File(_pickedImage!.path).readAsBytes();
        finalImageUrl = 'data:image/jpeg;base64,${base64Encode(bytes)}';
      }

      final eventData = {
        'title': _eventTitle,
        'startDateTime': _startDateTime?.toIso8601String(),
        'endDateTime': _endDateTime?.toIso8601String(),
        'description': _eventDesc,
        'contact': _contactMethods,
        'image': finalImageUrl, 
        'status': isDraft ? 'draft' : 'published',
      };

      final eventProvider = Provider.of<EventProvider>(context, listen: false);
      
      if (docId == null) {
        await eventProvider.addEvent(eventData);
      } else {
        await eventProvider.updateEvent(docId, eventData);
      }
      
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
            onPressed: () async {
              Navigator.pop(context); // Cerrar diálogo
              await Provider.of<EventProvider>(context, listen: false).deleteEvent(docId);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                   const SnackBar(content: Text('Evento eliminado correctamente'), backgroundColor: Colors.orange),
                );
              }
            },
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  // USUARIOS: LÓGICA DE ELIMINACIÓN
  void _confirmDeleteUser(BuildContext context, String uid, String name) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Eliminar Usuario'),
        content: Text('¿Seguro que deseas eliminar a $name? Se borrará su perfil de la base de datos.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            onPressed: () async {
              Navigator.pop(context);
              try {
                // 1. Eliminar de Firestore
                await FirebaseFirestore.instance.collection('users').doc(uid).delete();
                
                // Nota: No se puede eliminar de Auth directamente desde el cliente sin Admin SDK/Functions
                // pero eliminamos su acceso a datos de perfil.

                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Usuario $name eliminado de la base de datos'), backgroundColor: Colors.orange),
                  );
                }
              } catch (e) {
                if (context.mounted) {
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
    final eventProvider = Provider.of<EventProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel Administrativo'),
        backgroundColor: const Color(0xFF83002A),
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(icon: Icon(Icons.event), text: 'Eventos'),
            Tab(icon: Icon(Icons.people), text: 'Usuarios'),
          ],
        ),
        actions: [
           IconButton(
             icon: const Icon(Icons.logout),
             onPressed: () {
               Provider.of<UserRoleProvider>(context, listen: false).setRole(UserRole.cliente);
               Navigator.pushReplacementNamed(context, '/login');
             },
           )
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // PANEL DE EVENTOS
          _buildEventsTab(serviceProvider, eventProvider),
          
          // PANEL DE USUARIOS
          _buildUsersTab(),
        ],
      ),
    );
  }

  Widget _buildEventsTab(ServiceProvider serviceProvider, EventProvider eventProvider) {
    return Padding(
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
                        'startDateTime': event.startDateTime.toIso8601String(),
                        'endDateTime': event.endDateTime.toIso8601String(),
                        'description': event.description,
                        'contact': event.contact,
                        'image': event.image,
                        'status': event.status
                      };

                      return Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        child: ListTile(
                          leading: event.image != null 
                            ? (event.image!.startsWith('http') 
                               ? Image.network(event.image!, width: 50, height: 50, fit: BoxFit.cover, errorBuilder: (c,o,s) => const Icon(Icons.error)) 
                               : Image.file(File(event.image!), width: 50, height: 50, fit: BoxFit.cover, errorBuilder: (c,o,s) => const Icon(Icons.image)))
                            : const Icon(Icons.image_not_supported),
                          title: Text(event.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text('Inicia: ${_formatDateTime(event.startDateTime)}', style: const TextStyle(fontSize: 12)),
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
    );
  }

  Widget _buildUsersTab() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No hay usuarios registrados.'));
        }

        final users = snapshot.data!.docs;

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: users.length,
          itemBuilder: (context, index) {
            final userDoc = users[index];
            final data = userDoc.data() as Map<String, dynamic>;
            final String name = data['nombre'] ?? data['name'] ?? 'Sin Nombre';
            final String email = data['email'] ?? 'Sin Email';
            final String rol = data['rol'] ?? 'cliente';
            final String? imagePath = data['imagePath'];

            return Card(
              margin: const EdgeInsets.only(bottom: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: ListTile(
                leading: CircleAvatar(
                   backgroundColor: const Color(0xFF83002A),
                   backgroundImage: _getUserImage(imagePath),
                   child: (imagePath == null || imagePath.isEmpty) ? const Icon(Icons.person, color: Colors.white) : null,
                ),
                title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('$email\nRol: $rol', style: const TextStyle(fontSize: 12)),
                isThreeLine: true,
                trailing: (rol == 'admin') 
                   ? const Tooltip(message: 'No se puede eliminar al admin', child: Icon(Icons.security, color: Colors.grey))
                   : IconButton(
                       icon: const Icon(Icons.delete_forever, color: Colors.red),
                       onPressed: () => _confirmDeleteUser(context, userDoc.id, name),
                     ),
              ),
            );
          },
        );
      },
    );
  }

  ImageProvider? _getUserImage(String? path) {
    if (path == null || path.isEmpty) return null;
    if (path.startsWith('data:image')) {
      final b64 = path.split(',').last;
      return MemoryImage(base64Decode(b64));
    }
    if (path.startsWith('http')) return NetworkImage(path);
    if (File(path).existsSync()) return FileImage(File(path));
    return null;
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