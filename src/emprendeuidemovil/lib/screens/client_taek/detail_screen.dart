import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/service_model.dart';
import '../../providers/cart_provider.dart';
import '../../l10n/app_localizations.dart';

class DetailScreen extends StatefulWidget {
  final ServiceModel service;

  const DetailScreen({super.key, required this.service});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  int _selectedServiceIndex = -1;
  int _selectedProductIndex = -1;
  int _productQuantity = 1;
  final TextEditingController _commentController = TextEditingController();
  bool _isServiceValid = false;
  bool _isProductValid = false;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Consumer<CartProvider>(
      builder: (context, cartProvider, child) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            title: Row(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 20),
                const SizedBox(width: 4),
                Text('${widget.service.rating}'),
              ],
            ),
            backgroundColor: const Color(0xFFC8102E),
            foregroundColor: Colors.white,
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Imagen principal
                Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    image: const DecorationImage(
                      image: AssetImage('assets/food_placeholder.png'),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(12),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Título y categoría
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              widget.service.name,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Chip(
                            label: Text(widget.service.category),
                            backgroundColor: Colors.orange[100],
                            labelStyle: const TextStyle(
                              color: Color(0xFFC8102E),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        t.entrepreneurMode, // Ejemplo de autor mock
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Descripción
                      Text(
                        widget.service.subtitle,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Información
                      Text(
                        t.itemDetails, // "Información"
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFC8102E),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildInfoCard(t.serviceRating, 'Lun-Vie 10:00-16:00'),
                      _buildInfoCard(
                        t.viewService,
                        'Dirección mock, Quito, Ecuador',
                      ),
                      // Mapa placeholder
                      Container(
                        height: 150,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.grey[300],
                        ),
                        child: Center(child: Text(t.mapPlaceholder)),
                      ),
                      const SizedBox(height: 24),
                      // Servicios o Productos
                      Text(
                        widget.service.isService ? t.services : t.products,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFC8102E),
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (widget.service.isService &&
                          widget.service.services.isNotEmpty)
                        ...widget.service.services
                            .asMap()
                            .entries
                            .map(
                              (entry) => _buildServiceItem(
                                entry.value,
                                entry.key + 1,
                                t,
                              ),
                            )
                            .toList()
                      else if (widget.service.isService)
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(t.noServices),
                        )
                      else if (widget.service.products.isNotEmpty)
                        ...widget.service.products
                            .asMap()
                            .entries
                            .map(
                              (entry) => _buildProductItem(
                                entry.value,
                                entry.key + 1,
                                t,
                              ),
                            )
                            .toList()
                      else
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(t.emptyCart),
                        ),
                      const SizedBox(height: 24),
                      // Para servicios
                      if (widget.service.isService)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              t.commentHint,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller: _commentController,
                              decoration: InputDecoration(
                                hintText: t.commentHint,
                                border: const OutlineInputBorder(),
                                filled: true,
                                fillColor: Colors.grey[50],
                              ),
                              maxLines: 3,
                              onChanged: (value) => setState(() {
                                _isServiceValid =
                                    _selectedServiceIndex != -1 &&
                                    value.isNotEmpty;
                              }),
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                ),
                                onPressed: _isServiceValid
                                    ? () {
                                        final selectedItem = widget
                                            .service
                                            .services[_selectedServiceIndex];
                                        cartProvider.addToCart(
                                          widget.service,
                                          serviceItem: selectedItem,
                                          comment: _commentController.text,
                                        );
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(t.commentUpdated),
                                          ),
                                        );
                                        _commentController.clear();
                                        setState(() {
                                          _selectedServiceIndex = -1;
                                          _isServiceValid = false;
                                        });
                                      }
                                    : null,
                                child: Text(t.save),
                              ),
                            ),
                          ],
                        ),
                      // Para productos
                      if (widget.service.isProduct)
                        Column(
                          children: [
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      icon: const Icon(Icons.shopping_cart),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.orange,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 16,
                                        ),
                                      ),
                                      onPressed: _isProductValid
                                          ? () {
                                              final selectedItem = widget
                                                  .service
                                                  .products[_selectedProductIndex];
                                              cartProvider.addToCart(
                                                widget.service,
                                                product: selectedItem,
                                                quantity: _productQuantity,
                                              );
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    '${t.add} $_productQuantity',
                                                  ),
                                                ),
                                              );
                                              setState(() {
                                                _selectedProductIndex = -1;
                                                _productQuantity = 1;
                                                _isProductValid = false;
                                              });
                                            }
                                          : null,
                                      label: Text(t.add),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  // Contador
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: const Icon(
                                            Icons.remove,
                                            size: 20,
                                          ),
                                          onPressed: () => setState(
                                            () => _productQuantity =
                                                _productQuantity > 1
                                                ? _productQuantity - 1
                                                : 1,
                                          ),
                                        ),
                                        Text(
                                          '$_productQuantity',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.add, size: 20),
                                          onPressed: () => setState(
                                            () => _productQuantity++,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoCard(String title, String value) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            title.contains('Horario') ? Icons.schedule : Icons.location_on,
            color: Colors.orange,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '$title: $value',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductItem(ProductItem item, int index, AppLocalizations t) {
    final isSelected = _selectedProductIndex == index - 1;
    return GestureDetector(
      onTap: () => setState(() {
        _selectedProductIndex = index - 1;
        _isProductValid = true;
        _productQuantity = 1;
      }),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.orange[50] : Colors.transparent,
          border: Border.all(
            color: isSelected ? Colors.orange : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  '$index. ',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: Text(
                    item.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                if (isSelected)
                  const Icon(Icons.check, color: Colors.orange, size: 20),
              ],
            ),
            Text(
              item.description,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Text(
              '\$${item.price.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFFC8102E),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceItem(ServiceItem item, int index, AppLocalizations t) {
    final isSelected = _selectedServiceIndex == index - 1;
    return GestureDetector(
      onTap: () => setState(() {
        _selectedServiceIndex = index - 1;
        _isServiceValid =
            _selectedServiceIndex != -1 && _commentController.text.isNotEmpty;
      }),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.orange[50] : Colors.transparent,
          border: Border.all(
            color: isSelected ? Colors.orange : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  '$index. ',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: Text(
                    item.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                if (isSelected)
                  const Icon(Icons.check, color: Colors.orange, size: 20),
              ],
            ),
            Text(
              item.description,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Text(
              '\$${item.price.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFFC8102E),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
