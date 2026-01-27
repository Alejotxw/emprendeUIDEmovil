import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/rating_model.dart';

class RatingsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Obtener todas las calificaciones de un emprendedor
  Future<List<RatingModel>> getRatingsForEmprendedor(String emprendedorId) async {
    try {
      final querySnapshot = await _firestore
          .collection('ratings')
          .where('emprendedorId', isEqualTo: emprendedorId)
          .orderBy('fecha', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => RatingModel.fromMap(doc.data()..['id'] = doc.id))
          .toList();
    } catch (e) {
      print('Error obteniendo ratings: $e');
      return [];
    }
  }

  // Calcular el promedio de calificaciones de un emprendedor
  Future<double> getAverageRating(String emprendedorId) async {
    try {
      final ratings = await getRatingsForEmprendedor(emprendedorId);
      if (ratings.isEmpty) return 0.0;

      final total = ratings.fold<double>(0.0, (sum, rating) => sum + rating.rating);
      return total / ratings.length;
    } catch (e) {
      print('Error calculando promedio: $e');
      return 0.0;
    }
  }

  // Obtener estadísticas de calificaciones
  Future<Map<String, dynamic>> getRatingStats(String emprendedorId) async {
    try {
      final ratings = await getRatingsForEmprendedor(emprendedorId);

      if (ratings.isEmpty) {
        return {
          'average': 0.0,
          'total': 0,
          'distribution': {1: 0, 2: 0, 3: 0, 4: 0, 5: 0},
        };
      }

      final total = ratings.length;
      final average = ratings.fold<double>(0.0, (sum, rating) => sum + rating.rating) / total;

      final distribution = <int, int>{1: 0, 2: 0, 3: 0, 4: 0, 5: 0};
      for (final rating in ratings) {
        final roundedRating = rating.rating.round();
        if (distribution.containsKey(roundedRating)) {
          distribution[roundedRating] = distribution[roundedRating]! + 1;
        }
      }

      return {
        'average': average,
        'total': total,
        'distribution': distribution,
      };
    } catch (e) {
      print('Error obteniendo estadísticas: $e');
      return {
        'average': 0.0,
        'total': 0,
        'distribution': {1: 0, 2: 0, 3: 0, 4: 0, 5: 0},
      };
    }
  }

  // Agregar una nueva calificación
  Future<bool> addRating(RatingModel rating) async {
    try {
      await _firestore.collection('ratings').add(rating.toMap());
      return true;
    } catch (e) {
      print('Error agregando rating: $e');
      return false;
    }
  }
}