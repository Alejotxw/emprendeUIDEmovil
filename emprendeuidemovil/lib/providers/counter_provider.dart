import 'package:flutter/material.dart';

class CounterProvider extends ChangeNotifier {
  int _pendingRequests = 3; // Valor inicial (e.g., 3 solicitudes pendientes)

  int get pendingRequests => _pendingRequests;

  void increment() {
    _pendingRequests++;
    notifyListeners(); // Notifica a widgets que escuchan
  }

  void decrement() {
    if (_pendingRequests > 0) {
      _pendingRequests--;
      notifyListeners();
    }
  }

  void setValue(int value) {
    _pendingRequests = value;
    notifyListeners();
  }
}