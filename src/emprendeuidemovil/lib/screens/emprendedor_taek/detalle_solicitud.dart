import 'package:flutter/material.dart';

class DetalleSolicitudScreen extends StatefulWidget {
  final String title;
  final String requesterName;
  final String tag;
  final List<Map<String, String>> items;
  final String paymentMethod; // 'fisico' or 'transferencia'
  final String description;

  const DetalleSolicitudScreen({
    super.key,
    required this.title,
    required this.requesterName,
    required this.tag,
    required this.items,
    this.paymentMethod = 'fisico', 
    this.description = '',
  });

  @override
  State<DetalleSolicitudScreen> createState() => _DetalleSolicitudScreenState();
}

class _DetalleSolicitudScreenState extends State<DetalleSolicitudScreen> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  // We can use state to manage the selected payment method if it were editable, 
  // but usually in a "Review Request" screen, this information is read-only (what the user selected).
  // However, the image shows radio buttons which seemingly could be selected by the entrepreneur 
  // OR they indicate what the customer chose. 
  // Given "Ver Solicitudes", it's likely showing what the customer requested.
  // But let's assume for now we just display what was passed or default.
  
  // Actually, looking at the UI, it looks like a selection. 
  // But usually the payer decides. Let's assume it's display-only or current status for now,
  // but implemented as visual radio selection.

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
            // Header: Title and Tag
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
                    widget.tag,
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
            // Section Title
            Center(
              child: Text(
                'Producto/Servicio Elegido',
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
              icon: Icons.people_outline, // Placeholder for handshake/people icon
              text: 'Pago en fisico',
              isSelected: widget.paymentMethod == 'fisico',
              isCustomIcon: true, // To simulate the handshake icon if possible or use standard
            ),
            const SizedBox(height: 12),
            _buildPaymentMethodCard(
              icon: Icons.account_balance_wallet_outlined, // Placeholder for tickets/money
              text: 'Pago por tranferencia',
              isSelected: widget.paymentMethod == 'transferencia',
              isCustomIcon: false,
            ),

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

            const SizedBox(height: 40),
            // Actions Buttons
            Row(
              children: [
                // --- BOTÓN RECHAZAR ---
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Enviamos 'Rechazado' para que el carrito se ponga en rojo
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
                      // AQUÍ PODRÍAS AGREGAR EL DATEPICKER ANTES DEL POP
                      // Pero lo más importante es devolver 'Aceptado'
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
