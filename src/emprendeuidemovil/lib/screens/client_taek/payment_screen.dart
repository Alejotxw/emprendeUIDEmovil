import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';
import '../client_taek/SuccessTransactionScreen.dart';
// Asegúrate de importar la nueva pantalla que creamos arriba
import '../client_taek/contact_info_screen.dart'; 

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String _selectedPaymentMethod = ''; // '' = ninguno, 'fisico' o 'transferencia'
  bool _isLoading = false; // Estado para controlar la carga

  // Función para procesar el pago
  void _handlePayment(BuildContext context, CartProvider cartProvider) async {
    // 1. Mostrar Loading
    setState(() {
      _isLoading = true;
    });

    // 2. Simular tiempo de espera (2 segundos)
    await Future.delayed(const Duration(seconds: 2));

    // 3. Limpiar carrito
    if (mounted) {
      cartProvider.clearCart();
    }

    // 4. Navegación Condicional
    if (mounted) {
      if (_selectedPaymentMethod == 'transferencia') {
        // Ir a pantalla de Éxito (Transferencia)
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SuccessTransactionScreen()),
        );
      } else if (_selectedPaymentMethod == 'fisico') {
        // Ir a pantalla de Contacto (Físico)
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ContactInfoScreen()),
        );
      }
      
      // Ocultar loading (por seguridad, aunque ya habremos navegado)
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cartProvider, child) {
        final double subtotal = cartProvider.totalPrice;
        final double total = subtotal; // Mock sin impuestos

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              // Deshabilitar botón atrás si está cargando
              onPressed: _isLoading ? null : () => Navigator.pop(context),
            ),
            title: const Text('Método de Pago'),
            backgroundColor: const Color(0xFF83002A),
            foregroundColor: Colors.white,
          ),
          body: Stack(
            children: [
              // --- CAPA 1: Contenido Principal ---
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Selección de método de pago
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
                      // Deshabilitar cambio si está cargando
                      onChanged: _isLoading ? null : (value) => setState(() => _selectedPaymentMethod = value ?? ''),
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
                      onChanged: _isLoading ? null : (value) => setState(() => _selectedPaymentMethod = value ?? ''),
                      activeColor: Colors.orange,
                    ),
                    
                    // Contenido condicional por método seleccionado
                    if (_selectedPaymentMethod.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      if (_selectedPaymentMethod == 'fisico')
                        Expanded( // Usar Expanded para que el mapa ocupe espacio disponible si es necesario
                          child: SingleChildScrollView(
                            child: Column(
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
                            ),
                          ),
                        )
                      else if (_selectedPaymentMethod == 'transferencia')
                         Expanded(
                           child: SingleChildScrollView(
                             child: Column(
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
                           ),
                         ),
                    ] else 
                      const Spacer(), // Empujar contenido si no hay nada seleccionado

                    if (_selectedPaymentMethod.isEmpty) const Spacer(),

                    // Subtotal y Total (siempre visibles al fondo)
                    const Divider(),
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
                    
                    // Botón Pagar Modificado
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _selectedPaymentMethod.isNotEmpty ? Colors.orange : Colors.grey,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        // Lógica: Si está cargando o no hay método, deshabilita. Si no, ejecuta _handlePayment
                          onPressed: _selectedPaymentMethod.isNotEmpty
                          ? () async {
                              cartProvider.clearCart();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('¡Pago exitoso por $_selectedPaymentMethod!'),
                                  backgroundColor: Colors.green,
                                  duration: const Duration(seconds: 2), // Solo aparece 2 segundos
                                ),
                              );
                              await Future.delayed(const Duration(seconds: 2));
                              if (mounted) {
                                // Esto limpia el stack y vuelve a la pantalla principal
                                Navigator.of(context).popUntil((route) => route.isFirst);
                              }
                            }
                          : null,
                        child: Text(_isLoading ? 'Procesando...' : 'Pagar', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),

              // --- CAPA 2: Loading Overlay ---
              if (_isLoading)
                Container(
                  color: Colors.black.withOpacity(0.5), // Fondo semitransparente
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Column(
                        mainAxisSize: MainAxisSize.min, // Ajustar al contenido
                        children: [
                          CircularProgressIndicator(
                            color: Color(0xFF83002A), // Color institucional
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Procesando tu pedido...',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
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
}