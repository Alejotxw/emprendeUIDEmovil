import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/service_model.dart';
import '../../providers/cart_provider.dart';
// 1. Asegúrate de que la ruta sea correcta según tu proyecto
import '../../screens/perfilpublico.dart'; 
import 'dart:io';

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
                Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    image: _getImageProvider(widget.service.imageUrl),
                    borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                      
                      // --- SECCIÓN DEL EMPRENDEDOR Y BOTÓN DE PERFIL ---
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Por Kevin Giraldo',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                          OutlinedButton.icon(
                            onPressed: () {
                              // Navegación al perfil público
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PerfilPublicoScreen(service: widget.service),
                                ),
                              );
                            },
                            icon: const Icon(Icons.store, size: 18),
                            label: const Text("Ver Perfil"),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFFC8102E),
                              side: const BorderSide(color: Color(0xFFC8102E)),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            ),
                          ),
                        ],
                      ),
                      // ------------------------------------------------

                      const SizedBox(height: 16),
                      Text(
                        widget.service.subtitle,
                        style: TextStyle(
                          fontSize: 16, 
                          color: Theme.of(context).brightness == Brightness.dark ? Colors.white70 : Colors.black87
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Información',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFC8102E)),
                      ),
                      const SizedBox(height: 16),
                      _buildInfoCard('Horario', 'Lun-Vie 10:00-16:00'),
                      _buildInfoCard('Ubicación', 'Dirección mock, Quito, Ecuador'),
                      const SizedBox(height: 24),
                      // --- SECCIÓN DE SERVICIOS ---
                      if (widget.service.services.isNotEmpty) ...[
                        const Text(
                          'Servicios Disponibles',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFC8102E)),
                        ),
                        const SizedBox(height: 16),
                        ...widget.service.services.asMap().entries.map((entry) => _buildServiceItem(entry.value, entry.key + 1)).toList(),
                        const SizedBox(height: 24),
                      ],
                      
                      // --- SECCIÓN DE PRODUCTOS ---
                      if (widget.service.products.isNotEmpty) ...[
                        const Text(
                          'Productos Disponibles',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFC8102E)),
                        ),
                        const SizedBox(height: 16),
                        ...widget.service.products.asMap().entries.map((entry) => _buildProductItem(entry.value, entry.key + 1)).toList(),
                        const SizedBox(height: 24),
                      ],

                      if (widget.service.services.isEmpty && widget.service.products.isEmpty)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Center(
                            child: Text('No hay servicios o productos disponibles.'),
                          ),
                        ),

                      // Botones de acción dinámicos
                      if (widget.service.services.isNotEmpty)
                        _buildServiceAction(cartProvider),
                      if (widget.service.products.isNotEmpty) ...[
                        if (widget.service.services.isNotEmpty) const SizedBox(height: 20),
                        _buildProductAction(cartProvider),
                      ],
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

  // Métodos auxiliares extraídos para limpieza visual
  Widget _buildServiceAction(CartProvider cartProvider) {
    return Column(
      children: [
        const Text('Descripción del Servicio', style: TextStyle(fontSize: 16, color: Colors.grey)),
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
            onPressed: _isServiceValid ? () {
               final selectedItem = widget.service.services[_selectedServiceIndex];
               cartProvider.addToCart(widget.service, serviceItem: selectedItem, comment: _commentController.text);
               ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Agregado al carrito')));
               _commentController.clear();
               setState(() { _selectedServiceIndex = -1; _isServiceValid = false; });
            } : null,
            child: const Text('Solicitar'),
          ),
        ),
      ],
    );
  }

  Widget _buildProductAction(CartProvider cartProvider) {
    return Column(
      children: [
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.shopping_cart),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: _isProductValid ? () {
                  final selectedItem = widget.service.products[_selectedProductIndex];
                  cartProvider.addToCart(widget.service, product: selectedItem, quantity: _productQuantity);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Producto agregado')));
                  setState(() { _selectedProductIndex = -1; _productQuantity = 1; _isProductValid = false; });
                } : null,
                label: const Text('Agregar al Carrito'),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(8)),
              child: Row(
                children: [
                  IconButton(icon: const Icon(Icons.remove), onPressed: () => setState(() => _productQuantity = _productQuantity > 1 ? _productQuantity - 1 : 1)),
                  Text('$_productQuantity', style: const TextStyle(fontWeight: FontWeight.bold)),
                  IconButton(icon: const Icon(Icons.add), onPressed: () => setState(() => _productQuantity++)),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoCard(String title, String value) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark ? Colors.grey[800] : Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(title == 'Horario' ? Icons.schedule : Icons.location_on, color: Colors.orange),
          const SizedBox(width: 8),
          Expanded(child: Text('$title: $value', style: TextStyle(fontWeight: FontWeight.w500, color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black))),
        ],
      ),
    );
  }

  Widget _buildProductItem(ProductItem item, int index) {
    final isSelected = _selectedProductIndex == index - 1;
    return GestureDetector(
      onTap: () => setState(() { _selectedProductIndex = index - 1; _isProductValid = true; _productQuantity = 1; }),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.orange[50] : Colors.transparent,
          border: Border.all(color: isSelected ? Colors.orange : (Theme.of(context).brightness == Brightness.dark ? Colors.grey[700]! : Colors.grey[300]!), width: isSelected ? 2 : 1),
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
            Text('\$${item.price.toStringAsFixed(2)}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFC8102E))),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceItem(ServiceItem item, int index) {
    final isSelected = _selectedServiceIndex == index - 1;
    return GestureDetector(
      onTap: () => setState(() { _selectedServiceIndex = index - 1; _isServiceValid = _selectedServiceIndex != -1 && _commentController.text.isNotEmpty; }),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.orange[50] : Colors.transparent,
          border: Border.all(color: isSelected ? Colors.orange : (Theme.of(context).brightness == Brightness.dark ? Colors.grey[700]! : Colors.grey[300]!), width: isSelected ? 2 : 1),
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
            Text('\$${item.price.toStringAsFixed(2)}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFC8102E))),
          ],
        ),
      ),
    );
  }


  DecorationImage? _getImageProvider(String imageUrl) {
    if (imageUrl.isEmpty || imageUrl.contains('placeholder')) {
      return const DecorationImage(
        image: AssetImage('assets/food_placeholder.png'),
        fit: BoxFit.cover,
      );
    }
    
    // Check if it is a file path
    final file = File(imageUrl);
    if (file.existsSync()) {
      return DecorationImage(
        image: FileImage(file),
        fit: BoxFit.cover,
      );
    }

    // Default to network/asset based on checking logic or generic
    if (imageUrl.startsWith('http')) {
      return DecorationImage(
        image: NetworkImage(imageUrl),
        fit: BoxFit.cover,
      );
    }
    
    return DecorationImage(
        image: AssetImage(imageUrl),
        fit: BoxFit.cover,
    );
  }
}