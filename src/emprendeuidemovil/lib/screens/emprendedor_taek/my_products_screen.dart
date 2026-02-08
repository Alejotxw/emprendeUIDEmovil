import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/product_provider.dart';
import '../../models/product_model.dart';

class MyProductsScreen extends StatefulWidget {
  const MyProductsScreen({super.key});

  @override
  State<MyProductsScreen> createState() => _MyProductsScreenState();
}

class _MyProductsScreenState extends State<MyProductsScreen> {
  // ⚠️ luego lo sacas de tu auth real
  final String vendedorId = "TEMP_USER_ID";
  final String rol = "vendedor";

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductProvider>(
        context,
        listen: false,
      ).fetchMyProducts(vendedorId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis productos'),
        backgroundColor: const Color(0xFFC8102E),
        foregroundColor: Colors.white,
      ),
      body: Consumer<ProductProvider>(
        builder: (context, provider, child) {
          final products = provider.products;

          if (products.isEmpty) {
            return const Center(
              child: Text('Aún no tienes productos registrados'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return _MyProductCard(
                product: product,
                vendedorId: vendedorId,
                rol: rol,
              );
            },
          );
        },
      ),
    );
  }
}

class _MyProductCard extends StatelessWidget {
  final ProductModel product;
  final String vendedorId;
  final String rol;

  const _MyProductCard({
    required this.product,
    required this.vendedorId,
    required this.rol,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              product.title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 4),

            Text(product.description),

            const SizedBox(height: 8),

            Text(
              '\$ ${product.price.toStringAsFixed(2)}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFFC8102E),
              ),
            ),

            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () async {
                    final ok =
                        await Provider.of<ProductProvider>(
                          context,
                          listen: false,
                        ).deleteProduct(
                          productId: product.id,
                          vendedorId: vendedorId,
                          rol: rol,
                        );

                    if (ok && context.mounted) {
                      Provider.of<ProductProvider>(
                        context,
                        listen: false,
                      ).fetchMyProducts(vendedorId);
                    }
                  },
                  icon: const Icon(Icons.delete, color: Colors.red),
                  label: const Text(
                    'Eliminar',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
