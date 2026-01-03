import 'package:flutter/material.dart';

enum UserRole { cliente, emprendedor }

class UserRoleProvider extends ChangeNotifier {
  UserRole _role = UserRole.cliente; // Inicia como cliente

  UserRole get role => _role;

  void setRole(UserRole newRole) {
    if (_role != newRole) {
      _role = newRole;
      notifyListeners();
    }
  }

  void toggleRole() {
    _role = _role == UserRole.cliente ? UserRole.emprendedor : UserRole.cliente;
    notifyListeners();
  }
}