import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/dashboard_provider.dart';
import 'dashboard_summary_card.dart';

class DashboardWidget extends StatelessWidget {
  const DashboardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final dashboard = Provider.of<DashboardProvider>(context);

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.3,
      children: [
        DashboardSummaryCard(
          title: 'Servicios',
          value: dashboard.totalServicios.toString(),
          icon: Icons.store,
        ),
        DashboardSummaryCard(
          title: 'Categorías',
          value: dashboard.totalCategorias.toString(),
          icon: Icons.category,
        ),
      ],
    );
  }
}
