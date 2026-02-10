import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewModel {
  final String id;
  final String serviceName; 
  final String serviceId; 
  final String ownerId; // ID of the entrepreneur who owns the service
  final String userName;
  final String comment;
  final int rating;
  final DateTime date;
  String? response; 

  ReviewModel({
    required this.id,
    required this.serviceName,
    this.serviceId = '',
    this.ownerId = '',
    required this.userName,
    required this.comment,
    required this.rating,
    required this.date,
    this.response,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'serviceName': serviceName,
      'serviceId': serviceId,
      'ownerId': ownerId,
      'userName': userName,
      'comment': comment,
      'rating': rating,
      'date': date.toIso8601String(),
      'response': response,
    };
  }

  factory ReviewModel.fromMap(Map<String, dynamic> map, {String? id}) {
    return ReviewModel(
      id: id ?? map['id'] ?? '',
      serviceName: map['serviceName'] ?? '',
      serviceId: map['serviceId'] ?? '',
      ownerId: map['ownerId'] ?? '',
      userName: map['userName'] ?? 'Anónimo',
      comment: map['comment'] ?? '',
      rating: map['rating'] ?? 0,
      date: map['date'] != null ? DateTime.parse(map['date']) : DateTime.now(),
      response: map['response'],
    );
  }
}

class ReviewProvider with ChangeNotifier {
  List<ReviewModel> _reviews = [];
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  ReviewProvider() {
    _init();
  }

  void _init() {
    // Listen to all reviews in real-time
    _firestore.collection('reviews').snapshots().listen((snapshot) {
      _reviews = snapshot.docs.map((doc) {
        return ReviewModel.fromMap(doc.data(), id: doc.id);
      }).toList();
      
      // Sort by date descending
      _reviews.sort((a, b) => b.date.compareTo(a.date));
      
      notifyListeners();
    }, onError: (e) {
      print("Error fetching reviews: $e");
    });
  }

  List<ReviewModel> get reviews => List.unmodifiable(_reviews);

  Future<void> addReview(String serviceName, String userName, String comment, int rating, {String serviceId = '', String ownerId = ''}) async {
    try {
      final newReview = ReviewModel(
        id: '', // Will be assigned by Firestore
        serviceName: serviceName,
        serviceId: serviceId,
        ownerId: ownerId,
        userName: userName,
        comment: comment,
        rating: rating,
        date: DateTime.now(),
      );

      await _firestore.collection('reviews').add(newReview.toMap());
    } catch (e) {
      print("Error adding review: $e");
      rethrow;
    }
  }

  Future<void> respondToReview(String reviewId, String response) async {
    try {
      await _firestore.collection('reviews').doc(reviewId).update({
        'response': response,
      });
    } catch (e) {
      print("Error responding to review: $e");
    }
  }

  Future<void> updateReview(String reviewId, String newComment, int newRating) async {
    try {
      await _firestore.collection('reviews').doc(reviewId).update({
        'comment': newComment,
        'rating': newRating,
      });
    } catch (e) {
      print("Error updating review: $e");
    }
  }

  Future<void> deleteReview(String reviewId) async {
    try {
      await _firestore.collection('reviews').doc(reviewId).delete();
    } catch (e) {
      print("Error deleting review: $e");
    }
  }

  Future<void> deleteResponse(String reviewId) async {
     try {
      await _firestore.collection('reviews').doc(reviewId).update({
        'response': null, 
      });
    } catch (e) {
      print("Error deleting response: $e");
    }
  }
}
