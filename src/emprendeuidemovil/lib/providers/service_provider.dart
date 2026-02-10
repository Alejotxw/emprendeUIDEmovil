import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/service_model.dart';

class ServiceProvider extends ChangeNotifier {
  List<ServiceModel> _allServices = [];
  Set<String> _favorites = <String>{};

  List<ServiceModel> get allServices => _allServices;
  List<ServiceModel> get favorites => _allServices.where((s) => _favorites.contains(s.id)).toList();
  bool isFavorite(String id) => _favorites.contains(id);

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  FirebaseAuth get auth => _auth;

  QuerySnapshot? _lastSnapshot;

  ServiceProvider() {
    _fetchServices(); // Initial fetch
    _auth.authStateChanges().listen((user) {
      // When auth state changes, re-process the last fetched snapshot
      // This ensures 'isMine' is updated for the new user context
      if (_lastSnapshot != null) {
        _processSnapshot(_lastSnapshot!);
      }
      // If _lastSnapshot is null, it means _fetchServices hasn't completed yet,
      // or there are no services. In this case, there's nothing to re-process.
      // The _fetchServices listener will handle the initial processing.
    });
  }

  void _fetchServices() {
    _firestore.collection('emprendimientos').snapshots().listen((snapshot) {
      _lastSnapshot = snapshot; // Store the last snapshot
      _processSnapshot(snapshot);
    });
  }

  void _processSnapshot(QuerySnapshot snapshot) {
    final currentUser = _auth.currentUser;
    final uid = currentUser?.uid ?? '';
    print("ServiceProvider: Processing snapshot. Current User: $uid");

    _allServices = snapshot.docs.map((doc) {
      try {
        final data = doc.data() as Map<String, dynamic>; // Explicit cast
        // print("Fetching service: ${doc.id}, data: $data"); // Debug log (optional)
        return ServiceModel.fromMap(data, doc.id, uid);
      } catch (e) {
        print("Error parsing service ${doc.id}: $e");
        return null;
      }
    }).where((s) => s != null).cast<ServiceModel>().toList();

    print("ServiceProvider: Loaded ${_allServices.length} services total.");
    print("ServiceProvider: User has ${_allServices.where((s) => s.isMine).length} services.");

    // Recalcular favoritos basado en memoria local (o podrías guardarlo en Firebase)
    // Por ahora mantenemos la lógica de que si está en el set, es favorito UI
    notifyListeners();
  }

  void toggleFavorite(String id) {
    if (_favorites.contains(id)) {
      _favorites.remove(id);
    } else {
      _favorites.add(id);
    }
    notifyListeners();
  }

  List<ServiceModel> getServicesByCategory(String category) {
    return _allServices.where((s) => s.category == category).toList();
  }

  List<ServiceModel> get myServices => _allServices.where((s) => s.isMine).toList();

  Future<void> addService(ServiceModel service) async {
    try {
      String docId = service.id.isEmpty ? _firestore.collection('emprendimientos').doc().id : service.id;
      final currentUser = _auth.currentUser;
      
      final serviceWithInfo = service.copyWith(
        id: docId, 
        ownerId: currentUser?.uid ?? '',
        isMine: true,
      );

      final data = serviceWithInfo.toFirestore();
      await _firestore.collection('emprendimientos').doc(docId).set(data);
      // No necesitamos insert local porque el listener (snapshot) lo hará
    } catch (e) {
      print("Error añadiendo servicio: $e");
    }
  }

  Future<void> updateService(ServiceModel updatedService) async {
    try {
      final data = updatedService.toFirestore();
      await _firestore.collection('emprendimientos').doc(updatedService.id).update(data);
    } catch (e) {
      print("Error actualizando servicio: $e");
    }
  }

  Future<void> deleteService(String id) async {
    try {
      await _firestore.collection('emprendimientos').doc(id).delete();
    } catch (e) {
      print("Error eliminando servicio: $e");
    }
  }
}