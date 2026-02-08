import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/order_provider.dart';
import '../../models/order_model.dart';
import '../../models/cart_item.dart';
import '../../providers/review_provider.dart';

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
                return _buildOrderCard(context, order);
              },
            ),
    );
  }

  Widget _buildStatusBadge(OrderModel order) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: order.statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: order.statusColor),
      ),
      child: Text(
        order.status,
        style: TextStyle(
            color: order.statusColor, fontWeight: FontWeight.bold, fontSize: 12),
      ),
    );
  }

  Widget _buildOrderCard(BuildContext context, OrderModel order) {
    final NumberFormat currency = NumberFormat.simpleCurrency(locale: 'es_CO');
    final DateFormat dateFormat = DateFormat('yyyy-MM-dd HH:mm');

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Encabezado del pedido
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Pedido ${order.id}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold, 
                      fontSize: 16
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                _buildStatusBadge(order),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Fecha: ${dateFormat.format(order.date)}',
              style: TextStyle(color: Colors.grey[600], fontSize: 13),
            ),
            if (order.deliveryDate != null)
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Row(
                  children: [
                    const Icon(Icons.local_shipping_outlined, size: 14, color: Color(0xFFC8102E)),
                    const SizedBox(width: 4),
                    Text(
                      'Entrega programada: ${dateFormat.format(order.deliveryDate!)}',
                      style: const TextStyle(
                        color: Color(0xFFC8102E), 
                        fontWeight: FontWeight.bold,
                        fontSize: 13
                      ),
                    ),
                  ],
                ),
              ),
            const Divider(height: 24, thickness: 1),
            
            // Lista de items
            const Text(
              'Detalles:',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
            const SizedBox(height: 8),
            ...order.items.map((item) => _buildOrderItem(item, currency)),
            
            const Divider(height: 24, thickness: 1),
            
            // Total
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total Pagado',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  currency.format(order.total),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold, 
                    fontSize: 18,
                    color: Color(0xFFC8102E)
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            // Botón de Chat
            SizedBox(
              width: double.infinity,
              child: Row(
                children: [


                  // Si el pedido fue aceptado (por el emprendedor), mostramos botón de confirnar entrega
                  if (order.status == 'Aceptado' || order.status == 'En Camino') ...[
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _confirmarEntrega(context, order),
                        icon: const Icon(Icons.check_circle, size: 18),
                        label: const Text('Recibido', style: TextStyle(fontSize: 12)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8), // Compact
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderItem(CartItem item, NumberFormat currency) {
    final isProduct = item.isActualProduct;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isProduct ? Colors.blue.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              isProduct ? Icons.inventory_2_outlined : Icons.handyman_outlined,
              size: 20,
              color: isProduct ? Colors.blue[700] : Colors.orange[700],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.displayName,
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                ),
                const SizedBox(height: 2),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: isProduct ? Colors.blue[50] : Colors.orange[50],
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: isProduct ? Colors.blue[200]! : Colors.orange[200]!,
                      width: 0.5
                    ),
                  ),
                  child: Text(
                    isProduct ? 'Producto' : 'Servicio',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: isProduct ? Colors.blue[800] : Colors.orange[800],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'x${item.quantity}',
                style: TextStyle(color: Colors.grey[600], fontSize: 13),
              ),
              Text(
                currency.format(item.price * item.quantity),
                style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _confirmarEntrega(BuildContext context, OrderModel order) {
    // 1. Actualizar estado del pedido a 'Entregado'
    Provider.of<OrderProvider>(context, listen: false).updateOrderStatus(
      order.id, 
      'Entregado', 
      Colors.green
    );

    // 2. Mostrar diálogo de reseña
    // Usamos el nombre del emprendimiento del primer item si existe, o 'Emprendimiento' genérico
    final nombreEmprendimiento = order.items.isNotEmpty 
        ? order.items.first.service.name 
        : 'Emprendimiento';
    _mostrarDialogoResena(context, nombreEmprendimiento);
  }

  void _mostrarDialogoResena(BuildContext context, String nombreEmprendimiento) {
    int rating = 5;
    final TextEditingController commentController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: Text('Califica a $nombreEmprendimiento'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('¿Qué tal estuvo tu pedido?'),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return IconButton(
                        onPressed: () {
                          setStateDialog(() {
                            rating = index + 1;
                          });
                        },
                        icon: Icon(
                          index < rating ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                          size: 32,
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: commentController,
                    decoration: const InputDecoration(
                      hintText: 'Escribe un comentario...',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Omitir'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Guardar reseña en ReviewProvider
                    if (commentController.text.isNotEmpty) {
                      Provider.of<ReviewProvider>(context, listen: false).addReview(
                        nombreEmprendimiento,
                        "Cliente", // Nombre del usuario actual (debería venir del UserProfileProvider)
                        commentController.text,
                        rating,
                      );
                    }
                    
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('¡Gracias por tu calificación!')),
                    );
                  },
                  child: const Text('Enviar'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}