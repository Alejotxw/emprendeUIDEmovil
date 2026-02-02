import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/order_provider.dart';
import 'package:intl/intl.dart'; // Para formatear fechas

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    final orders = orderProvider.orders;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Pedidos'),
        backgroundColor: const Color(0xFFC8102E),
        foregroundColor: Colors.white,
      ),
      body: orders.isEmpty
          ? const Center(child: Text('Aún no tienes pedidos realizados.'))
          : ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return _buildOrderCard(order);
              },
            ),
    );
  }

  Widget _buildStatusBadge(order) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: order.statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: order.statusColor),
      ),
      child: Text(
        order.status,
        style: TextStyle(color: order.statusColor, fontWeight: FontWeight.bold, fontSize: 12),
      ),
    );
  }

  Widget _buildOrderCard(order) {
    final NumberFormat currency = NumberFormat.simpleCurrency(locale: 'es_CO');
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        title: Text('Pedido ${order.id ?? ''}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 6),
            Text('Fecha: ${order.date ?? ''}'),
            const SizedBox(height: 4),
            Text('Items: ${order.items ?? ''}'),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildStatusBadge(order),
            const SizedBox(height: 6),
            Text(currency.format(order.total ?? 0)),
          ],
        ),
        onTap: () {
          // Opcional: navegar a detalle del pedido
        },
      ),
    );
  }
}