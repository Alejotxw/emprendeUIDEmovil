import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/notification_provider.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notificaciones'),
        backgroundColor: const Color(0xFFC8102E),
        foregroundColor: Colors.white,
      ),
      body: Consumer<NotificationProvider>(
        builder: (_, provider, __) {
          if (provider.notifications.isEmpty) {
            return const Center(child: Text('No tienes notificaciones'));
          }

          return ListView.builder(
            itemCount: provider.notifications.length,
            itemBuilder: (_, i) {
              final n = provider.notifications[i];

              return ListTile(
                leading: const Icon(Icons.notifications),
                title: Text(n.title),
                subtitle: Text(n.message),
                trailing: Text(
                  '${n.timestamp.hour.toString().padLeft(2, '0')}:${n.timestamp.minute.toString().padLeft(2, '0')}',
                  style: const TextStyle(fontSize: 12),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
