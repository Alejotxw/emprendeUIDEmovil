import 'package:flutter/material.dart';
import 'edit_profile_screen.dart'; // Asegúrate de crear este archivo

class ConfigurationScreen extends StatefulWidget {
  const ConfigurationScreen({super.key});

  @override
  State<ConfigurationScreen> createState() => _ConfigurationScreenState();
}

class _ConfigurationScreenState extends State<ConfigurationScreen> {
  // Datos del perfil (editables)
  String userName = "Sebastián Chocho";
  String userPhone = "0969331762";

  // Switches de notificaciones
  bool notiGeneral = true;
  bool notiSolicitudes = true;
  bool notiPromos = true;

  // Colores de la app
  final Color primary = const Color(0xFF90063a);
  final Color accent = const Color(0xFFdaa520);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Configuraciones",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(45),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.only(left: 16, bottom: 12),
            child: const Text(
              "Personaliza tu experiencia",
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _perfilCard(),
            const SizedBox(height: 20),
            _notificacionesCard(),
            const SizedBox(height: 20),
            _aparienciaCard(),
            const SizedBox(height: 20),
            _itemSimple(
              icon: Icons.security,
              title: "Privacidad y Seguridad",
              subtitle: "Protege tu información",
            ),
            const SizedBox(height: 12),
            _itemSimple(
              icon: Icons.help,
              title: "Ayuda y Soporte",
              subtitle: "Estamos aquí para ayudarte",
            ),
            const SizedBox(height: 20),
            _footerInfo(),
          ],
        ),
      ),
    );
  }

  // ====================== TARJETA DE PERFIL ======================
  Widget _perfilCard() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 22,
                backgroundColor: Color(0xFF90063a),
                child: Text("S", style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(width: 12),
              const Text(
                "Mi perfil",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87),
              ),
              const Spacer(),
              _editButton(), // Botón funcional
            ],
          ),
          const SizedBox(height: 15),
          _perfilItem(Icons.person, "Nombre", userName),
          const SizedBox(height: 12),
          _perfilItem(Icons.call, "Teléfono", userPhone),
        ],
      ),
    );
  }

  Widget _perfilItem(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.black54),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: const TextStyle(color: Colors.grey, fontSize: 13)),
            Text(value,
                style: const TextStyle(
                    fontSize: 15, fontWeight: FontWeight.w500)),
          ],
        )
      ],
    );
  }

  // Botón Editar funcional
  Widget _editButton() {
    return GestureDetector(
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EditProfileScreen(
              currentName: userName,
              currentPhone: userPhone,
            ),
          ),
        );

        if (result != null && result is Map<String, String>) {
          setState(() {
            userName = result['name'] ?? userName;
            userPhone = result['phone'] ?? userPhone;
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: accent.withOpacity(0.25),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: accent, width: 1.5),
        ),
        child: Text(
          "Editar",
          style: TextStyle(
            color: primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // ====================== NOTIFICACIONES ======================
  Widget _notificacionesCard() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.notifications_active,
                  color: Color(0xFFdaa520), size: 26),
              SizedBox(width: 10),
              Text("Notificaciones",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black87)),
            ],
          ),
          const SizedBox(height: 18),
          _switchTile(
            title: "Notificaciones generales",
            subtitle: "Recibe actualizaciones importantes",
            value: notiGeneral,
            onChanged: (v) => setState(() => notiGeneral = v),
          ),
          const SizedBox(height: 10),
          _switchTile(
            title: "Solicitudes",
            subtitle: "Estado de tus solicitudes",
            value: notiSolicitudes,
            onChanged: (v) => setState(() => notiSolicitudes = v),
          ),
          const SizedBox(height: 10),
          _switchTile(
            title: "Ofertas y promociones",
            subtitle: "Descuentos exclusivos UIDE",
            value: notiPromos,
            onChanged: (v) => setState(() => notiPromos = v),
          ),
        ],
      ),
    );
  }

  Widget _switchTile({
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w500)),
              Text(subtitle,
                  style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
        ),
        Switch(
          value: value,
          activeColor: Colors.white,
          activeTrackColor: accent,
          onChanged: onChanged,
        )
      ],
    );
  }

  // ====================== APARIENCIA ======================
  Widget _aparienciaCard() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.nights_stay, color: Colors.black87),
              SizedBox(width: 10),
              Text("Apariencia",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black87)),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text("Modo Oscuro",
                  style: TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w500)),
              Text("Próximamente disponible",
                  style: TextStyle(color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              const Icon(Icons.language, color: Colors.black54),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Idioma",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: const Text("Español"),
                  )
                ],
              )
            ],
          )
        ],
      ),
    );
  }

  // ====================== ITEM SIMPLE ======================
  Widget _itemSimple({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return _card(
      child: Row(
        children: [
          Icon(icon, color: primary, size: 26),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold)),
                Text(subtitle,
                    style:
                        const TextStyle(color: Colors.grey, fontSize: 13)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
    );
  }

  // ====================== FOOTER ======================
  Widget _footerInfo() {
    return Column(
      children: const [
        Text(
          "EmprendeUIDE v1.0\nMarketplace estudiantil oficial\nUniversidad Internacional del Ecuador",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.black54, fontSize: 12),
        ),
        SizedBox(height: 10),
        Text("© 2025 UIDE. Todos los derechos reservados.",
            style: TextStyle(color: Colors.grey, fontSize: 11)),
      ],
    );
  }

  // ====================== CARD BASE ======================
  Widget _card({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            blurRadius: 6,
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: child,
    );
  }
}