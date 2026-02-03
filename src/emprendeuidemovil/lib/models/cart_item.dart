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
}