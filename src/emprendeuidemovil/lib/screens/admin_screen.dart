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
    _tabController = TabController(length: 3, vsync: this);
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

  // LÓGICA DE ELIMINACIÓN EN CASCADA OPTIMIZADA
  Future<void> _performEmprendimientoDeletion(String serviceId, {String? ownerId}) async {
    final firestore = FirebaseFirestore.instance;
    final batch = firestore.batch();

    // 0. Si no tenemos ownerId, lo buscamos primero para optimizar la búsqueda de pedidos
    String? effectiveOwnerId = ownerId;
    if (effectiveOwnerId == null) {
      final doc = await firestore.collection('emprendimientos').doc(serviceId).get();
      if (doc.exists) {
        effectiveOwnerId = doc.data()?['ownerId'];
      }
    }

    // Ejecutar búsquedas en paralelo para mayor velocidad
    final results = await Future.wait([
      firestore.collection('reviews').where('serviceId', isEqualTo: serviceId).get(),
      firestore.collection('ratings').where('emprendimientoId', isEqualTo: serviceId).get(),
      // Filtramos pedidos por sellerId si lo tenemos, lo cual es MUCHO más rápido
      effectiveOwnerId != null 
        ? firestore.collection('orders').where('sellerId', isEqualTo: effectiveOwnerId).get()
        : firestore.collection('orders').get(),
    ]);

    final reviews = results[0];
    final ratings = results[1];
    final orders = results[2];

    // 1. Eliminar reseñas asociadas
    for (var doc in reviews.docs) {
      batch.delete(doc.reference);
    }

    // 2. Eliminar calificaciones asociadas
    for (var doc in ratings.docs) {
      batch.delete(doc.reference);
    }

    // 3. Eliminar pedidos que contienen este servicio
    for (var doc in orders.docs) {
       final data = doc.data() as Map<String, dynamic>;
       final items = (data['items'] as List<dynamic>?) ?? [];
       
       bool hasService = items.any((item) {
            final serviceMap = item['service'] as Map<String, dynamic>?;
            return serviceMap != null && serviceMap['id'] == serviceId;
       });

       if (hasService) {
         batch.delete(doc.reference);
         // Eliminar chats asociados al pedido
         batch.delete(firestore.collection('chats').doc('order-${doc.id}'));
       }
    }

    // 4. Eliminar el emprendimiento
    batch.delete(firestore.collection('emprendimientos').doc(serviceId));

    await batch.commit();
  }

  // USUARIOS: LÓGICA DE ELIMINACIÓN MEJORADA
  void _confirmDeleteUser(BuildContext context, String uid, String name) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Eliminar Usuario - CASCADA'),
        content: Text('¿Seguro que deseas eliminar a $name? Se borrarán todos sus emprendimientos, datos, reseñas y calificaciones asociadas permanentemente.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            onPressed: () async {
              Navigator.pop(context);
              
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(color: Colors.red),
                      SizedBox(height: 15),
                      Text("Eliminando datos del usuario...", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              );

              try {
                // 1. Buscar y eliminar todos sus emprendimientos (en cascada)
                final emps = await FirebaseFirestore.instance
                    .collection('emprendimientos')
                    .where('ownerId', isEqualTo: uid)
                    .get();
                
                for (var doc in emps.docs) {
                  await _performEmprendimientoDeletion(doc.id, ownerId: uid);
                }

                final batch = FirebaseFirestore.instance.batch();

                // 2. Eliminar reseñas que el usuario haya hecho (ReviewModel)
                final userReviews = await FirebaseFirestore.instance
                    .collection('reviews')
                    .where('userId', isEqualTo: uid)
                    .get();
                for (var doc in userReviews.docs) {
                   batch.delete(doc.reference);
                }

                // 3. Eliminar calificaciones hechas por el usuario (RatingModel)
                final userRatings = await FirebaseFirestore.instance
                    .collection('ratings')
                    .where('clienteId', isEqualTo: uid)
                    .get();
                for (var doc in userRatings.docs) {
                   batch.delete(doc.reference);
                }
                
                // 4. Eliminar pedidos donde sea cliente (ya borramos los de seller en el loop de emprendimientos)
                final clientOrders = await FirebaseFirestore.instance
                    .collection('orders')
                    .where('clientId', isEqualTo: uid)
                    .get();
                for (var doc in clientOrders.docs) {
                   batch.delete(doc.reference);
                   batch.delete(FirebaseFirestore.instance.collection('chats').doc('order-${doc.id}'));
                }

                // 5. Eliminar perfil de usuario
                batch.delete(FirebaseFirestore.instance.collection('users').doc(uid));
                
                await batch.commit();

                if (context.mounted) {
                  Navigator.pop(context); // Cierra el indicador de carga
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Usuario $name y todos sus datos eliminados'), backgroundColor: Colors.orange),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error al eliminar: $e'), backgroundColor: Colors.red),
                  );
                }
              }
            },
            child: const Text('Confirmar Eliminación Total'),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteEmprendimiento(BuildContext context, String id, String name, String ownerId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Emprendimiento'),
        content: Text('¿Estás seguro de que deseas eliminar "$name"? Se borrarán también sus reseñas y pedidos asociados.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            onPressed: () async {
              Navigator.pop(context);
              
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(color: Colors.red),
                      const SizedBox(height: 15),
                      Text('Eliminando "$name"...', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              );

              try {
                await _performEmprendimientoDeletion(id, ownerId: ownerId);
                
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Emprendimiento eliminado correctamente'), backgroundColor: Colors.orange),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
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
            Tab(icon: Icon(Icons.store), text: 'Negocios'),
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

          // PANEL DE EMPRENDIMIENTOS
          _buildEmprendimientosTab(),
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
                          leading: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              image: event.image != null ? DecorationImage(
                                image: _getUserImage(event.image)!,
                                fit: BoxFit.cover,
                              ) : null,
                            ),
                            child: event.image == null ? const Icon(Icons.image_not_supported) : null,
                          ),
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
            final String? imageBase64 = data['imageBase64'];
            
            // Lógica robusta para elegir la imagen (igual que en UserProfileProvider)
            String? effectivePath;
            if (imagePath != null && imagePath.startsWith('http')) {
              effectivePath = imagePath;
            } else if (imageBase64 != null && imageBase64.startsWith('data:image')) {
              effectivePath = imageBase64;
            } else {
              effectivePath = imagePath;
            }

            return Card(
              margin: const EdgeInsets.only(bottom: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: ListTile(
                leading: CircleAvatar(
                   backgroundColor: const Color(0xFF83002A),
                   backgroundImage: _getUserImage(effectivePath),
                   child: (effectivePath == null || effectivePath.isEmpty) ? const Icon(Icons.person, color: Colors.white) : null,
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

  Widget _buildEmprendimientosTab() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('emprendimientos').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No hay emprendimientos registrados.'));
        }

        final emps = snapshot.data!.docs;

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: emps.length,
          itemBuilder: (context, index) {
            final doc = emps[index];
            final data = doc.data() as Map<String, dynamic>;
            final String name = data['name'] ?? 'Sin Nombre';
            final String category = data['category'] ?? 'General';
            final String ownerId = data['ownerId'] ?? 'Desconocido';
            final String? image = data['imageUrl'] ?? data['image'];
            final String? serviceBase64 = data['imageBase64'];
            
            String? effectiveImg;
            if (image != null && image.startsWith('http')) {
              effectiveImg = image;
            } else if (serviceBase64 != null && serviceBase64.startsWith('data:image')) {
              effectiveImg = serviceBase64;
            } else {
              effectiveImg = image;
            }

            return Card(
              margin: const EdgeInsets.only(bottom: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: ListTile(
                leading: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: effectiveImg != null ? DecorationImage(
                      image: _getUserImage(effectiveImg)!,
                      fit: BoxFit.cover,
                    ) : null,
                  ),
                  child: effectiveImg == null ? const Icon(Icons.store) : null,
                ),
                title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('$category\nDueño ID: $ownerId', style: const TextStyle(fontSize: 11)),
                isThreeLine: true,
                trailing: IconButton(
                  icon: const Icon(Icons.delete_sweep, color: Colors.red),
                  onPressed: () => _confirmDeleteEmprendimiento(context, doc.id, name, ownerId),
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
    try {
      if (File(path).existsSync()) return FileImage(File(path));
    } catch (e) {
      // Ignorar errores de filesystem en web o si el path es inválido
    }
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
