import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProfileProvider with ChangeNotifier {
  String _name = 'Usuario';
  String _phone = '';
  String? _imagePath;

  String get name => _name;
  String get phone => _phone;
  String? get imagePath => _imagePath;

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
        _imagePath = null;
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
          _imagePath = data['imagePath'];
          // Si el campo phone/image no existe en el doc, mantenemos los valores por defecto o vacíos
        }
        notifyListeners();
      } catch (e) {
        print("Error cargando perfil: $e");
      }
    }
  }

  Future<void> updateProfile({String? name, String? phone, String? imagePath}) async {
    final user = _auth.currentUser;
    if (user != null) {
      // 1. Actualizar estado local para feedback inmediato
      if (name != null) _name = name;
      if (phone != null) _phone = phone;
      if (imagePath != null) _imagePath = imagePath;
      notifyListeners();

      // 2. Persistir en Firestore
      try {
        final Map<String, dynamic> data = {};
        if (name != null) data['nombre'] = name;
        if (phone != null) data['phone'] = phone;
        if (imagePath != null) data['imagePath'] = imagePath;
        
        await _firestore.collection('users').doc(user.uid).set(data, SetOptions(merge: true));
      } catch (e) {
        print("Error guardando perfil en Firebase: $e");
      }
    }
  }
}
