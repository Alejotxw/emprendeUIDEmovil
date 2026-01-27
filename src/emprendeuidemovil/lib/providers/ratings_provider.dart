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

  // Cargar calificaciones de un emprendedor
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

  // Obtener promedio de calificaciones
  Future<double> getAverageRating(String emprendedorId) async {
    return await _ratingsService.getAverageRating(emprendedorId);
  }

  // Obtener estadísticas de calificaciones
  Future<Map<String, dynamic>> getRatingStats(String emprendedorId) async {
    return await _ratingsService.getRatingStats(emprendedorId);
  }

  // Agregar nueva calificación
  Future<bool> addRating(RatingModel rating) async {
    final success = await _ratingsService.addRating(rating);
    if (success) {
      // Recargar las calificaciones después de agregar una nueva
      await loadRatings(rating.emprendedorId);
    }
    return success;
  }

  // Limpiar estado
  void clearState() {
    _ratings = [];
    _error = null;
    _isLoading = false;
    notifyListeners();
  }
}