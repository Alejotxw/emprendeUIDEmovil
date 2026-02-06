import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';
import '../../models/cart_item.dart';
import '../../models/service_model.dart';
import '../client_taek/payment_screen.dart';  // Import para navegación a PaymentScreen

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  int _selectedTab = 0;  // 0: Servicios, 1: Productos

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cartProvider, child) {
        final List<CartItem> items = _selectedTab == 0 ? cartProvider.servicios : cartProvider.productos;
        final bool isEmpty = items.isEmpty;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Mi Carrito'),
            backgroundColor: const Color(0xFF83002A),
            foregroundColor: Colors.white,
          ),
          body: Column(
            children: [
              // Toggle Buttons: Servicios / Productos
              Container(
                color: const Color.fromARGB(255, 255, 255, 255),
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: ToggleButtons(
                  isSelected: [_selectedTab == 0, _selectedTab == 1],
                  onPressed: (index) => setState(() => _selectedTab = index),
                  borderRadius: BorderRadius.circular(8),
                  selectedColor: Colors.white,
                  fillColor: _selectedTab == 0 ? Colors.orange[600] : Colors.orange[600],
                  borderColor: Colors.grey,
                  selectedBorderColor: _selectedTab == 0 ? Colors.orange[600] : Colors.orange[600],
                  children: const [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      child: Text('Servicios'),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      child: Text('Productos'),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: isEmpty
                    ? const Center(child: Text('Tu carrito está vacío. ¡Agrega algo!'))
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final CartItem item = items[index];
                          final bool isServiceTab = _selectedTab == 0;
                          final Color statusColor = item.status == CartStatus.accepted ? Colors.green : Colors.orange;
                          final String statusText = item.status == CartStatus.accepted ? 'Aceptada' : 'Pendiente';

                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      // Chip naranja para categoría/nombre del item
                                      Expanded(
                                        child: Chip(
                                          label: Text(item.service.category),
                                          backgroundColor: Colors.orange[300],
                                          labelStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                                        ),
                                      ),
                                      // Chip status (solo para servicios)
                                      if (isServiceTab)
                                        Chip(
                                          label: Text(statusText),
                                          backgroundColor: statusColor.withOpacity(0.2),
                                          labelStyle: TextStyle(color: statusColor, fontWeight: FontWeight.bold),
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  // Nombre del item
                                  Text(
                                    item.displayName,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                  ),
                                  const SizedBox(height: 4),
                                  // Vendedor
                                  Text(
                                    item.service.name,
                                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                                  ),
                                  const SizedBox(height: 4),
                                  // Precio
                                  Text(
                                    '\$${item.service.price.toStringAsFixed(2)}',
                                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFC8102E)),
                                  ),
                                  const SizedBox(height: 8),
                                  // Comentario para servicios
                                  if (isServiceTab && item.comment != null && item.comment!.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4),
                                      child: Text(
                                        'Comentario: ${item.comment}',
                                        style: const TextStyle(fontSize: 12, color: Colors.blue, fontStyle: FontStyle.italic),
                                      ),
                                    ),
                                  // Row de botones
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.edit, color: Colors.blue),
                                            onPressed: () => _showEditDialog(context, cartProvider, item),
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.delete, color: Colors.red),
                                            onPressed: () {
                                              cartProvider.removeFromCart(item.service, product: item.product, serviceItem: item.serviceItem);
                                            },
                                          ),
                                        ],
                                      ),
                                      // Para productos: Muestra quantity actualizado
                                      if (!isServiceTab)
                                        Text(
                                          'Cantidad: ${item.quantity}',
                                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
              // Botón Forma de Pago (solo si hay items)
              if (!isEmpty)
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => PaymentScreen()),  // Removí const para fix error
                        );
                      },
                      child: const Text('Forma de Pago', style: TextStyle(fontSize: 18)),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  // Diálogo para editar (comentario para servicios, quantity para productos)
  void _showEditDialog(BuildContext context, CartProvider cartProvider, CartItem item) {
    if (_selectedTab == 0) {  // Servicios: Editar comentario
      final TextEditingController commentController = TextEditingController(text: item.comment ?? '');
      showDialog(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Editar Comentario'),
          content: TextField(
            controller: commentController,
            decoration: const InputDecoration(
              hintText: 'Describe lo que necesitas...',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                if (commentController.text.isNotEmpty) {
                  cartProvider.updateComment(item.service, commentController.text, product: item.product, serviceItem: item.serviceItem);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Comentario actualizado')));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('El comentario no puede estar vacío')));
                }
                Navigator.pop(dialogContext);
              },
              child: const Text('Guardar'),
            ),
          ],
        ),
      );
    } else {  // Productos: Editar quantity
      int newQuantity = item.quantity;
      showDialog(
        context: context,
        builder: (dialogContext) => StatefulBuilder(
          builder: (dialogContext, setDialogState) => AlertDialog(
            title: const Text('Editar Cantidad'),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () => setDialogState(() => newQuantity = newQuantity > 1 ? newQuantity - 1 : 1),
                ),
                Text('$newQuantity'),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => setDialogState(() => newQuantity++),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () {
                  if (newQuantity > 0) {
                    cartProvider.updateQuantity(item.service, newQuantity - item.quantity, product: item.product, serviceItem: item.serviceItem);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Cantidad actualizada a $newQuantity')));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('La cantidad debe ser mayor a 0')));
                  }
                  Navigator.pop(dialogContext);
                },
                child: const Text('Guardar'),
              ),
            ],
          ),
        ),
      );
    }
  }
}