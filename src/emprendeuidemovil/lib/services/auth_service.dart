import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ------------------------
  // Usuario actual
  // ------------------------
  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }

  // ------------------------
  // LOGIN
  // ------------------------
  Future<UserModel?> login(String email, String password) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;

      if (user == null) return null;

      return UserModel(
        id: user.uid,
        email: user.email ?? '',
        name: user.displayName ?? '',
      );
    } on FirebaseAuthException catch (e) {
      print('Login error: ${e.code}');
      return null;
    }
  }

  // ------------------------
  // REGISTER
  // ------------------------
  Future<UserModel> register({
    required String nombre,
    required String email,
    required String password,
    required String rol,
  }) async {
    final credential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = credential.user;

    if (user == null) {
      throw Exception('No se pudo crear el usuario');
    }

    // Guardar nombre en Auth
    await user.updateDisplayName(nombre);

    // Guardar perfil en Firestore
    await _firestore.collection('users').doc(user.uid).set({
      'nombre': nombre,
      'email': email,
      'rol': rol, // cliente | emprendedor
      'createdAt': FieldValue.serverTimestamp(),
    });

    return UserModel(id: user.uid, email: email, name: nombre);
  }
}
