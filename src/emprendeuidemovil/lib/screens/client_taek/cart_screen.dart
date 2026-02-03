import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';
import '../../models/cart_item.dart';
import '../../models/service_model.dart';
import 'payment_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  int _selectedTab = 0; // 0: Servicios, 1: Productos

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cartProvider, child) {
        // CORRECCIÓN: Declaramos 'items' una sola vez
        final bool isServiceTab = _selectedTab == 0;
        final List<CartItem> items = isServiceTab ? cartProvider.servicios : cartProvider.productos;
        final bool isEmpty = items.isEmpty;

        // Lógica de validación para el botón
        final bool hasPending = isServiceTab && items.any((item) => item.status == CartStatus.pending);
        final bool hasRejected = isServiceTab && items.any((item) => item.status == CartStatus.rejected);

        // Configuración dinámica del botón según la pestaña
        String buttonText;
        bool canPay;
        Color buttonColor;

        if (isServiceTab) {
          if (hasRejected) {
            buttonText = 'Solicitud Rechazada';
            canPay = false;
            buttonColor = Colors.red;
          } else if (hasPending) {
            buttonText = 'Esperando Aceptación';
            canPay = false;
            buttonColor = Colors.grey;
          } else {
            buttonText = 'Pagar Servicio';
            canPay = items.isNotEmpty;
            buttonColor = Colors.orange;
          }
        } else {
          buttonText = 'Comprar Productos';
          canPay = items.isNotEmpty;
          buttonColor = Colors.orange;
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Mi Carrito'),
            backgroundColor: const Color(0xFFC8102E),
            foregroundColor: Colors.white,
          ),
          body: Column(
            children: [
              // Selector de pestañas
              Container(
                color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF1E1E1E) : Colors.grey[100],
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildTabButton('Servicios', 0),
                    const SizedBox(width: 12),
                    _buildTabButton('Productos', 1),
                  ],
                ),
              ),
              // Lista de Items
              Expanded(
                child: isEmpty
                    ? const Center(child: Text('Tu carrito está vacío'))
                    : ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (context, index) => _buildCartItem(items[index], cartProvider),
                      ),
              ),
              // Botón de Pago
              if (!isEmpty)
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: buttonColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: canPay 
                        ? () => Navigator.push(context, MaterialPageRoute(builder: (context) => const PaymentScreen()))
                        : null,
                      child: Text(buttonText, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  // Widget para los botones de las pestañas
  // Dentro de _CartScreenState en cart_screen.dart

Widget _buildTabButton(String label, int index) {
    bool isSelected = _selectedTab == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedTab = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFC8102E) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFC8102E)),
        ),
        child: Text(
          label,
          style: TextStyle(color: isSelected ? Colors.white : const Color(0xFFC8102E), fontWeight: FontWeight.bold),
        ),
      ),
    );
  }



Widget _buildCartItem(CartItem item, CartProvider cartProvider) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            const Icon(Icons.shopping_bag, color: Color(0xFFC8102E), size: 40),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(item.displayName, style: const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      // BOTÓN EDITAR DESCRIPCIÓN
                      if (_selectedTab == 0 && item.status == CartStatus.pending)
                        IconButton(
                          icon: const Icon(Icons.edit_note, color: Colors.blue),
                          onPressed: () => _showEditCommentDialog(context, item, cartProvider),
                        ),
                    ],
                  ),
                  Text(item.comment ?? 'Sin descripción', style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic)),
                  const SizedBox(height: 8),
                  _buildStatusBadge(item.status),
                  const SizedBox(height: 4),
                  Text(
                    '\$${item.price.toStringAsFixed(2)} x ${item.quantity}',
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFC8102E)),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => cartProvider.removeFromCart(item.service, product: item.product, serviceItem: item.serviceItem),
            ),
          ],
        ),
      ),
    );
  }

// DIÁLOGO PARA EDITAR EL COMENTARIO
void _showEditCommentDialog(BuildContext context, CartItem item, CartProvider cartProvider) {
    final TextEditingController controller = TextEditingController(text: item.comment);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar descripción'),
        content: TextField(controller: controller, maxLines: 3, decoration: const InputDecoration(hintText: "Detalles del servicio...")),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () {
              cartProvider.updateComment(item.service, controller.text, product: item.product, serviceItem: item.serviceItem);
              Navigator.pop(context);
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  // Widget del "Cuadrito" de estado (Badge)
  Widget _buildStatusBadge(CartStatus status) {
    Color color = status == CartStatus.accepted ? Colors.green : (status == CartStatus.rejected ? Colors.red : Colors.orange);
    String text = status == CartStatus.accepted ? 'Aceptado' : (status == CartStatus.rejected ? 'Rechazado' : 'Pendiente');
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8), border: Border.all(color: color)),
      child: Text(text, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold)),
    );
  }
}

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          const Text('Tu carrito está vacío', style: TextStyle(fontSize: 18, color: Colors.grey)),
        ],
      ),
    );
  }
