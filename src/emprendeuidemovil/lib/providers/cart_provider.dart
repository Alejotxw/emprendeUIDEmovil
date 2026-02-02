import 'package:flutter/material.dart';
import '../models/service_model.dart';
import '../models/cart_item.dart';

class CartProvider extends ChangeNotifier {
  final Map<String, List<CartItem>> _cart = {
    'servicios': <CartItem>[], 
    'productos': <CartItem>[]
  };

Map<String, List<CartItem>> get cart => _cart;
  List<CartItem> get servicios => _cart['servicios'] ?? <CartItem>[];
  List<CartItem> get productos => _cart['productos'] ?? <CartItem>[];
  bool get hasItems => servicios.isNotEmpty || productos.isNotEmpty;

  void addToCart(ServiceModel service, {ProductItem? product, ServiceItem? serviceItem, int quantity = 1, String? comment}) {
    final type = service.isProduct ? 'productos' : 'servicios';
    
    final existingIndex = _cart[type]!.indexWhere((item) => 
      item.service.id == service.id && 
      (product == null || item.product == product) &&
      (serviceItem == null || item.serviceItem == serviceItem)
    );

    if (existingIndex != -1) {
      _cart[type]![existingIndex].quantity += quantity;
    } else {
      final item = CartItem(
        service: service,
        product: product,
        serviceItem: serviceItem,
        quantity: quantity,
        comment: comment,
        // Forzamos que los servicios nazcan en pendiente
        status: service.isProduct ? CartStatus.accepted : CartStatus.pending,
      );
      _cart[type]!.add(item);
    }
    notifyListeners();
  }

  void updateItemStatus(CartItem item, CartStatus newStatus) {
    item.status = newStatus;
    notifyListeners();
  }

  void removeFromCart(ServiceModel service, {ProductItem? product, ServiceItem? serviceItem}) {
    final type = service.isProduct ? 'productos' : 'servicios';
    _cart[type]!.removeWhere((item) => 
      item.service.id == service.id && 
      (product == null || item.product == product) &&
      (serviceItem == null || item.serviceItem == serviceItem)
    );
    notifyListeners();
  }

  void updateQuantity(ServiceModel service, int delta, {ProductItem? product, ServiceItem? serviceItem}) {
    final type = service.isProduct ? 'productos' : 'servicios';
    final index = _cart[type]!.indexWhere((item) => 
      item.service.id == service.id && 
      (product == null || item.product == product) &&
      (serviceItem == null || item.serviceItem == serviceItem)
    );
    if (index != -1) {
      _cart[type]![index].quantity += delta;
      if (_cart[type]![index].quantity <= 0) {
        _cart[type]!.removeAt(index);
      }
      notifyListeners();
    }
  }

  void updateStatus(ServiceModel service, CartStatus newStatus, {ProductItem? product, ServiceItem? serviceItem}) {
    final type = service.isProduct ? 'productos' : 'servicios';
    final index = _cart[type]!.indexWhere((item) => 
      item.service.id == service.id && 
      (product == null || item.product == product) &&
      (serviceItem == null || item.serviceItem == serviceItem)
    );
    if (index != -1) {
      _cart[type]![index].status = newStatus;
      notifyListeners(); // Esto notificará a la pantalla del carrito para redibujarse
    }
}

  void updateComment(ServiceModel service, String newComment, {ProductItem? product, ServiceItem? serviceItem}) {
    final type = service.isProduct ? 'productos' : 'servicios';
    final index = _cart[type]!.indexWhere((item) => 
      item.service.id == service.id && 
      (product == null || item.product == product) &&
      (serviceItem == null || item.serviceItem == serviceItem)
    );
    if (index != -1) {
      _cart[type]![index].comment = newComment;
      notifyListeners();
    }
  }

// En lib/providers/cart_provider.dart

// En lib/providers/cart_provider.dart

void clearServices() {
  _cart['servicios'] = <CartItem>[];
  notifyListeners();
}

void clearProducts() {
  _cart['productos'] = <CartItem>[];
  notifyListeners();
}

  void clearCart() {
    _cart['servicios'] = <CartItem>[];
    _cart['productos'] = <CartItem>[];
    notifyListeners();
  }

  double get totalPrice {
    double total = 0.0;
    for (final item in [...servicios, ...productos]) {
      total += item.service.price * item.quantity;
    }
    return total;
  }

}