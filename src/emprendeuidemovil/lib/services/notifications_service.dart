import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/notification_model.dart';

class NotificationsService {
  // Emulador Android → 10.0.2.2 apunta a localhost del PC
  static const String baseUrl = 'http://10.0.2.2:4000';

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  /// Pide permisos, obtiene token FCM y lo registra en el backend
  Future<void> initAndRegisterToken(String uid) async {
    await _messaging.requestPermission(alert: true, badge: true, sound: true);

    final token = await _messaging.getToken();
    if (token == null) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('fcm_token', token);

    final uri = Uri.parse('$baseUrl/notifications/register-token');

    await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'uid': uid, 'token': token}),
    );
  }

  /// Traer notificaciones del backend para ese uid
  Future<List<AppNotification>> getNotifications(String uid) async {
    final uri = Uri.parse('$baseUrl/notifications/$uid');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data
          .map((e) => AppNotification.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Error al cargar notificaciones');
    }
  }
}
