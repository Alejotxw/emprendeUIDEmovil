import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';
import '../../l10n/app_localizations.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String _selectedPaymentMethod =
      ''; // '' = ninguno, 'fisico' o 'transferencia'

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Consumer<CartProvider>(
      builder: (context, cartProvider, child) {
        final double subtotal = cartProvider.totalPrice;
        final double total = subtotal; // Mock sin impuestos

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(t.paymentMethod),
            backgroundColor: const Color(0xFFC8102E),
            foregroundColor: Colors.white,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  t.selectPaymentMethod,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                RadioListTile<String>(
                  title: Row(
                    children: [
                      const Icon(Icons.people),
                      const SizedBox(width: 8),
                      Text(t.physicalPayment),
                    ],
                  ),
                  value: 'fisico',
                  groupValue: _selectedPaymentMethod,
                  onChanged: (value) =>
                      setState(() => _selectedPaymentMethod = value ?? ''),
                  activeColor: Colors.orange,
                ),
                RadioListTile<String>(
                  title: Row(
                    children: [
                      const Icon(Icons.credit_card),
                      const SizedBox(width: 8),
                      Text(t.transferPayment),
                    ],
                  ),
                  value: 'transferencia',
                  groupValue: _selectedPaymentMethod,
                  onChanged: (value) =>
                      setState(() => _selectedPaymentMethod = value ?? ''),
                  activeColor: Colors.orange,
                ),
                if (_selectedPaymentMethod.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  if (_selectedPaymentMethod == 'fisico')
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          t.secureLocation,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          height: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.grey[300],
                          ),
                          child: Center(
                            child: Text(t.mapPlaceholder),
                          ), // Nueva clave
                        ),
                      ],
                    )
                  else if (_selectedPaymentMethod == 'transferencia')
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          t.transferData,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${t.bank}: Banco Nacional',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text('${t.account}: 1234-5678-9012'),
                              const SizedBox(height: 4),
                              Text('${t.idHolder}: 1234567890'),
                              const SizedBox(height: 4),
                              Text('${t.reference}: Compra en EmprendeUI'),
                            ],
                          ),
                        ),
                      ],
                    ),
                ],
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(t.subtotal, style: const TextStyle(fontSize: 16)),
                    Text(
                      '\$${subtotal.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      t.total,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '\$${total.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFC8102E),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _selectedPaymentMethod.isNotEmpty
                          ? Colors.orange
                          : Colors.grey,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: _selectedPaymentMethod.isNotEmpty
                        ? () {
                            cartProvider.clearCart();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  '${t.paymentSuccess} $_selectedPaymentMethod!',
                                ),
                                backgroundColor: Colors.green,
                              ),
                            );
                            Navigator.popUntil(
                              context,
                              ModalRoute.withName('/home'),
                            );
                          }
                        : null,
                    child: Text(
                      t.pay,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
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