import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  UserModel? _user;
  UserModel? get user => _user;

  bool get isLoggedIn => _user != null;

  Future<bool> login(String email, String password) async {
    final result = await _authService.login(email: email, password: password);

    if (result != null) {
      _user = result;
      notifyListeners();
      return true;
    }
    return false;
  }

  // 👇 CORREGIDO: ahora coincide con AuthService y RegisterScreen
  Future<bool> register(String nombre, String email, String password) async {
    final result = await _authService.register(
      nombre: nombre,
      email: email,
      password: password,
      rol: "comprador", // fijo aquí
    );

    if (result != null) {
      _user = result;
      notifyListeners();
      return true;
    }
    return false;
  }

  void logout() {
    _user = null;
    notifyListeners();
  }
}
