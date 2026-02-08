import 'package:flutter/material.dart';
import 'service_model.dart';  // Import para ServiceModel, ProductItem, ServiceItem

enum CartStatus { pending, accepted, rejected }

class CartItem {
  final ServiceModel service;
  final ProductItem? product;  // Null para servicios generales
  final ServiceItem? serviceItem;  // Null para productos generales
  int quantity;
  CartStatus status;
  String? comment;  // Comentario para servicios

  CartItem({
    required this.service,
    this.product,
    this.serviceItem,
    this.quantity = 1,
    this.status = CartStatus.pending,
    this.comment,
  });

  String get displayName => product?.name ?? serviceItem?.name ?? service.name;
  
  double get price => product?.price ?? serviceItem?.price ?? service.price;

  bool get isActualProduct => product != null;
  bool get isActualService => serviceItem != null || (product == null && serviceItem == null);

  String get type => isActualProduct ? 'productos' : 'servicios';

  Map<String, dynamic> toMap() {
    return {
      'service': service.toFirestore()..addAll({'id': service.id, 'ownerId': service.ownerId}),
      'product': product?.toMap(),
      'serviceItem': serviceItem?.toMap(),
      'quantity': quantity,
      'status': status.index,
      'comment': comment,
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      service: ServiceModel.fromMap(map['service'], map['service']['id'] ?? '', ''),
      product: map['product'] != null ? ProductItem.fromMap(map['product']) : null,
      serviceItem: map['serviceItem'] != null ? ServiceItem.fromMap(map['serviceItem']) : null,
      quantity: map['quantity'] ?? 1,
      status: CartStatus.values[map['status'] ?? 0],
      comment: map['comment'],
    );
  }
}