import 'package:flutter/material.dart';
import '../../services/admin_dashboard_service.dart';
import '../../widgets/dashboard/metric_card.dart';
import '../../widgets/dashboard/metrics_chart.dart';
import '../../models/dashboard_metrics.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  final _service = AdminDashboardService();
  DashboardMetrics? metrics;

  DateTimeRange? range;

  @override
  void initState() {
    super.initState();
    _loadMetrics();
  }

  Future<void> _loadMetrics() async {
    final result = await _service.getMetrics(
      start: range?.start,
      end: range?.end,
    );
    setState(() => metrics = result);
  }

  @override
  Widget build(BuildContext context) {
    if (metrics == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard Administrador')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () async {
                range = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                );
                if (range != null) _loadMetrics();
              },
              child: const Text('Filtrar por fechas'),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                MetricCard(title: 'Usuarios', value: metrics!.totalUsers, icon: Icons.people),
                MetricCard(title: 'Emprendimientos', value: metrics!.totalEmprendimientos, icon: Icons.store),
                MetricCard(title: 'Publicaciones', value: metrics!.totalPublicaciones, icon: Icons.article),
              ],
            ),
            const SizedBox(height: 24),
            MetricsChart(
              users: metrics!.totalUsers,
              emprendimientos: metrics!.totalEmprendimientos,
              publicaciones: metrics!.totalPublicaciones,
            ),
          ],
        ),
      ),
    );
  }
}
