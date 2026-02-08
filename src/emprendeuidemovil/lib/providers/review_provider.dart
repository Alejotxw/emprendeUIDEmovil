import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

/*
Backend real:

POST   /reviews
GET    /reviews/service/:serviceId
GET    /reviews/user/:userId
GET    /reviews/owner/:ownerId
GET    /reviews/average/:serviceId
*/

class ReviewModel {
  final String id;
  final String serviceId;
  final String ownerId;
  final String userId;
  final String userName;
  final String comment;
  final int rating;
  final DateTime date;

  ReviewModel({
    required this.id,
    required this.serviceId,
    required this.ownerId,
    required this.userId,
    required this.userName,
    required this.comment,
    required this.rating,
    required this.date,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    DateTime parsedDate;

    final createdAt = json['createdAt'];

    // Firestore Timestamp o string
    if (createdAt is String) {
      parsedDate = DateTime.tryParse(createdAt) ?? DateTime.now();
    } else if (createdAt is Map && createdAt['_seconds'] != null) {
      parsedDate = DateTime.fromMillisecondsSinceEpoch(
        createdAt['_seconds'] * 1000,
      );
    } else {
      parsedDate = DateTime.now();
    }

    return ReviewModel(
      id: json['id'],
      serviceId: json['serviceId'],
      ownerId: json['ownerId'],
      userId: json['userId'],
      userName: json['userName'] ?? '',
      comment: json['comment'] ?? '',
      rating: (json['rating'] as num).toInt(),
      date: parsedDate,
    );
  }
}

class ReviewProvider with ChangeNotifier {
  final String _baseUrl = "http://10.0.2.2:4000";

  List<ReviewModel> _reviews = [];

  double _average = 0;
  int _total = 0;

  List<ReviewModel> get reviews => _reviews;
  double get average => _average;
  int get total => _total;

  // ===============================
  // GET /reviews/service/:serviceId
  // ===============================
  Future<void> fetchReviewsByService(String serviceId) async {
    try {
      final url = Uri.parse("$_baseUrl/reviews/service/$serviceId");

      final response = await http.get(url);

      if (response.statusCode != 200) return;

      final List data = json.decode(response.body);

      _reviews = data.map((e) => ReviewModel.fromJson(e)).toList();

      notifyListeners();
    } catch (e) {
      debugPrint("fetchReviewsByService error: $e");
    }
  }

  // ===============================
  // GET /reviews/user/:userId
  // ===============================
  Future<void> fetchReviewsByUser(String userId) async {
    try {
      final url = Uri.parse("$_baseUrl/reviews/user/$userId");

      final response = await http.get(url);

      if (response.statusCode != 200) return;

      final List data = json.decode(response.body);

      _reviews = data.map((e) => ReviewModel.fromJson(e)).toList();

      notifyListeners();
    } catch (e) {
      debugPrint("fetchReviewsByUser error: $e");
    }
  }

  // ===============================
  // GET /reviews/owner/:ownerId
  // ===============================
  Future<void> fetchReviewsByOwner(String ownerId) async {
    try {
      final url = Uri.parse("$_baseUrl/reviews/owner/$ownerId");

      final response = await http.get(url);

      if (response.statusCode != 200) return;

      final List data = json.decode(response.body);

      _reviews = data.map((e) => ReviewModel.fromJson(e)).toList();

      notifyListeners();
    } catch (e) {
      debugPrint("fetchReviewsByOwner error: $e");
    }
  }

  // ===============================
  // GET /reviews/average/:serviceId
  // ===============================
  Future<void> fetchAverage(String serviceId) async {
    try {
      final url = Uri.parse("$_baseUrl/reviews/average/$serviceId");

      final response = await http.get(url);

      if (response.statusCode != 200) return;

      final data = json.decode(response.body);

      _average = (data['average'] as num).toDouble();
      _total = data['total'];

      notifyListeners();
    } catch (e) {
      debugPrint("fetchAverage error: $e");
    }
  }

  // ===============================
  // POST /reviews
  // ===============================
  Future<bool> addReview({
    required String serviceId,
    required String ownerId,
    required String userId,
    required String userName,
    required int rating,
    String comment = "",
  }) async {
    try {
      final url = Uri.parse("$_baseUrl/reviews");

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "serviceId": serviceId,
          "ownerId": ownerId,
          "userId": userId,
          "userName": userName,
          "rating": rating,
          "comment": comment,
        }),
      );

      if (response.statusCode != 201) {
        debugPrint(response.body);
        return false;
      }

      // ✅ refrescar datos después de crear
      await fetchReviewsByService(serviceId);
      await fetchAverage(serviceId);

      return true;
    } catch (e) {
      debugPrint("addReview error: $e");
      return false;
    }
  }

  // =================================================
  // Helpers
  // =================================================

  void clear() {
    _reviews = [];
    _average = 0;
    _total = 0;
    notifyListeners();
  }
}
