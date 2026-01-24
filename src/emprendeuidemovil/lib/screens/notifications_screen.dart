import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/notification_model.dart';
import '../services/notifications_service.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final _service = NotificationsService();
  Future<List<AppNotification>>? _future;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final uid = prefs.getString('uid');

      if (uid == null || uid.isEmpty) {
        setState(() {
          _error =
              'No se encontró el usuario actual. Inicia sesión nuevamente.';
        });
        return;
      }

      setState(() {
        _future = _service.getNotifications(uid);
      });
    } catch (e) {
      setState(() {
        _error = 'Error al cargar notificaciones: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notificaciones'),
        backgroundColor: const Color(0xFF90063a),
      ),
      body: _error != null
          ? Center(child: Text(_error!))
          : _future == null
          ? const Center(child: CircularProgressIndicator())
          : FutureBuilder<List<AppNotification>>(
              future: _future,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                final notifications = snapshot.data ?? [];

                if (notifications.isEmpty) {
                  return const Center(
                    child: Text('No tienes notificaciones todavía'),
                  );
                }

                return RefreshIndicator(
                  onRefresh: _loadNotifications,
                  child: ListView.separated(
                    itemCount: notifications.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final n = notifications[index];

                      final dateText = n.createdAt == null
                          ? ''
                          : '${n.createdAt!.day.toString().padLeft(2, '0')}/'
                                '${n.createdAt!.month.toString().padLeft(2, '0')}/'
                                '${n.createdAt!.year} '
                                '${n.createdAt!.hour.toString().padLeft(2, '0')}:'
                                '${n.createdAt!.minute.toString().padLeft(2, '0')}';

                      return ListTile(
                        leading: const Icon(Icons.notifications),
                        title: Text(n.title),
                        subtitle: Text('${n.body}\n$dateText'),
                        isThreeLine: true,
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
