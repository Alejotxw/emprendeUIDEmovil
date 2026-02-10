import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProfileProvider with ChangeNotifier {
  String _name = 'Usuario';
  String _phone = '';
  String _email = '';
  String? _imagePath;
  bool _showEmail = true;
  bool _showPhone = true;

  String get name => _name;
  String get phone => _phone;
  String get email => _email;
  String? get imagePath => _imagePath;
  bool get showEmail => _showEmail;
  bool get showPhone => _showPhone;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  UserProfileProvider() {
    _auth.authStateChanges().listen((User? user) {
      if (user != null) {
        _loadUserProfile();
      } else {
        // Clear profile if logout
        _name = 'Usuario';
        _phone = '';
        _email = '';
        _imagePath = null;
        _showEmail = true;
        _showPhone = true;
        notifyListeners();
      }
    });
  }

  Future<void> _loadUserProfile() async {
    final user = _auth.currentUser;
    if (user != null) {
      try {
        final doc = await _firestore.collection('users').doc(user.uid).get();
        if (doc.exists) {
          final data = doc.data()!;
          _name = data['nombre'] ?? data['name'] ?? 'Usuario';
          _phone = data['phone'] ?? '';
          _email = data['email'] ?? user.email ?? '';
          _imagePath = data['imagePath'];
          _showEmail = data['showEmail'] ?? true;
          _showPhone = data['showPhone'] ?? true;
        } else {
           _email = user.email ?? '';
        }
        notifyListeners();
      } catch (e) {
        print("Error cargando perfil: $e");
      }
    }
  }

  Future<void> updateProfile({
    String? name, 
    String? phone, 
    String? imagePath,
    bool? showEmail,
    bool? showPhone,
  }) async {
    final user = _auth.currentUser;
    if (user != null) {
      // 1. Actualizar estado local para feedback inmediato
      if (name != null) _name = name;
      if (phone != null) _phone = phone;
      if (imagePath != null) _imagePath = imagePath;
      if (showEmail != null) _showEmail = showEmail;
      if (showPhone != null) _showPhone = showPhone;
      notifyListeners();

      // 2. Persistir en Firestore
      try {
        final Map<String, dynamic> data = {};
        if (name != null) data['nombre'] = name;
        if (phone != null) data['phone'] = phone;
        if (imagePath != null) data['imagePath'] = imagePath;
        if (showEmail != null) data['showEmail'] = showEmail;
        if (showPhone != null) data['showPhone'] = showPhone;
        
        // Ensure email is saved if not there
        if (_email.isNotEmpty) data['email'] = _email;

        await _firestore.collection('users').doc(user.uid).set(data, SetOptions(merge: true));
      } catch (e) {
        print("Error guardando perfil en Firebase: $e");
      }
    }
  }
}
