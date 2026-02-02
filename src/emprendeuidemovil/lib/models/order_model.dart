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

  OrderModel({
    required this.id,
    required this.date,
    required this.items,
    required this.total,
    this.status = 'Pendiente',
    this.statusColor = Colors.orange,
    required this.paymentMethod,
  });
}