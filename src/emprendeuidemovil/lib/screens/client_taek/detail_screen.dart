import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/service_model.dart';
import '../../providers/cart_provider.dart';

class DetailScreen extends StatefulWidget {
  final ServiceModel service;

  const DetailScreen({super.key, required this.service});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  int _selectedServiceIndex = -1;  // Para selección de servicio ( -1 = ninguno)
  int _selectedProductIndex = -1;  // Para selección de producto ( -1 = ninguno)
  int _productQuantity = 1;  // Contador para cantidad de producto seleccionado (inicia en 1)
  final TextEditingController _commentController = TextEditingController();  // Para servicios
  bool _isServiceValid = false;  // Validación para servicios (selección + comentario)
  bool _isProductValid = false;  // Validación para productos (selección)

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                // Imagen principal (placeholder; ajusta a tu asset)
                Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    image: const DecorationImage(
                      image: AssetImage('assets/food_placeholder.png'),  // Agrega imagen de comida
                      fit: BoxFit.cover,
                    ),
                    borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Título y chip
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              widget.service.name,
                              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Chip(
                            label: Text(widget.service.category),
                            backgroundColor: Colors.orange[100],
                            labelStyle: const TextStyle(color: Color(0xFFC8102E)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Por Kevin Giraldo',  // Mock
                        style: const TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      const SizedBox(height: 16),
                      // Descripción
                      Text(
                        widget.service.subtitle,
                        style: const TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                      const SizedBox(height: 24),
                      // Información
                      const Text(
                        'Información',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFC8102E)),
                      ),
                      const SizedBox(height: 16),
                      _buildInfoCard('Horario', 'Lun-Vie 10:00-16:00'),
                      _buildInfoCard('Ubicación', 'Dirección mock, Quito, Ecuador'),
                      // Mapa placeholder
                      Container(
                        height: 150,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.grey[300],
                        ),
                        child: const Center(child: Text('Mapa Placeholder')),
                      ),
                      const SizedBox(height: 24),
                      // Servicios o Productos
                      Text(
                        widget.service.isService ? 'Servicios Disponibles' : 'Productos Disponibles',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFC8102E)),
                      ),
                      const SizedBox(height: 16),
                      if (widget.service.isService && widget.service.services.isNotEmpty)
                        ...widget.service.services.asMap().entries.map((entry) => _buildServiceItem(entry.value, entry.key + 1)).toList()
                      else if (widget.service.isService)
                        const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text('No hay servicios disponibles en este momento.'),
                        )
                      else if (widget.service.products.isNotEmpty)
                        ...widget.service.products.asMap().entries.map((entry) => _buildProductItem(entry.value, entry.key + 1)).toList()
                      else
                        const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text('No hay productos disponibles en este momento.'),
                        ),
                      const SizedBox(height: 24),
                      // Para servicios: TextField descripción + Botón Solicitar
                      if (widget.service.isService)
                        Column(
                          children: [
                            const Text(
                              'Descripción del Servicio',
                              style: TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller: _commentController,
                              decoration: InputDecoration(
                                hintText: 'Describe lo que necesitas...',
                                border: const OutlineInputBorder(),
                                filled: true,
                                fillColor: Colors.grey[50],
                              ),
                              maxLines: 3,
                              onChanged: (value) => setState(() => _isServiceValid = _selectedServiceIndex != -1 && value.isNotEmpty),
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                ),
                                onPressed: _isServiceValid
                                    ? () {
                                        final selectedItem = widget.service.services[_selectedServiceIndex];
                                        cartProvider.addToCart(
                                          widget.service,
                                          serviceItem: selectedItem,
                                          comment: _commentController.text,
                                        );
                                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Servicio solicitado y agregado al carrito')));
                                        _commentController.clear();
                                        setState(() {
                                          _selectedServiceIndex = -1;
                                          _isServiceValid = false;
                                        });
                                      }
                                    : null,
                                child: const Text('Solicitar'),
                              ),
                            ),
                          ],
                        ),
                      // Para productos: Lista con selección única + Contador y Botón al Lado
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
                                        padding: const EdgeInsets.symmetric(vertical: 16),
                                      ),
                                      onPressed: _isProductValid
                                          ? () {
                                              final selectedItem = widget.service.products[_selectedProductIndex];
                                              cartProvider.addToCart(
                                                widget.service,
                                                product: selectedItem,
                                                quantity: _productQuantity,
                                              );
                                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Producto agregado al carrito ($_productQuantity)')));
                                              setState(() {
                                                _selectedProductIndex = -1;
                                                _productQuantity = 1;
                                                _isProductValid = false;
                                              });
                                            }
                                          : null,
                                      label: Text('Agregar al Carrito'),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  // Contador + / - al lado del botón
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.remove, size: 20),
                                          onPressed: () => setState(() => _productQuantity = _productQuantity > 1 ? _productQuantity - 1 : 1),
                                        ),
                                        Text('$_productQuantity', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                        IconButton(
                                          icon: const Icon(Icons.add, size: 20),
                                          onPressed: () => setState(() => _productQuantity++),
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
          Icon(title == 'Horario' ? Icons.schedule : Icons.location_on, color: Colors.orange),
          const SizedBox(width: 8),
          Expanded(child: Text('$title: $value', style: const TextStyle(fontWeight: FontWeight.w500))),
        ],
      ),
    );
  }

  Widget _buildProductItem(ProductItem item, int index) {
    final isSelected = _selectedProductIndex == index - 1;  // 0-based index
    return GestureDetector(
      onTap: () => setState(() {
        _selectedProductIndex = index - 1;
        _isProductValid = true;  // Habilita botón al seleccionar
        _productQuantity = 1;  // Resetea contador al seleccionar nuevo
      }),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.orange[50] : Colors.transparent,  // Naranja clarito al seleccionar
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
                Text('$index. ', style: const TextStyle(fontWeight: FontWeight.bold)),
                Expanded(child: Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold))),
                if (isSelected) const Icon(Icons.check, color: Colors.orange, size: 20),
              ],
            ),
            Text(item.description, style: const TextStyle(fontSize: 14, color: Colors.grey)),
            const SizedBox(height: 8),
            Text('\$${item.price.toStringAsFixed(2)}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFC8102E))),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceItem(ServiceItem item, int index) {
    final isSelected = _selectedServiceIndex == index - 1;
    return GestureDetector(
      onTap: () => setState(() {
        _selectedServiceIndex = index - 1;
        _isServiceValid = _selectedServiceIndex != -1 && _commentController.text.isNotEmpty;
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
                Text('$index. ', style: const TextStyle(fontWeight: FontWeight.bold)),
                Expanded(child: Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold))),
                if (isSelected) const Icon(Icons.check, color: Colors.orange, size: 20),
              ],
            ),
            Text(item.description, style: const TextStyle(fontSize: 14, color: Colors.grey)),
            const SizedBox(height: 8),
            Text('\$${item.price.toStringAsFixed(2)}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFC8102E))),
          ],
        ),
      ),
    );
  }
}