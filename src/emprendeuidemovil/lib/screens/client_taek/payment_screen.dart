import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String _selectedPaymentMethod = '';  // '' = ninguno, 'fisico' o 'transferencia'

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cartProvider, child) {
        final double subtotal = cartProvider.totalPrice;
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
                          height: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.grey[300],
                          ),
                          child: const Center(child: Text('Mapa Placeholder (Integra Google Maps aquí)')),
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
                        ? () {
                            cartProvider.clearCart();  // Mock: Limpia carrito al pagar
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Pago exitoso por $_selectedPaymentMethod!'),
                              backgroundColor: Colors.green,
                            ));
                            Navigator.popUntil(context, ModalRoute.withName('/home'));  // Vuelve a home
                          }
                        : null,
                    child: const Text('Pagar', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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