import 'package:flutter/material.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import '../../providers/order_provider.dart';

class DetalleSolicitudScreen extends StatefulWidget {
  final String title;
  final String requesterName;
  final String tag;
  final List<Map<String, String>> items;
  final String paymentMethod; // 'fisico' or 'transferencia'
  final String description;
  final String? transferReceiptPath;

   final bool isProduct;
 
   const DetalleSolicitudScreen({
     super.key,
     required this.title,
     required this.requesterName,
     required this.tag,
     required this.items,
     this.paymentMethod = 'fisico', 
     this.description = '',
     this.isProduct = false,
     this.transferReceiptPath,
   });

  // Helper to generate a consistent chat ID. 
  // Ideally, 'title' would be the order ID (e.g., 'Pedido: ORD-2024-101'). 
  // If not, we fallback to title, which might collide if titles aren't unique.
  // We assume 'title' for orders is "Pedido: ID".
  String get _chatId {
      if (title.startsWith("Pedido: ")) {
          // Extract ID part: "Pedido: ORD-..." -> "order-ORD-..."
          // The title is "Pedido: ${order.id}"
          return 'order-${title.replaceAll("Pedido: ", "")}';
      }
      return 'service-${title.hashCode}'; // Fallback for pure services not yet orders?
  }

  @override
  State<DetalleSolicitudScreen> createState() => _DetalleSolicitudScreenState();
}

class _DetalleSolicitudScreenState extends State<DetalleSolicitudScreen> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF121212) : Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ... (Header code remains safely implicitly here if just viewing context, but since we are replacing a chunk, we ensure continuity)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    widget.title,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFE0B2), // Light orange/yellow
                    borderRadius: BorderRadius.circular(20),
                  ),
                   child: Text(
                     widget.isProduct ? 'Producto' : 'Servicio',
                     style: const TextStyle(
                       color: Color(0xFFFFA600),
                       fontWeight: FontWeight.bold,
                       fontSize: 14,
                       ),
                   ),
                 ),
              ],
            ),
            
            const SizedBox(height: 4),
            Text(
              'Pedido por  ${widget.requesterName}',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 24),
             Center(
               child: Text(
                 widget.isProduct ? 'Producto Elegido' : 'Servicio Elegido',
                 style: TextStyle(
                   fontSize: 16,
                   fontWeight: FontWeight.bold,
                   decoration: TextDecoration.underline,
                   color: Theme.of(context).brightness == Brightness.dark ? Colors.white : const Color(0xFF001F54),
                 ),
               ),
             ),
            const SizedBox(height: 16),

            // Items List
            ...widget.items.map((item) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF1E1E1E) : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFF83002A), width: 1.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['name'] ?? '',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item['detail'] ?? '',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF83002A),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '\$${item['price']}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),

            const SizedBox(height: 24),
            Text(
              'Metodo de Pago',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 12),

            // Payment Methods
            _buildPaymentMethodCard(
              icon: Icons.people_outline, 
              text: 'Pago en fisico',
              isSelected: widget.paymentMethod == 'fisico',
              isCustomIcon: true, 
            ),
            const SizedBox(height: 12),
            _buildPaymentMethodCard(
              icon: Icons.account_balance_wallet_outlined, 
              text: 'Pago por tranferencia',
              isSelected: widget.paymentMethod == 'transferencia',
              isCustomIcon: false,
            ),

            if (widget.paymentMethod == 'transferencia' && widget.transferReceiptPath != null) ...[
              const SizedBox(height: 20),
              Text(
                'Comprobante de Pago',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (_) => Dialog(
                      child: InteractiveViewer(
                        child: Image.file(
                          File(widget.transferReceiptPath!),
                        ),
                      ),
                    ),
                  );
                },
                child: Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.grey[200],
                    image: DecorationImage(
                      image: FileImage(File(widget.transferReceiptPath!)),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ],

            const SizedBox(height: 24),
            Text(
              'Descripción',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.description.isNotEmpty ? widget.description : 'Sin descripción adicional.',
              style: const TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 30),

             // --- Ubicación de entrega ---
            Text(
              'Ubicación de entrega',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF1E1E1E) : Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade700 : Colors.grey.shade400),
              ),
              child: Row(
                children: [
                  const Icon(Icons.location_on, color: Color(0xFF83002A)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "Sede Loja Universidad Internacional del Ecuador",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // --- Fecha y Hora de Entrega ---
            Text(
              "Fecha y Hora de Entrega",
              style: TextStyle(
                fontSize: 16, 
                fontWeight: FontWeight.bold,
                color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2101),
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: const ColorScheme.light(
                                primary: Color(0xFF83002A),
                                onPrimary: Colors.white,
                                onSurface: Colors.black,
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );
                      if (picked != null) {
                        setState(() {
                          _selectedDate = picked;
                        });
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF1E1E1E) : Colors.white,
                        border: Border.all(color: Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade700 : Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today, size: 20, color: Color(0xFF83002A)),
                          const SizedBox(width: 8),
                          Text(
                            _selectedDate != null 
                              ? "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}" 
                              : "Fecha",
                             style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      final TimeOfDay? picked = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                         builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: const ColorScheme.light(
                                primary: Color(0xFF83002A),
                                onPrimary: Colors.white,
                                onSurface: Colors.black,
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );
                      if (picked != null) {
                         setState(() {
                          _selectedTime = picked;
                        });
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF1E1E1E) : Colors.white,
                        border: Border.all(color: Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade700 : Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.access_time, size: 20, color: Color(0xFF83002A)),
                          const SizedBox(width: 8),
                          Text(
                            _selectedTime != null 
                              ? _selectedTime!.format(context) 
                              : "Hora",
                            style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 30),

            // Botón de Chat con Cliente
            SizedBox(
              width: double.infinity,
            ),
            const SizedBox(height: 30),

            // Actions Buttons
            if (widget.isProduct)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Para productos, al dar Enviar lo marcamos como aceptado para el flujo
                    Navigator.pop(context, 'Aceptado');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4CAF50), // Verde
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Enviar',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            else
              Row(
                children: [
                  // --- BOTÓN RECHAZAR ---
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context, 'Rechazado');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD50000), // Rojo
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        'Rechazar',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(width: 16), // Espacio entre botones

                  // --- BOTÓN ACEPTAR ---
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                         // Si se seleccionó una fecha, actualizar el pedido
                         if (_selectedDate != null) {
                             // Construir fecha completa si hay hora, sino solo fecha a medianoche
                             DateTime fullDate = _selectedDate!;
                             if (_selectedTime != null) {
                               fullDate = DateTime(
                                 _selectedDate!.year,
                                 _selectedDate!.month,
                                 _selectedDate!.day,
                                 _selectedTime!.hour,
                                 _selectedTime!.minute,
                               );
                             }
                             
                             // Extraer ID de la orden del título o usar lógica de mapping si fuera posible
                             // IMPORTANTE: aquí asumimos que el widget.title tiene el formato "Pedido: ID"
                             // O mejor, necesitaremos pasar el orderId a este screen.
                             // Por ahora usemos la lógica de extracción del título que ya tenemos en _chatId pero para el ID puro
                            
                             String orderId = '';
                             if (widget.title.startsWith("Pedido: ")) {
                                orderId = widget.title.replaceAll("Pedido: ", "");
                                
                                // Actualizar en Provider
                                // Necesitamos acceso al OrderProvider aquí. 
                                // Ojo: Este screen puede ser usado para servicios que no son Orders.
                                // Verificamos si es Product/Order antes de intentar actualizar.
                                if (widget.isProduct) {
                                   try {
                                     // Importante: asegúrate de importar Provider al inicio del archivo si no está
                                      Provider.of<OrderProvider>(context, listen: false)
                                        .updateOrderDeliveryDate(orderId, fullDate);
                                   } catch (e) {
                                     print("Error updating delivery date: $e");
                                   }
                                }
                             }
                         }

                        Navigator.pop(context, 'Aceptado');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4CAF50), // Verde
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        'Aceptar',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethodCard({
    required IconData icon,
    required String text,
    required bool isSelected,
    bool isCustomIcon = false,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;
    final bgColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final borderColor = isDark ? Colors.grey.shade700 : Colors.grey.shade400;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          // Icon Box
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            child: isCustomIcon 
              ? Icon(Icons.handshake_outlined, size: 30, color: textColor)
              : Icon(Icons.payments_outlined, size: 30, color: textColor),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ),
          // Radio Circle
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: textColor,
                width: 2,
              ),
            ),
            padding: const EdgeInsets.all(3),
            child: isSelected
                ? Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: textColor,
                    ),
                  )
                : null,
          ),
        ],
      ),
    );
  }


}
