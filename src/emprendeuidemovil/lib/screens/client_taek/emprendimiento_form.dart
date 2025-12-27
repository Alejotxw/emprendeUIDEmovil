import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart'; // Import generado

class CrearEmprendimientoScreen extends StatefulWidget {
  const CrearEmprendimientoScreen({super.key});

  @override
  State<CrearEmprendimientoScreen> createState() =>
      _CrearEmprendimientoScreenState();
}

class _CrearEmprendimientoScreenState extends State<CrearEmprendimientoScreen> {
  final TextEditingController nombreCtrl = TextEditingController();
  final TextEditingController descripcionCtrl = TextEditingController();
  final TextEditingController ubicacionCtrl = TextEditingController();
  final TextEditingController horarioCtrl = TextEditingController();

  final TextEditingController servicioNombreCtrl = TextEditingController();
  final TextEditingController servicioDescripcionCtrl = TextEditingController();
  final TextEditingController servicioPrecioCtrl = TextEditingController();

  final List<Map<String, dynamic>> servicios = [];
  String categoria = "Comida";

  final primaryColor = const Color(0xFF90063a);
  final buttonColor = const Color(0xFFdaa520);

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!; // Traducciones

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          t.basicInformation,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _title(t.businessName),
            _input(nombreCtrl, t.exampleBusiness),

            const SizedBox(height: 20),
            _title(t.category),
            Wrap(
              spacing: 12,
              children: [
                _categoriaChip(t.food, Icons.restaurant),
                _categoriaChip(t.design, Icons.brush),
                _categoriaChip(t.technology, Icons.computer),
                _categoriaChip(t.crafts, Icons.handyman),
              ],
            ),

            const SizedBox(height: 20),
            _title(t.description),
            _textarea(descripcionCtrl, t.describeYourBusiness),

            const SizedBox(height: 20),
            _title(t.location),
            _input(ubicacionCtrl, t.exampleLocation),

            const SizedBox(height: 20),
            _title(t.schedule),
            _input(horarioCtrl, t.exampleSchedule),

            const SizedBox(height: 25),
            _title("${t.servicesProducts} (${servicios.length} ${t.services})"),

            const SizedBox(height: 10),
            ..._buildServicios(t),

            const SizedBox(height: 20),
            _agregarServicioBox(t),

            const SizedBox(height: 30),
            _botonPrincipal(
              text: t.createBusiness,
              onPressed: () => _onCrearEmprendimiento(t),
            ),
          ],
        ),
      ),
    );
  }

  void _onCrearEmprendimiento(AppLocalizations t) {
    final List<String> errores = [];

    if (nombreCtrl.text.trim().isEmpty) errores.add(t.businessName);
    if (descripcionCtrl.text.trim().isEmpty) errores.add(t.description);
    if (ubicacionCtrl.text.trim().isEmpty) errores.add(t.location);
    if (horarioCtrl.text.trim().isEmpty) errores.add(t.schedule);
    if (servicios.isEmpty) errores.add(t.atLeastOneService);

    if (errores.isNotEmpty) {
      _mostrarErroresValidacion(errores);
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(t.businessCreated)));
  }

  void _mostrarErroresValidacion(List<String> errores) {
    final mensaje =
        "Faltan los siguientes campos: ${errores.join(', ')}"; // Podrías también traducir "Faltan los siguientes campos" en ARB
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje), backgroundColor: Colors.red),
    );
  }

  // ------------------------ WIDGETS ------------------------
  Widget _title(String t) => Text(
    t,
    style: TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.bold,
      color: primaryColor,
    ),
  );

  Widget _input(TextEditingController ctrl, String hint) {
    return TextField(
      controller: ctrl,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _textarea(TextEditingController ctrl, String hint) {
    return TextField(
      controller: ctrl,
      maxLines: 4,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _categoriaChip(String text, IconData icon) {
    return ChoiceChip(
      labelPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      avatar: Icon(icon, size: 18),
      label: Text(text),
      selected: categoria == text,
      selectedColor: primaryColor.withOpacity(0.1),
      backgroundColor: Colors.grey[200],
      labelStyle: TextStyle(
        color: categoria == text ? primaryColor : Colors.black,
      ),
      onSelected: (_) => setState(() => categoria = text),
    );
  }

  List<Widget> _buildServicios(AppLocalizations t) {
    if (servicios.isEmpty) {
      return [
        Text(t.noServicesYet, style: const TextStyle(color: Colors.grey)),
        const SizedBox(height: 10),
      ];
    }

    return servicios.asMap().entries.map((entry) {
      final i = entry.key;
      final s = entry.value;

      return Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: primaryColor,
            child: Text(
              "${i + 1}",
              style: const TextStyle(color: Colors.white),
            ),
          ),
          title: Text(s["nombre"]),
          subtitle: Text("${s["descripcion"]}\n\$${s["precio"]}"),
          trailing: IconButton(
            icon: const Icon(Icons.close, color: Colors.red),
            onPressed: () => setState(() => servicios.removeAt(i)),
          ),
        ),
      );
    }).toList();
  }

  Widget _agregarServicioBox(AppLocalizations t) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3D6),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            t.addNewService,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          _input(servicioNombreCtrl, t.serviceName),
          const SizedBox(height: 10),
          _input(servicioDescripcionCtrl, t.shortDescription),
          const SizedBox(height: 10),
          _input(servicioPrecioCtrl, t.priceExample),
          const SizedBox(height: 10),
          _botonPrincipal(
            text: t.addService,
            onPressed: () => _onAgregarServicio(t),
          ),
        ],
      ),
    );
  }

  void _onAgregarServicio(AppLocalizations t) {
    final nombre = servicioNombreCtrl.text.trim();
    final precio = servicioPrecioCtrl.text.trim();

    if (nombre.isEmpty || precio.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(t.serviceNamePriceRequired),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final existeDuplicado = servicios.any(
      (s) => s["nombre"].toString().toLowerCase() == nombre.toLowerCase(),
    );
    if (existeDuplicado) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(t.duplicateService),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      servicios.add({
        "nombre": nombre,
        "descripcion": servicioDescripcionCtrl.text.trim(),
        "precio": precio,
      });
    });

    servicioNombreCtrl.clear();
    servicioDescripcionCtrl.clear();
    servicioPrecioCtrl.clear();
  }

  Widget _botonPrincipal({
    required String text,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(text),
      ),
    );
  }
}
