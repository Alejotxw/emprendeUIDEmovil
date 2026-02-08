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

  final String clientId;
  final String sellerId;

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
    required this.clientId,
    required this.sellerId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'items': items.map((i) => i.toMap()).toList(),
      'total': total,
      'status': status,
      'statusColor': statusColor.value,
      'paymentMethod': paymentMethod,
      'transferReceiptPath': transferReceiptPath,
      'deliveryDate': deliveryDate?.toIso8601String(),
      'clientId': clientId,
      'sellerId': sellerId,
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      id: map['id'],
      date: DateTime.parse(map['date']),
      items: (map['items'] as List).map((i) => CartItem.fromMap(i)).toList(),
      total: (map['total'] as num).toDouble(),
      status: map['status'] ?? 'Pendiente',
      statusColor: Color(map['statusColor'] ?? Colors.orange.value),
      paymentMethod: map['paymentMethod'],
      transferReceiptPath: map['transferReceiptPath'],
      deliveryDate: map['deliveryDate'] != null ? DateTime.parse(map['deliveryDate']) : null,
      clientId: map['clientId'] ?? '',
      sellerId: map['sellerId'] ?? '',
    );
  }
}