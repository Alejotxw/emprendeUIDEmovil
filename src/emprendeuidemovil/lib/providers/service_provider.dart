import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/service_model.dart';

class ServiceProvider extends ChangeNotifier {
  final String _baseUrl = "http://10.0.2.2:4000";

  List<ServiceModel> _allServices = [];
  Set<String> _favorites = <String>{};

  List<ServiceModel> get allServices => _allServices;

  List<ServiceModel> get favorites =>
      _allServices.where((s) => _favorites.contains(s.id)).toList();

  bool isFavorite(String id) => _favorites.contains(id);

  ServiceProvider() {
    fetchServices();
  }

  // ==========================================================
  // OBTENER EMPRENDIMIENTOS (GET /services)
  // ==========================================================
  Future<void> fetchServices() async {
    try {
      final url = Uri.parse("$_baseUrl/services");
      final response = await http.get(url);

      if (response.statusCode != 200) {
        throw Exception("Error al obtener servicios");
      }

      final List data = json.decode(response.body);

      _allServices = data.map<ServiceModel>((e) {
        return ServiceModel(
          id: e["id"],

          name: e["title"] ?? "",
          subtitle: e["subtitle"] ?? "",

          category: e["category"] ?? "General",

          price: (e["price"] is num) ? (e["price"] as num).toDouble() : 0.0,

          rating: (e["rating"] is num) ? (e["rating"] as num).toDouble() : 0,

          reviewCount: e["reviewCount"] ?? 0,

          imageUrl: e["imagePath"] ?? "",

          schedule: e["schedule"] != null
              ? ScheduleModel(
                  days: List<String>.from(e["schedule"]["days"] ?? []),
                  open: e["schedule"]["open"] ?? "",
                  close: e["schedule"]["close"] ?? "",
                )
              : null,
          isMine: false,
          isFavorite: false,

          services: (e["services"] as List? ?? [])
              .map(
                (s) => ServiceItem(
                  name: s["name"] ?? "",
                  description: s["description"] ?? "",
                  price: double.tryParse(s["price"].toString()) ?? 0,
                ),
              )
              .toList(),

          products: (e["products"] as List? ?? [])
              .map(
                (p) => ProductItem(
                  name: p["name"] ?? "",
                  description: p["description"] ?? "",
                  price: double.tryParse(p["price"].toString()) ?? 0,
                ),
              )
              .toList(),
        );
      }).toList();

      notifyListeners();
    } catch (e) {
      debugPrint("Error fetchServices: $e");
    }
  }

  // ==========================================================
  // CREAR EMPRENDIMIENTO
  // POST /services
  // ==========================================================
  Future<bool> createService({
    required String title,
    required String subtitle,
    required double price,
    required String category,
    required String ownerId,
    String imagePath = "",
    Map<String, dynamic>? schedule,
    List<dynamic> services = const [],
    List<dynamic> products = const [],
  }) async {
    try {
      final url = Uri.parse("$_baseUrl/services");

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "title": title,
          "subtitle": subtitle,
          "price": price,
          "category": category,
          "imagePath": imagePath,
          "ownerId": ownerId,
          "services": services,
          "products": products,
          "schedule": schedule,
        }),
      );

      if (response.statusCode != 201) {
        debugPrint(response.body);
        return false;
      }

      await fetchServices();
      return true;
    } catch (e) {
      debugPrint("Error createService: $e");
      return false;
    }
  }

  // ==========================================================
  // ACTUALIZAR EMPRENDIMIENTO
  // PUT /services/:id
  // ==========================================================
  Future<bool> updateServiceRemote({
    required String id,
    String? title,
    String? subtitle,
    double? price,
    String? category,
    String? imagePath,
    Map<String, dynamic>? schedule,
    List? services,
    List? products,
  }) async {
    try {
      final url = Uri.parse("$_baseUrl/services/$id");

      final response = await http.put(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          if (title != null) "title": title,
          if (subtitle != null) "subtitle": subtitle,
          if (price != null) "price": price,
          if (category != null) "category": category,
          if (imagePath != null) "imagePath": imagePath,
          if (schedule != null) "schedule": schedule,
          if (services != null) "services": services,
          if (products != null) "products": products,
        }),
      );

      if (response.statusCode != 200) {
        debugPrint(response.body);
        return false;
      }

      await fetchServices();
      return true;
    } catch (e) {
      debugPrint("Error updateServiceRemote: $e");
      return false;
    }
  }

  // ==========================================================
  // ELIMINAR (DESACTIVAR)
  // DELETE /services/:id
  // ==========================================================
  Future<bool> deleteServiceRemote(String id) async {
    try {
      final url = Uri.parse("$_baseUrl/services/$id");

      final response = await http.delete(url);

      if (response.statusCode != 200) {
        debugPrint(response.body);
        return false;
      }

      await fetchServices();
      return true;
    } catch (e) {
      debugPrint("Error deleteServiceRemote: $e");
      return false;
    }
  }

  // ==========================================================
  // FAVORITOS (LOCAL)
  // ==========================================================
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

  // ==========================================================
  // MIS EMPRENDIMIENTOS
  // (luego filtramos por ownerId)
  // ==========================================================
  List<ServiceModel> get myServices => _allServices;

  // ==========================================================
  // MÉTODOS PUENTE
  // ==========================================================
  void addService(ServiceModel service) {
    _allServices.insert(0, service);
    notifyListeners();
  }

  void updateService(ServiceModel updatedService) {
    final index = _allServices.indexWhere((s) => s.id == updatedService.id);

    if (index != -1) {
      _allServices[index] = updatedService;
      notifyListeners();
    }
  }

  void deleteService(String id) {
    _allServices.removeWhere((s) => s.id == id);
    notifyListeners();
  }
}
