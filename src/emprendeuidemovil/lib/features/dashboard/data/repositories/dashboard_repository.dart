import '../../../../providers/service_provider.dart';

class DashboardRepository {
  final ServiceProvider provider;

  DashboardRepository(this.provider);

  // COUNT -> Total de servicios publicados
  int getTotalServicios() {
    return provider.allServices.length;
  }

  // SUM -> Suma de todos los precios base
  double getSumaPreciosServicios() {
    return provider.allServices.fold(
      0.0,
      (total, service) => total + service.price,
    );
  }

  // EXTRA (opcional pero pro): promedio de rating
  double getPromedioRating() {
    if (provider.allServices.isEmpty) return 0;

    final suma = provider.allServices.fold(0.0, (total, s) => total + s.rating);

    return suma / provider.allServices.length;
  }
}
