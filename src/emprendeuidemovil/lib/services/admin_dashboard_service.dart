import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/dashboard_metrics.dart';

class AdminDashboardService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // 🔒 Solución segura para versiones conflictivas del SDK
  int _safeCount(dynamic snap) {
    return snap.count as int;
  }

  Future<DashboardMetrics> getMetrics({
    DateTime? start,
    DateTime? end,
  }) async {
    Query<Map<String, dynamic>> usersQuery =
        _db.collection('users');

    Query<Map<String, dynamic>> emprendimientosQuery =
        _db.collection('emprendimientos');

    Query<Map<String, dynamic>> publicacionesQuery =
        _db.collection('publicaciones');

    if (start != null && end != null) {
      usersQuery = usersQuery
          .where('createdAt', isGreaterThanOrEqualTo: start)
          .where('createdAt', isLessThanOrEqualTo: end);

      emprendimientosQuery = emprendimientosQuery
          .where('createdAt', isGreaterThanOrEqualTo: start)
          .where('createdAt', isLessThanOrEqualTo: end);

      publicacionesQuery = publicacionesQuery
          .where('createdAt', isGreaterThanOrEqualTo: start)
          .where('createdAt', isLessThanOrEqualTo: end);
    }

    final usersSnap = await usersQuery.count().get();
    final emprendimientosSnap = await emprendimientosQuery.count().get();
    final publicacionesSnap = await publicacionesQuery.count().get();

    return DashboardMetrics(
      totalUsers: _safeCount(usersSnap),
      totalEmprendimientos: _safeCount(emprendimientosSnap),
      totalPublicaciones: _safeCount(publicacionesSnap),
    );
  }
}
