import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:emprendeuidemovil/providers/settings_provider.dart';
import 'package:emprendeuidemovil/screens/emprendedor_taek/edit_perfil_emprendedor.dart';
import 'package:emprendeuidemovil/screens/emprendedor_taek/privacidad_seguridad.dart';
import 'package:emprendeuidemovil/screens/emprendedor_taek/ayuda_soporte.dart';

class ConfiguracionEmprendedorScreen extends StatefulWidget {
  final String currentName;
  final String currentPhone;
  final File? currentImage;

  const ConfiguracionEmprendedorScreen({
    super.key,
    this.currentName = "Sebastián Chocho",
    this.currentPhone = "096 933 1762",
    this.currentImage,
  });

  @override
  State<ConfiguracionEmprendedorScreen> createState() => _ConfiguracionEmprendedorScreenState();
}

class _ConfiguracionEmprendedorScreenState extends State<ConfiguracionEmprendedorScreen> {
  bool _notificationsEnabled = true;
  bool _solicitudesEnabled = true;

  late String _name;
  late String _phone;
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    _name = widget.currentName;
    _phone = widget.currentPhone;
    _imageFile = widget.currentImage;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          _buildTopBar(context),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                   // 1. Apariencia
                  _buildAppearanceSection(),
                  const SizedBox(height: 20),

                   // 2. Mi Perfil
                  _buildProfileSection(),
                  const SizedBox(height: 20),
                  
                  // 2. Notificaciones
                  _buildNotificationsSection(),
                  const SizedBox(height: 20),

                  // 3. Idioma
                  _buildLanguageSection(),
                   const SizedBox(height: 20),

                  // 4. Privacidad y Ayuda
                  _buildPrivacySupportSection(),
                  const SizedBox(height: 20),
                  
                  // 5. Acerca de
                  _buildAboutSection(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 50, bottom: 20, left: 16, right: 16),
      decoration: const BoxDecoration(
        color: Color(0xFF83002A),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
            onPressed: () => Navigator.pop(context, {
              'name': _name,
              'phone': _phone,
              'image': _imageFile,
            }),
          ),
          const SizedBox(width: 8),
          const Expanded(
            child: Text(
              'Configuraciones',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionContainer({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Theme.of(context).brightness == Brightness.dark ? Colors.grey[800]! : Colors.grey.shade400),
      ),
      child: child,
    );
  }

  Widget _buildProfileSection() {
    return _buildSectionContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Mi perfil",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                ),
              ),
              Container(
                 decoration: BoxDecoration(
                   color: const Color(0xFFFFF6E5),
                   borderRadius: BorderRadius.circular(20),
                   border: Border.all(color: const Color(0xFFFFA600)),
                 ),
                 child: InkWell(
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditPerfilEmprendedorScreen(
                            currentName: _name,
                             currentPhone: _phone,
                          ),
                        ),
                      );

                      if (result != null && result is Map) {
                        setState(() {
                          _name = result['name'] ?? _name;
                          _phone = result['phone'] ?? _phone;
                          if (result['image'] != null) {
                            _imageFile = result['image'];
                          }
                        });
                      }
                    },
                   child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      child: Text(
                        "Editar",
                        style: TextStyle(
                          color: Colors.black, // Keep black text on light button
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                   ),
                 ),
              )
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF83002A),
                  image: _imageFile != null
                      ? DecorationImage(
                          image: FileImage(_imageFile!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: _imageFile == null
                    ? const Icon(Icons.person, color: Colors.white, size: 30)
                    : null,
              ),
               const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Nombre", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black)),
                  Text(_name, style: const TextStyle(color: Colors.grey, fontSize: 14)),
                ],
              )
            ],
          ),
           const SizedBox(height: 16),
          Row(
            children: [
              const Icon(Icons.phone, color: Color(0xFF83002A), size: 30),
               const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Telefono", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black)),
                  Text(_phone, style: const TextStyle(color: Colors.grey, fontSize: 14)),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsSection() {
    return _buildSectionContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Notificaciones",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          // General Notifications
          Row(
             children: [
               const Icon(Icons.notifications_active, color: Color(0xFF83002A), size: 28),
               const SizedBox(width: 12),
               Expanded(
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     Text("Notificaciones generales", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black)),
                     Text("Recibe actualizaciones importantes", style: const TextStyle(color: Colors.grey, fontSize: 12)),
                   ],
                 ),
               ),
               Switch(
                  value: _notificationsEnabled,
                  activeColor: Colors.white,
                  activeTrackColor: const Color(0xFF83002A),
                  onChanged: (val) {
                    setState(() {
                      _notificationsEnabled = val;
                    });
                  },
               )
             ],
          ),
          const SizedBox(height: 16),
          // Subscriptions
           Row(
             children: [
               const Icon(Icons.edit_document, color: Color(0xFF83002A), size: 28),
               const SizedBox(width: 12),
               Expanded(
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     Text("Solicitudes", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black)),
                     Text("Estado de tus solicitudes", style: const TextStyle(color: Colors.grey, fontSize: 12)),
                   ],
                 ),
               ),
               Switch(
                  value: _solicitudesEnabled,
                  activeColor: Colors.white,
                  activeTrackColor: const Color(0xFF83002A),
                  onChanged: (val) {
                    setState(() {
                      _solicitudesEnabled = val;
                    });
                  },
               )
             ],
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageSection() {
    return _buildSectionContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.translate, color: Color(0xFF83002A), size: 28),
              SizedBox(width: 12),
              Text(
                "Idioma",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Text(
                  "Actualmente solo disponible en español",
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ),
              Container(
                 padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                 decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade800 : Colors.grey.shade200,
                   borderRadius: BorderRadius.circular(20),
                 ),
                 child: Text(
                   "Español",
                   style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black),
                 ),
              )
            ],
          )
        ],
      )
    );
  }

  Widget _buildPrivacySupportSection() {
     return _buildSectionContainer(
       child: Column(
         children: [
           // Privacy
           InkWell(
             onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PrivacidadSeguridadScreen()),
                );
             },
             child: Row(
               children: [
                 const Icon(Icons.security, color: Color(0xFF83002A), size: 32),
                 const SizedBox(width: 16),
                 Expanded(
                   child: Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Text("Privacidad y Seguridad", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black)),
                       const Text("Protege tu información", style: TextStyle(color: Colors.grey, fontSize: 14)),
                     ],
                   ),
                 ),
                 const Icon(Icons.chevron_right, color: Colors.grey),
               ],
             ),
           ),
           const Padding(
             padding: EdgeInsets.symmetric(vertical: 12),
             child: Divider(color: Colors.grey),
           ),
           // Support
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AyudaSoporteScreen()),
                );
              },
              child: Row(
               children: [
                 const Icon(Icons.info, color: Color(0xFF83002A), size: 32),
                 const SizedBox(width: 16),
                 Expanded(
                   child: Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Text("Ayuda y Soporte", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black)),
                       const Text("Estamos aquí para ayudarte", style: TextStyle(color: Colors.grey, fontSize: 14)),
                     ],
                   ),
                 ),
                 const Icon(Icons.chevron_right, color: Colors.grey),
               ],
              ),
            ),
         ],
       ),
     );
  }

  Widget _buildAboutSection() {
    return _buildSectionContainer(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           const Icon(Icons.info, color: Color(0xFF83002A), size: 32),
           const SizedBox(width: 16),
           Expanded(
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: const [
                 Text("Acerca de", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                 SizedBox(height: 8),
                 Text(
                   "EmprendeUIDE v1.0", 
                   style: TextStyle(color: Colors.grey, fontSize: 14, height: 1.5),
                 ),
                 Text(
                   "Marketplace para la Comunidad UIDE Universidad Internacional del Ecuador", 
                   style: TextStyle(color: Colors.grey, fontSize: 14, height: 1.5),
                 ),
                 SizedBox(height: 12),
                  Text(
                   "© 2025 UIDE. Todos los derechos reservados.",
                   style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold),
                 ),
               ],
             ),
           )
        ],
      ),
    );
  }
  Widget _buildAppearanceSection() {
    return _buildSectionContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.dark_mode, color: Color(0xFF83002A), size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Apariencia",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Modo Oscuro", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black)),
                    const Text("Cambiar entre tema claro y oscuro", style: TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
              ),
              Consumer<SettingsProvider>(
                builder: (context, settings, child) {
                  return Switch(
                    value: settings.darkMode,
                    activeColor: Colors.white,
                    activeTrackColor: const Color(0xFF83002A),
                    onChanged: (value) => settings.setDarkMode(value),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
