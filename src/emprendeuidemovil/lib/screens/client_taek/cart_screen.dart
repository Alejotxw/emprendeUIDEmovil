import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';
import '../../models/cart_item.dart';
import '../../models/service_model.dart';
import 'payment_screen.dart';
import '../../l10n/app_localizations.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  int _selectedTab = 0; // 0: Servicios, 1: Productos

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Consumer<CartProvider>(
      builder: (context, cartProvider, child) {
        final List<CartItem> items = _selectedTab == 0
            ? cartProvider.servicios
            : cartProvider.productos;
        final bool isEmpty = items.isEmpty;

        return Scaffold(
          appBar: AppBar(
            title: Text(t.cart), // Traducción
            backgroundColor: const Color(0xFFC8102E),
            foregroundColor: Colors.white,
          ),
          body: Column(
            children: [
              // Toggle Buttons: Servicios / Productos
              Container(
                color: Colors.grey[100],
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: ToggleButtons(
                  isSelected: [_selectedTab == 0, _selectedTab == 1],
                  onPressed: (index) => setState(() => _selectedTab = index),
                  borderRadius: BorderRadius.circular(8),
                  selectedColor: Colors.white,
                  fillColor: _selectedTab == 0
                      ? Colors.blue[600]
                      : Colors.orange[600],
                  borderColor: Colors.grey,
                  selectedBorderColor: _selectedTab == 0
                      ? Colors.blue[600]
                      : Colors.orange[600],
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 12,
                      ),
                      child: Text(t.services), // Nueva clave
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 12,
                      ),
                      child: Text(t.products), // Nueva clave
                    ),
                  ],
                ),
              ),
              Expanded(
                child: isEmpty
                    ? Center(child: Text(t.emptyCart)) // Nueva clave
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final CartItem item = items[index];
                          final bool isServiceTab = _selectedTab == 0;
                          final Color statusColor =
                              item.status == CartStatus.accepted
                              ? Colors.green
                              : Colors.orange;
                          final String statusText =
                              item.status == CartStatus.accepted
                              ? t.accepted
                              : t.pending;

                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      // Chip categoría/nombre del item
                                      Expanded(
                                        child: Chip(
                                          label: Text(item.service.category),
                                          backgroundColor: Colors.orange[300],
                                          labelStyle: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      // Chip status (solo servicios)
                                      if (isServiceTab)
                                        Chip(
                                          label: Text(statusText),
                                          backgroundColor: statusColor
                                              .withOpacity(0.2),
                                          labelStyle: TextStyle(
                                            color: statusColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    item.displayName,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    item.service.name,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '\$${item.service.price.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFC8102E),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  if (isServiceTab &&
                                      item.comment != null &&
                                      item.comment!.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4),
                                      child: Text(
                                        '${t.itemDetails}: ${item.comment}', // Nueva clave
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.blue,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                    ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          IconButton(
                                            icon: const Icon(
                                              Icons.edit,
                                              color: Colors.blue,
                                            ),
                                            onPressed: () => _showEditDialog(
                                              context,
                                              cartProvider,
                                              item,
                                              t,
                                            ),
                                          ),
                                          IconButton(
                                            icon: const Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                            ),
                                            onPressed: () {
                                              cartProvider.removeFromCart(
                                                item.service,
                                                product: item.product,
                                                serviceItem: item.serviceItem,
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                      if (!isServiceTab)
                                        Text(
                                          '${t.quantity}: ${item.quantity}', // Nueva clave
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
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
                          MaterialPageRoute(
                            builder: (context) => const PaymentScreen(),
                          ),
                        );
                      },
                      child: Text(
                        t.paymentMethod, // Nueva clave
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  void _showEditDialog(
    BuildContext context,
    CartProvider cartProvider,
    CartItem item,
    AppLocalizations t,
  ) {
    if (_selectedTab == 0) {
      final TextEditingController commentController = TextEditingController(
        text: item.comment ?? '',
      );
      showDialog(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: Text(t.editComment), // Nueva clave
          content: TextField(
            controller: commentController,
            decoration: InputDecoration(
              hintText: t.commentHint, // Nueva clave
              border: const OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(t.cancel), // Nueva clave
            ),
            TextButton(
              onPressed: () {
                if (commentController.text.isNotEmpty) {
                  cartProvider.updateComment(
                    item.service,
                    commentController.text,
                    product: item.product,
                    serviceItem: item.serviceItem,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(t.commentUpdated)),
                  ); // Nueva clave
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(t.commentEmpty)),
                  ); // Nueva clave
                }
                Navigator.pop(dialogContext);
              },
              child: Text(t.save), // Nueva clave
            ),
          ],
        ),
      );
    } else {
      int newQuantity = item.quantity;
      showDialog(
        context: context,
        builder: (dialogContext) => StatefulBuilder(
          builder: (dialogContext, setDialogState) => AlertDialog(
            title: Text(t.editQuantity), // Nueva clave
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () => setDialogState(
                    () => newQuantity = newQuantity > 1 ? newQuantity - 1 : 1,
                  ),
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
                child: Text(t.cancel),
              ),
              TextButton(
                onPressed: () {
                  if (newQuantity > 0) {
                    cartProvider.updateQuantity(
                      item.service,
                      newQuantity - item.quantity,
                      product: item.product,
                      serviceItem: item.serviceItem,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${t.quantityUpdated} $newQuantity'),
                      ),
                    ); // Nueva clave
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(t.quantityInvalid)),
                    ); // Nueva clave
                  }
                  Navigator.pop(dialogContext);
                },
                child: Text(t.save),
              ),
            ],
          ),
        ),
      );
    }
  }
}