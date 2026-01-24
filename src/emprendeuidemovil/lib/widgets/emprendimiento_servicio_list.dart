import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/dashboard_provider.dart';

class EmprendimientoServicioList extends StatelessWidget {
  const EmprendimientoServicioList({super.key});

  @override
  Widget build(BuildContext context) {
    final dashboard = Provider.of<DashboardProvider>(context);

    return Column(
      children: dashboard.serviciosPorEmprendimiento.entries.map((entry) {
        return ExpansionTile(
          title: Text('Emprendimiento ${entry.key}'),
          children: entry.value.map((service) {
            return ListTile(
              title: Text(service.name),
              subtitle: Text(service.subtitle),
            );
          }).toList(),
        );
      }).toList(),
    );
  }
}
