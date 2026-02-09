import 'package:flutter/foundation.dart';
import '../models/rating_model.dart';
import '../services/ratings_service.dart';

class RatingsProvider with ChangeNotifier {
  final RatingsService _ratingsService = RatingsService();

  List<RatingModel> _ratings = [];
  bool _isLoading = false;
  String? _error;

  List<RatingModel> get ratings => _ratings;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // -----------------------------
  // Cargar calificaciones
  // -----------------------------
  Future<void> loadRatings(String emprendedorId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _ratings = await _ratingsService.getRatingsForEmprendedor(emprendedorId);
    } catch (e) {
      _error = e.toString();
      _ratings = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // -----------------------------
  // Total de calificaciones
  // -----------------------------
  int get totalRatings => _ratings.length;

  // -----------------------------
  // Promedio calculado LOCALMENTE
  // -----------------------------
  double get averageRating {
    if (_ratings.isEmpty) return 0.0;

    double total = 0;

    for (final r in _ratings) {
      total += r.rating;
    }

    return total / _ratings.length;
  }

  // -----------------------------
  // Agregar calificación
  // -----------------------------
  Future<bool> addRating(RatingModel rating) async {
    try {
      final success = await _ratingsService.addRating(rating);

      if (success) {
        await loadRatings(rating.emprendedorId);
      }

      return success;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // -----------------------------
  // Limpiar estado
  // -----------------------------
  void clearState() {
    _ratings = [];
    _error = null;
    _isLoading = false;
    notifyListeners();
  }
}
