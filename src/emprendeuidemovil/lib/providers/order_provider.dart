import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/order_model.dart';
import '../models/cart_item.dart';

class OrderProvider extends ChangeNotifier {
  List<OrderModel> _orders = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  StreamSubscription? _ordersSubscription;

  List<OrderModel> get orders => _orders;

  OrderProvider() {
    _auth.authStateChanges().listen((user) {
      if (user == null) {
        _orders = [];
        _ordersSubscription?.cancel();
        _ordersSubscription = null;
        notifyListeners();
      }
    });
  }

  /// Fetches orders from Firestore based on the user's role.
  /// role: 'client' or 'entrepreneur'
  void fetchOrders(String role) {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;

    _ordersSubscription?.cancel(); // Cancel previous listener if any

    Query query = _firestore.collection('orders');

    if (role == 'client') {
      query = query.where('clientId', isEqualTo: userId);
    } else {
      query = query.where('sellerId', isEqualTo: userId);
    }

    _ordersSubscription = query.snapshots().listen((snapshot) async {
      // 1. Convert snapshot to List<OrderModel>
      List<OrderModel> list = snapshot.docs.map((doc) {
        try {
          final data = doc.data() as Map<String, dynamic>;
          data['id'] = doc.id; 
          return OrderModel.fromMap(data);
        } catch (e) {
          print("Error parsing order ${doc.id}: $e");
          return null;
        }
      }).where((o) => o != null).cast<OrderModel>().toList();

      // 2. Identify unique Service IDs referenced in these orders
      final Set<String> serviceIdsToCheck = {};
      for (final order in list) {
        for (final item in order.items) {
          if (item.service.id.isNotEmpty) {
             serviceIdsToCheck.add(item.service.id);
          }
        }
      }

      // 3. Verify existence of these services in Firestore
      // Only proceed if there are services to check
      if (serviceIdsToCheck.isNotEmpty) {
        final existenceChecks = <String, bool>{};
        
        // Fetch service documents in parallel
        await Future.wait(serviceIdsToCheck.map((sId) async {
           try {
             final doc = await _firestore.collection('emprendimientos').doc(sId).get();
             existenceChecks[sId] = doc.exists;
           } catch (e) {
             print("Error checking service $sId existence: $e");
             // If error (e.g. permission), assume exists to avoid accidental deletion? 
             // Or assume fails? User wants deletion. Let's assume false if not found.
             existenceChecks[sId] = false; 
           }
        }));

        // 4. Filter out orders that reference non-existent services
        final batch = _firestore.batch();
        bool needsCommit = false;
        final List<OrderModel> validOrders = [];

        for (final order in list) {
           bool shouldDelete = false;

           for (final item in order.items) {
             final sId = item.service.id;
             // If service ID is tracked and it does NOT exist, mark order for deletion
             if (sId.isNotEmpty && existenceChecks.containsKey(sId) && existenceChecks[sId] == false) {
               shouldDelete = true;
               break;
             }
           }

           if (shouldDelete) {
             batch.delete(_firestore.collection('orders').doc(order.id));
             needsCommit = true;
             print("Eliminando orden huérfana ${order.id} (servicio eliminado)");
           } else {
             validOrders.add(order);
           }
        }

        // 5. Commit deletions if any
        if (needsCommit) {
           await batch.commit();
           // Update the list to show only valid orders immediately
           list = validOrders;
        }
      }
      
      // 6. Sort and Update State
      list.sort((a, b) => b.date.compareTo(a.date));
      _orders = list;
      
      notifyListeners();
    }, onError: (e) {
      print("Error en listener de pedidos: $e");
    });
  }


  Future<void> addOrder(List<CartItem> items, double total, String paymentMethod, {String? transferReceiptPath}) async {
    final user = _auth.currentUser;
    if (user == null) return;

    print("--- Agregando Pedido ---");
    print("Cliente: ${user.uid}");

    // Split items by Seller ID
    Map<String, List<CartItem>> itemsBySeller = {};
    for (var item in items) {
      String sellerId = item.service.ownerId;
      
      // Sanity check: if ownerId is missing, it's a critical error for existing data
      if (sellerId.isEmpty) {
        print("ADVERTENCIA: El servicio ${item.service.name} (ID: ${item.service.id}) no tiene ownerId.");
      }

      if (!itemsBySeller.containsKey(sellerId)) {
        itemsBySeller[sellerId] = [];
      }
      itemsBySeller[sellerId]!.add(item);
    }


    try {
      // Use a transaction to ensure stock is updated correctly and orders are created atomically
      await _firestore.runTransaction((transaction) async {
        for (var entry in itemsBySeller.entries) {
          final sellerId = entry.key;
          final sellerItems = entry.value;

          // Recalculate total for this specific seller
          double sellerTotal = 0;
          for (var item in sellerItems) {
            sellerTotal += item.price * item.quantity;
            
            // --- STOCK REDUCTION LOGIC ---
            if (item.isActualProduct && item.product != null) {
              final serviceRef = _firestore.collection('emprendimientos').doc(item.service.id);
              final serviceSnapshot = await transaction.get(serviceRef);
              
              if (serviceSnapshot.exists) {
                final serviceData = serviceSnapshot.data() as Map<String, dynamic>;
                List<dynamic> productsData = serviceData['products'] ?? [];
                
                // Find and update the specific product stock
                bool updated = false;
                for (int i = 0; i < productsData.length; i++) {
                  if (productsData[i]['name'] == item.product!.name) {
                    int currentStock = 0;
                    if (productsData[i]['stock'] is String) {
                      currentStock = int.tryParse(productsData[i]['stock']) ?? 0;
                    } else {
                      currentStock = productsData[i]['stock'] as int? ?? 0;
                    }
                    
                    int newStock = currentStock - item.quantity;
                    if (newStock < 0) newStock = 0;
                    
                    productsData[i]['stock'] = newStock;
                    updated = true;
                    break;
                  }
                }
                
                if (updated) {
                  transaction.update(serviceRef, {'products': productsData});
                }
              }
            }
          }

          final docRef = _firestore.collection('orders').doc();
          final newOrder = OrderModel(
            id: docRef.id,
            date: DateTime.now(),
            items: sellerItems,
            total: sellerTotal,
            paymentMethod: paymentMethod,
            transferReceiptPath: transferReceiptPath,
            clientId: user.uid,
            sellerId: sellerId,
          );

          transaction.set(docRef, newOrder.toMap());
        }
      });
      // Local lists will update via snapshot listener
    } catch (e) {
      print("Error creating order with transaction: $e");
      rethrow;
    }
  }


  Future<void> updateOrderStatus(String orderId, String newStatus, Color newColor) async {
    try {
      await _firestore.collection('orders').doc(orderId).update({
        'status': newStatus,
        'statusColor': newColor.value,
      });
    } catch (e) {
      print("Error updating status: $e");
    }
  }

  Future<void> updateOrderDeliveryDate(String orderId, DateTime date) async {
    try {
      await _firestore.collection('orders').doc(orderId).update({
         'deliveryDate': date.toIso8601String(),
      });
    } catch (e) {
       print("Error updating delivery date: $e");
    }
  }

  Future<void> deleteOrder(String orderId) async {
    try {
      await _firestore.collection('orders').doc(orderId).delete();
      // Also delete the associated chat to keep it clean
      await _firestore.collection('chats').doc('order-$orderId').delete();
      
      // Notify listeners handled by stream
    } catch (e) {
      print("Error deleting order: $e");
      rethrow;
    }
  }

  Future<void> deleteOrdersForService(String serviceId) async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      // Query all orders where the seller is the current user
      final querySnapshot = await _firestore
          .collection('orders')
          .where('sellerId', isEqualTo: user.uid)
          .get();

      final batch = _firestore.batch();
      bool hasDeletions = false;

      for (var doc in querySnapshot.docs) {
        final data = doc.data();
        final items = (data['items'] as List<dynamic>?) ?? [];
        
        // Check if any item belongs to the deleted service
        // We check the nested 'service' map for the 'id' field
        bool hasService = items.any((item) {
             final serviceMap = item['service'] as Map<String, dynamic>?;
             return serviceMap != null && serviceMap['id'] == serviceId;
        });

        if (hasService) {
           batch.delete(doc.reference);
           hasDeletions = true;
        }
      }

      if (hasDeletions) {
        await batch.commit();
        print("Eliminadas órdenes asociadas al servicio $serviceId");
      }
    } catch (e) {
      print("Error deleting orders for service $serviceId: $e");
    }
  }
}