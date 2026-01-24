import 'package:flutter/material.dart';
import 'service_provider.dart';
import '../models/service_model.dart';

class DashboardProvider with ChangeNotifier {
  final ServiceProvider serviceProvider;

  DashboardProvider(this.serviceProvider);

  int get totalServicios => serviceProvider.allServices.length;

  int get totalCategorias =>
      serviceProvider.allServices.map((s) => s.category).toSet().length;

  Map<String, List<ServiceModel>> get serviciosPorEmprendimiento {
    final Map<String, List<ServiceModel>> result = {};

    for (var service in serviceProvider.allServices) {
      result.putIfAbsent(service.category, () => []);
      result[service.category]!.add(service);
    }
    return result;
  }

}
