import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NotificationModel {
  final String? id; 
  final String title;
  final String message;
  final DateTime timestamp;

  NotificationModel({
    this.id,
    required this.title, 
    required this.message, 
    required this.timestamp
  });

  factory NotificationModel.fromMap(Map<String, dynamic> map, {String? id}) {
    return NotificationModel(
      id: id,
      title: map['title'] ?? 'Notificación',
      message: map['message'] ?? '',
      timestamp: map['timestamp'] != null 
          ? (map['timestamp'] as Timestamp).toDate() 
          : DateTime.now(),
    );
  }
}

class NotificationProvider extends ChangeNotifier {
  final List<NotificationModel> _notifications = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<NotificationModel> get notifications => _notifications;

  NotificationProvider() {
    _initListener();
  }

  void _initListener() {
    _auth.authStateChanges().listen((User? user) {
      if (user != null) {
        _listenToNotifications(user.uid);
      } else {
        _notifications.clear();
        notifyListeners();
      }
    });
  }

  StreamSubscription? _subscription;

  void _listenToNotifications(String uid) {
    _subscription?.cancel();
    _subscription = _firestore
        .collection('notifications')
        .where('recipientId', isEqualTo: uid)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .listen((snapshot) {
      _notifications.clear();
      for (var doc in snapshot.docs) {
        _notifications.add(NotificationModel.fromMap(doc.data(), id: doc.id));
      }
      notifyListeners();
    });
  }

  Future<void> addNotification(String title, String message, {String? recipientId}) async {
    final uid = recipientId ?? _auth.currentUser?.uid;
    if (uid == null) return;

    await _firestore.collection('notifications').add({
      'title': title,
      'message': message,
      'timestamp': FieldValue.serverTimestamp(),
      'recipientId': uid,
    });
  }

  Future<void> deleteNotification(String notificationId) async {
    try {
      // Optimistic update
      _notifications.removeWhere((n) => n.id == notificationId);
      notifyListeners();
      
      await _firestore.collection('notifications').doc(notificationId).delete();
      print("Notification $notificationId deleted successfully");
    } catch (e) {
      print("Error deleting notification: $e");
      // The listener will restore the state if sync fails
    }
  }

  Future<void> clearNotifications() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    // Optimistic update
    _notifications.clear();
    notifyListeners();

    try {
      final batch = _firestore.batch();
      final snapshots = await _firestore
          .collection('notifications')
          .where('recipientId', isEqualTo: uid)
          .get();
          
      for (var doc in snapshots.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();
      print("All notifications for $uid cleared");
    } catch (e) {
      print("Error clearing notifications: $e");
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}