import 'package:flutter/material.dart';

class ReviewModel {
  final String id;
  final String serviceName; // Or Entrepreneur ID
  final String userName;
  final String comment;
  final int rating;
  final DateTime date;
  String? response; // For the entrepreneur's reply

  ReviewModel({
    required this.id,
    required this.serviceName,
    required this.userName,
    required this.comment,
    required this.rating,
    required this.date,
    this.response,
  });
}

class ReviewProvider with ChangeNotifier {
  final List<ReviewModel> _reviews = [];

  List<ReviewModel> get reviews => List.unmodifiable(_reviews);

  void addReview(String serviceName, String userName, String comment, int rating) {
    _reviews.insert(
      0,
      ReviewModel(
        id: DateTime.now().toString(),
        serviceName: serviceName,
        userName: userName,
        comment: comment,
        rating: rating,
        date: DateTime.now(),
      ),
    );
    notifyListeners();
  }

  void respondToReview(String reviewId, String response) {
    final index = _reviews.indexWhere((r) => r.id == reviewId);
    if (index != -1) {
      _reviews[index].response = response;
      notifyListeners();
    }
  }

  void updateReview(String reviewId, String newComment, int newRating) {
    final index = _reviews.indexWhere((r) => r.id == reviewId);
    if (index != -1) {
      final oldReview = _reviews[index];
      _reviews[index] = ReviewModel(
        id: oldReview.id,
        serviceName: oldReview.serviceName,
        userName: oldReview.userName,
        comment: newComment,
        rating: newRating,
        date: oldReview.date,
        response: oldReview.response,
      );
      notifyListeners();
    }
  }

  void deleteReview(String reviewId) {
    _reviews.removeWhere((r) => r.id == reviewId);
    notifyListeners();
  }

  void deleteResponse(String reviewId) {
    final index = _reviews.indexWhere((r) => r.id == reviewId);
    if (index != -1) {
      _reviews[index].response = null;
      notifyListeners();
    }
  }
}
