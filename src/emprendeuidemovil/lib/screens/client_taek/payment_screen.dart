import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/order_provider.dart';
import '../../models/cart_item.dart'; 
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class PaymentScreen extends StatefulWidget {
  final bool isServicePayment;
  const PaymentScreen({super.key, this.isServicePayment = false});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String _selectedPaymentMethod = '';  // '' = ninguno, 'fisico' o 'transferencia'
  File? _transferImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _transferImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cartProvider, child) {
        // CORRECCIÓN: Usamos el flag para decidir qué total mostrar
        final double subtotal = widget.isServicePayment 
            ? cartProvider.totalServicesPrice 
            : cartProvider.totalProductsPrice;
        
        final double total = subtotal;  // Mock sin impuestos

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text('Método de Pago'),
            backgroundColor: const Color(0xFFC8102E),
            foregroundColor: Colors.white,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Selección de método de pago (solo uno)
                const Text(
                  'Selecciona un método de pago',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                RadioListTile<String>(
                  title: const Row(
                    children: [
                      Icon(Icons.people),
                      SizedBox(width: 8),
                      Text('Pago en físico'),
                    ],
                  ),
                  value: 'fisico',
                  groupValue: _selectedPaymentMethod,
                  onChanged: (value) => setState(() => _selectedPaymentMethod = value ?? ''),
                  activeColor: Colors.orange,
                ),
                RadioListTile<String>(
                  title: const Row(
                    children: [
                      Icon(Icons.credit_card),
                      SizedBox(width: 8),
                      Text('Pago por transferencia'),
                    ],
                  ),
                  value: 'transferencia',
                  groupValue: _selectedPaymentMethod,
                  onChanged: (value) => setState(() => _selectedPaymentMethod = value ?? ''),
                  activeColor: Colors.orange,
                ),
                // Contenido condicional por método seleccionado
                if (_selectedPaymentMethod.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  if (_selectedPaymentMethod == 'fisico')
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Ubicación segura',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Theme.of(context).brightness == Brightness.dark ? Colors.grey[800] : Colors.grey[200],
                            border: Border.all(color: Theme.of(context).brightness == Brightness.dark ? Colors.grey[700]! : Colors.grey.shade300),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.location_on, color: Color(0xFFC8102E)),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Sede Loja Universidad Internacional del Ecuador',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  else if (_selectedPaymentMethod == 'transferencia')
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Datos para transferencia',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Banco: Banco Nacional', style: TextStyle(fontWeight: FontWeight.bold)),
                              SizedBox(height: 4),
                              Text('Cuenta: 1234-5678-9012'),
                              SizedBox(height: 4),
                              Text('C.I. Titular: 1234567890'),
                              SizedBox(height: 4),
                              Text('Referencia: Compra en EmprendeUI'),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Comprobante de Transferencia',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Center(
                          child: GestureDetector(
                            onTap: _pickImage,
                            child: Container(
                              width: double.infinity,
                              height: 200,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.grey),
                              ),
                              child: _transferImage != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.file(_transferImage!, fit: BoxFit.cover),
                                    )
                                  : Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.upload_file, size: 50, color: Colors.grey[600]),
                                        const SizedBox(height: 10),
                                        Text('Subir imagen del comprobante', style: TextStyle(color: Colors.grey[700])),
                                      ],
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
                const Spacer(),  // Empuja subtotal/total abajo
                // Subtotal y Total (siempre visibles)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Subtotal', style: TextStyle(fontSize: 16)),
                    Text('\$${subtotal.toStringAsFixed(2)}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text('\$${total.toStringAsFixed(2)}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFC8102E))),
                  ],
                ),
                const SizedBox(height: 16),
                // Botón Pagar (deshabilitado si no método)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _selectedPaymentMethod.isNotEmpty ? Colors.orange : Colors.grey,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: _selectedPaymentMethod.isNotEmpty
                        ? () async {
                            final orderProvider = Provider.of<OrderProvider>(context, listen: false);
                            final cartProvider = Provider.of<CartProvider>(context, listen: false);

                            // Determinamos qué ítems se están pagando
                            // NOTA: Usamos widget.isServicePayment para ser consistentes con lo que mostramos en UI
                            final List<CartItem> itemsAPagar = widget.isServicePayment 
                                ? List.from(cartProvider.servicios) 
                                : List.from(cartProvider.productos);

                            // Validación extra para transferencia
                            if (_selectedPaymentMethod == 'transferencia' && _transferImage == null) {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                content: Text('Por favor sube el comprobante de transferencia'),
                                backgroundColor: Colors.red,
                              ));
                              return;
                            }

                            // Guardamos el pedido (esto alimentará la pantalla de pedidos)
                            orderProvider.addOrder(
                              itemsAPagar,
                              total, // Usamos el total calculado correctamente
                              _selectedPaymentMethod,
                              transferReceiptPath: _transferImage?.path,
                            );

                            // Notificación de éxito
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              content: Text('¡Pago completado! Enviando solicitud...'),
                              backgroundColor: Colors.green,
                              duration: Duration(seconds: 2),
                            ));

                            // Limpiar solo la sección pagada
                            if (widget.isServicePayment) {
                              cartProvider.clearServices(); 
                            } else {
                              cartProvider.clearProducts();
                            }

                            await Future.delayed(const Duration(seconds: 2));
                            if (mounted) Navigator.of(context).popUntil((route) => route.isFirst);
                          }
                        : null,
                    child: Text(
                      _selectedPaymentMethod == 'fisico' ? 'Notificar' : 'Pagar',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}