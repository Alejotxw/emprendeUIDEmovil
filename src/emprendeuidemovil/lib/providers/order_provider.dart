import 'package:flutter/material.dart';
import '../models/order_model.dart';
import '../models/cart_item.dart';

class OrderProvider extends ChangeNotifier {
  final List<OrderModel> _orders = [];

  List<OrderModel> get orders => _orders;

  void addOrder(List<CartItem> items, double total, String paymentMethod) {
    final newOrder = OrderModel(
      id: 'ORD-${DateTime.now().year}-${_orders.length + 101}',
      date: DateTime.now(),
      items: List.from(items), // Copia de los items actuales
      total: total,
      paymentMethod: paymentMethod,
    );
    _orders.insert(0, newOrder); // Agrega al inicio de la lista
    notifyListeners();
  }
}