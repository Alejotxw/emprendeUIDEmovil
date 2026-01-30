import 'package:flutter/material.dart';

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
  final TextEditingController servicioDescripcionCtrl =
      TextEditingController();
  final TextEditingController servicioPrecioCtrl = TextEditingController();

  final List<Map<String, dynamic>> servicios = [];
  String categoria = "Comida";

  final primaryColor = const Color(0xFF90063a);
  final buttonColor = const Color(0xFFdaa520);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Información Básica",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _title("Nombres del Emprendimiento"),
            _input(nombreCtrl, "Ej. Delicias Caseras"),

            const SizedBox(height: 20),
            _title("Categoría"),

            Wrap(
              spacing: 12,
              children: [
                _categoriaChip("Comida", Icons.restaurant),
                _categoriaChip("Diseño", Icons.brush),
                _categoriaChip("Tecnología", Icons.computer),
                _categoriaChip("Artesanías", Icons.handyman),
              ],
            ),

            const SizedBox(height: 20),
            _title("Descripción"),
            _textarea(descripcionCtrl, "Describe tu emprendimiento"),

            const SizedBox(height: 20),
            _title("Ubicación"),
            _input(ubicacionCtrl, "Ej. Campus Quito"),

            const SizedBox(height: 20),
            _title("Horario de Atención"),
            _input(horarioCtrl, "Ej. Lun-Vie 9:00-17:00"),

            const SizedBox(height: 25),
            _title("Servicios / Productos (${servicios.length} Servicios)"),

            const SizedBox(height: 10),
            ..._buildServicios(),

            const SizedBox(height: 20),
            _agregarServicioBox(),

            const SizedBox(height: 30),
            _botonPrincipal(
              text: "Crear Emprendimiento",
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Emprendimiento creado")),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // ------------------------ WIDGETS ------------------------

  Widget _title(String t) => Text(
        t,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: Color(0xFF90063a),
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

  List<Widget> _buildServicios() {
    if (servicios.isEmpty) {
      return [
        const Text(
          "No has agregado servicios aún.",
          style: TextStyle(color: Colors.grey),
        ),
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
            child: Text("${i + 1}",
                style: const TextStyle(color: Colors.white)),
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

  Widget _agregarServicioBox() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3D6),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Agregar nuevo servicio:",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          _input(servicioNombreCtrl, "Nombre del servicio"),
          const SizedBox(height: 10),
          _input(servicioDescripcionCtrl, "Descripción breve"),
          const SizedBox(height: 10),
          _input(servicioPrecioCtrl, "Precio (Ej: \$5.00)"),

          const SizedBox(height: 10),

          _botonPrincipal(
            text: "Agregar Servicio",
            onPressed: () {
              if (servicioNombreCtrl.text.isEmpty ||
                  servicioPrecioCtrl.text.isEmpty) return;

              setState(() {
                servicios.add({
                  "nombre": servicioNombreCtrl.text,
                  "descripcion": servicioDescripcionCtrl.text,
                  "precio": servicioPrecioCtrl.text,
                });
              });

              servicioNombreCtrl.clear();
              servicioDescripcionCtrl.clear();
              servicioPrecioCtrl.clear();
            },
          )
        ],
      ),
    );
  }

  Widget _botonPrincipal({required String text, required VoidCallback onPressed}) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFdaa520),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Text(text),
      ),
    );
  }
}