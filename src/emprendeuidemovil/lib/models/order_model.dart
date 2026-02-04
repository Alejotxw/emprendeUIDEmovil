import 'package:flutter/material.dart';
import 'cart_item.dart';

class OrderModel {
  final String id;
  final DateTime date;
  final List<CartItem> items;
  final double total;
  final String status;
  final Color statusColor;
  final String paymentMethod;
  final String? transferReceiptPath;
  final DateTime? deliveryDate; // New field

  OrderModel({
    required this.id,
    required this.date,
    required this.items,
    required this.total,
    this.status = 'Pendiente',
    this.statusColor = Colors.orange,
    required this.paymentMethod,
    this.transferReceiptPath,
    this.deliveryDate,
  });
}