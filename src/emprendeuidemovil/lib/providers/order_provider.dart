import 'package:flutter/material.dart';
import '../models/order_model.dart';
import '../models/cart_item.dart';

class OrderProvider extends ChangeNotifier {
  final List<OrderModel> _orders = [];

  List<OrderModel> get orders => _orders;

  void addOrder(List<CartItem> items, double total, String paymentMethod, {String? transferReceiptPath}) {
    final newOrder = OrderModel(
      id: 'ORD-${DateTime.now().year}-${_orders.length + 101}',
      date: DateTime.now(),
      items: List.from(items), // Copia de los items actuales
      total: total,
      paymentMethod: paymentMethod,
      transferReceiptPath: transferReceiptPath,
    );
    _orders.insert(0, newOrder); // Agrega al inicio de la lista
    notifyListeners();
  }

  void updateOrderStatus(String orderId, String newStatus, Color newColor) {
    final index = _orders.indexWhere((o) => o.id == orderId);
    if (index != -1) {
      final oldOrder = _orders[index];
      _orders[index] = OrderModel(
        id: oldOrder.id,
        date: oldOrder.date,
        items: oldOrder.items,
        total: oldOrder.total,
        paymentMethod: oldOrder.paymentMethod,
        transferReceiptPath: oldOrder.transferReceiptPath,
        status: newStatus,
        statusColor: newColor,
        deliveryDate: oldOrder.deliveryDate, // Preserve
      );
      notifyListeners();
    }
  }

  void updateOrderDeliveryDate(String orderId, DateTime date) {
    final index = _orders.indexWhere((o) => o.id == orderId);
    if (index != -1) {
      final oldOrder = _orders[index];
      _orders[index] = OrderModel(
        id: oldOrder.id,
        date: oldOrder.date,
        items: oldOrder.items,
        total: oldOrder.total,
        paymentMethod: oldOrder.paymentMethod,
        transferReceiptPath: oldOrder.transferReceiptPath,
        status: oldOrder.status,
        statusColor: oldOrder.statusColor,
        deliveryDate: date,
      );
      notifyListeners();
    }
  }
}