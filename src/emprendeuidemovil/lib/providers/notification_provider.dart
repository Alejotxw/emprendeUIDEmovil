import 'package:flutter/material.dart';

// 1. La clase del modelo DEBE existir
class NotificationModel {
  final String title;
  final String message;
  final DateTime timestamp;

  NotificationModel({
    required this.title, 
    required this.message, 
    required this.timestamp
  });
}

class NotificationProvider extends ChangeNotifier {
  // MUY IMPORTANTE: Asegúrate de que diga <NotificationModel> y no <String> o nada
  final List<NotificationModel> _notifications = [];

  List<NotificationModel> get notifications => _notifications;

  void addNotification(String title, String message) {
    _notifications.insert(0, NotificationModel(
      title: title,
      message: message,
      timestamp: DateTime.now(),
    ));
    notifyListeners();
  }

  void clearNotifications() {
    _notifications.clear();
    notifyListeners();
  }
}