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

  Stream<DocumentSnapshot>? _userStream;

  UserProfileProvider() {
    _auth.authStateChanges().listen((User? user) {
      if (user != null) {
        _listenToProfileChanges(user.uid);
      } else {
        _resetProfile();
      }
    });
  }

  void _listenToProfileChanges(String uid) {
    _firestore.collection('users').doc(uid).snapshots().listen((doc) {
      if (doc.exists) {
        final data = doc.data()!;
        _name = data['nombre'] ?? data['name'] ?? 'Usuario';
        _phone = data['phone'] ?? '';
        _email = data['email'] ?? _auth.currentUser?.email ?? '';
        
        // Logic for robust image loading
        String? path = data['imagePath'];
        String? b64 = data['imageBase64'];
        
        if (path != null && path.startsWith('http')) {
           _imagePath = path;
        } else if (b64 != null && b64.startsWith('data:image')) {
           _imagePath = b64;
        } else {
           _imagePath = path; // Fallback to local path if no cloud options
        }
        
        _showEmail = data['showEmail'] ?? true;
        _showPhone = data['showPhone'] ?? true;
        notifyListeners();
      }
    }, onError: (e) {
      print("Error escuchando cambios de perfil: $e");
    });
  }

  void _resetProfile() {
    _name = 'Usuario';
    _phone = '';
    _email = '';
    _imagePath = null;
    _showEmail = true;
    _showPhone = true;
    notifyListeners();
  }

  // Se eliminó _loadUserProfile ya que ahora usamos el Stream listener

  Future<void> updateProfile({
    String? name, 
    String? phone, 
    String? imagePath,
    String? imageBase64,
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
        if (imageBase64 != null) data['imageBase64'] = imageBase64;
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
