import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:emprendeuidemovil/screens/emprendedor_taek/detalle_solicitud.dart';
import '../../providers/cart_provider.dart';
import '../../providers/order_provider.dart'; // Nuevo
import '../../providers/notification_provider.dart'; // Nuevo
import '../../models/cart_item.dart';

class SolicitudesScreen extends StatefulWidget {
  const SolicitudesScreen({super.key});

  @override
  State<SolicitudesScreen> createState() => _SolicitudesScreenState();
}

class _SolicitudesScreenState extends State<SolicitudesScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch orders for the entrepreneur (where they are the seller)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<OrderProvider>(context, listen: false).fetchOrders('entrepreneur');
    });
  }

  @override
  Widget build(BuildContext context) {
    // Only listen to OrderProvider
    final orderProvider = Provider.of<OrderProvider>(context);

    // List of Orders where I am the seller
    final List<Map<String, dynamic>> listaCombinada = orderProvider.orders.map((order) {
            return {
              'title': order.items.any((i) => i.isActualProduct) ? 'Producto de Cliente' : 'Servicio de Cliente',
              'orderId': order.id,
              'tag': order.items.any((i) => i.isActualProduct) ? 'Producto' : 'Servicio',
              'description': order.items.map((i) => i.displayName).join(', '),
              'price': order.total.toStringAsFixed(2),
              'status': order.status,
              'statusColor': order.statusColor,
              'requesterName': 'Cliente', // In future, fetch client name via clientId
              'items': order.items.map((i) => {'name': i.displayName, 'detail': '${i.type} x${i.quantity}', 'price': i.price.toString()}).toList(),
              'paymentMethod': order.paymentMethod,
              'transferReceiptPath': order.transferReceiptPath,
              // Logic for delivery time or date
              'deliveryTime': order.deliveryDate != null 
                  ? "${order.deliveryDate!.day}/${order.deliveryDate!.month} ${order.deliveryDate!.hour}:${order.deliveryDate!.minute}" 
                  : 'Pendiente',
              'isOrder': true,
              'isProduct': order.items.any((i) => i.isActualProduct),
            };
          }).toList();

    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF121212) : Colors.white,
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 50, bottom: 20, left: 24, right: 24),
            decoration: const BoxDecoration(
              color: Color(0xFF83002A),
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
            ),
            child: const Center(
              child: Text(
                'Solicitudes Recibidas',
                style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.62, // Ajustado para que quepa el botón nuevo
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
              ),
              itemCount: listaCombinada.length,
              itemBuilder: (context, index) {
                return _buildSolicitudCard(context, index, listaCombinada[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSolicitudCard(BuildContext context, int index, Map<String, dynamic> solicitud) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => _manejarTap(context, index, solicitud),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 60, 
                    decoration: BoxDecoration(color: const Color(0xFF83002A), borderRadius: BorderRadius.circular(15))
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(solicitud['title'], style: const TextStyle(fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                      Text('Entrega: ${solicitud['deliveryTime']}', style: const TextStyle(fontSize: 10, color: Colors.blueGrey)),
                      const SizedBox(height: 4),
                      Text('\$${solicitud['price']}', style: const TextStyle(color: Color(0xFF83002A), fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        decoration: BoxDecoration(color: solicitud['statusColor'], borderRadius: BorderRadius.circular(8)),
                        alignment: Alignment.center,
                        child: Text(
                          solicitud['isProduct'] ? 'PRODUCTO - ${solicitud['status']}' : 'SERVICIO - ${solicitud['status']}', 
                          style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          // BOTÓN ENVIAR NOTIFICACIÓN
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(vertical: 4),
                ),
                onPressed: () {
                  final notiProvider = Provider.of<NotificationProvider>(context, listen: false);
                  notiProvider.addNotification(
                    "Actualización de Pedido", 
                    "Tu pedido '${solicitud['title']}' está siendo procesado."
                  );
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Notificación enviada al cliente')));
                },
                child: const Text('Enviar Noti', style: TextStyle(fontSize: 11, color: Colors.white)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _manejarTap(BuildContext context, int index, Map<String, dynamic> solicitud) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetalleSolicitudScreen(
          title: solicitud['title'],
          requesterName: solicitud['requesterName'],
          tag: solicitud['tag'],
          items: List<Map<String, String>>.from(solicitud['items']),
          paymentMethod: solicitud['paymentMethod'],
          description: solicitud['description'],
          isProduct: solicitud['isProduct'] ?? false,
          transferReceiptPath: solicitud['transferReceiptPath'],
          orderId: solicitud['orderId'],
        ),
      ),
    );

    if (result != null && mounted) {
      final cartProvider = Provider.of<CartProvider>(context, listen: false);
      final orderProvider = Provider.of<OrderProvider>(context, listen: false);

      if (solicitud['isOrder'] == true && solicitud['orderId'] != null) {
         // ACTUALIZACIÓN DE ESTADO PARA PEDIDOS DE PRODUCTOS
         if (result == 'Aceptado') {
           // Cambiamos a 'Aceptado' (o 'En Camino' según preferencia)
           orderProvider.updateOrderStatus(solicitud['orderId'], 'Aceptado', const Color(0xFF4CAF50)); 
         } else if (result == 'Rechazado') {
           orderProvider.updateOrderStatus(solicitud['orderId'], 'Rechazado', Colors.red);
         }
    }
  }
}
}