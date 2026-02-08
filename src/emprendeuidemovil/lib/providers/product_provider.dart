import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';

class ProductProvider extends ChangeNotifier {
  final String _baseUrl = "http://10.0.2.2:4000";

  List<ProductModel> _products = [];

  List<ProductModel> get products => _products;

  // ======================================================
  // GET /products
  // ======================================================
  Future<void> fetchProducts() async {
    try {
      final url = Uri.parse("$_baseUrl/products");
      final response = await http.get(url);

      if (response.statusCode != 200) return;

      final List data = json.decode(response.body);

      _products = data.map((e) => ProductModel.fromJson(e)).toList();

      notifyListeners();
    } catch (e) {
      debugPrint("fetchProducts error: $e");
    }
  }

  // Alias para las pantallas
  Future<void> fetchAllProducts() async {
    return fetchProducts();
  }

  Future<void> fetchMyProducts(String vendedorId) async {
    return fetchProductsBySeller(vendedorId);
  }

  // ======================================================
  // GET /products/seller/:vendedorId
  // ======================================================
  Future<void> fetchProductsBySeller(String vendedorId) async {
    try {
      final url = Uri.parse("$_baseUrl/products/seller/$vendedorId");
      final response = await http.get(url);

      if (response.statusCode != 200) return;

      final List data = json.decode(response.body);

      _products = data.map((e) => ProductModel.fromJson(e)).toList();

      notifyListeners();
    } catch (e) {
      debugPrint("fetchProductsBySeller error: $e");
    }
  }

  // ======================================================
  // POST /products
  // (ya lo estabas usando, lo dejo aquí completo)
  // ======================================================
  Future<bool> createProduct({
    required String title,
    required String description,
    required double price,
    String? category,
    String? imageUrl,
    required String vendedorId,
    required String vendedorNombre,
    required String rol,
  }) async {
    try {
      final url = Uri.parse("$_baseUrl/products");

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "title": title,
          "description": description,
          "price": price,
          "category": category,
          "imageUrl": imageUrl,
          "vendedorId": vendedorId,
          "vendedorNombre": vendedorNombre,
          "rol": rol,
        }),
      );

      if (response.statusCode != 201) {
        debugPrint(response.body);
        return false;
      }

      return true;
    } catch (e) {
      debugPrint("createProduct error: $e");
      return false;
    }
  }

  // ======================================================
  // PUT /products/:id
  // ======================================================
  Future<bool> updateProduct({
    required String productId,
    required String vendedorId,
    required String rol,
    String? title,
    String? description,
    double? price,
    String? category,
    String? imageUrl,
  }) async {
    try {
      final url = Uri.parse("$_baseUrl/products/$productId");

      final response = await http.put(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "vendedorId": vendedorId,
          "rol": rol,
          if (title != null) "title": title,
          if (description != null) "description": description,
          if (price != null) "price": price,
          if (category != null) "category": category,
          if (imageUrl != null) "imageUrl": imageUrl,
        }),
      );

      if (response.statusCode != 200) {
        debugPrint(response.body);
        return false;
      }

      return true;
    } catch (e) {
      debugPrint("updateProduct error: $e");
      return false;
    }
  }

  // ======================================================
  // DELETE /products/:id
  // ======================================================
  Future<bool> deleteProduct({
    required String productId,
    required String vendedorId,
    required String rol,
  }) async {
    try {
      final url = Uri.parse("$_baseUrl/products/$productId");

      final response = await http.delete(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({"vendedorId": vendedorId, "rol": rol}),
      );

      if (response.statusCode != 200) {
        debugPrint(response.body);
        return false;
      }

      return true;
    } catch (e) {
      debugPrint("deleteProduct error: $e");
      return false;
    }
  }

  void clear() {
    _products = [];
    notifyListeners();
  }
}
