import 'package:flutter/material.dart';

class PrivacidadSeguridadScreen extends StatefulWidget {
  const PrivacidadSeguridadScreen({super.key});

  @override
  State<PrivacidadSeguridadScreen> createState() => _PrivacidadSeguridadScreenState();
}

class _PrivacidadSeguridadScreenState extends State<PrivacidadSeguridadScreen> {
  bool _showEmail = true;
  bool _showPhone = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildTopBar(context),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                   // 1. Cuenta Protegida Card
                   _buildProtectedAccountCard(),
                   const SizedBox(height: 24),

                   // 2. Privacidad de perfil
                   _buildProfilePrivacyCard(),
                   const SizedBox(height: 40),

                   // 3. Footer Text
                   const Text(
                     "TAEK se compromete a proteger tu privacidad y mantener tus datos seguros.",
                     textAlign: TextAlign.center,
                     style: TextStyle(
                       color: Colors.grey,
                       fontSize: 14,
                       height: 1.5,
                     ),
                   ),
                   const SizedBox(height: 24),
                   
                   // 4. Links
                   Row(
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: [
                       TextButton(
                         onPressed: () {},
                         child: const Text(
                           "Politica de Privacidad",
                           style: TextStyle(
                             color: Color(0xFF83002A), 
                             fontWeight: FontWeight.bold
                            ),
                         ),
                       ),
                       const Text("|", style: TextStyle(color: Color(0xFF83002A), fontWeight: FontWeight.bold)),
                       TextButton(
                         onPressed: () {},
                         child: const Text(
                           "Terminos de Uso",
                           style: TextStyle(
                             color: Color(0xFF83002A), 
                             fontWeight: FontWeight.bold
                            ),
                         ),
                       ),
                     ],
                   )

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
        color: Color(0xFF39B54A), // Green color
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 8),
          const Expanded(
            child: Text(
              'Privacidad y Seguridad',
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

  Widget _buildProtectedAccountCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFE6F7E9), // Light green
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF39B54A), width: 0.5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Container(
             padding: const EdgeInsets.all(8),
             decoration: const BoxDecoration(
               color: Color(0xFF39B54A),
               shape: BoxShape.circle,
             ),
             child: const Icon(Icons.check, color: Colors.white, size: 30),
           ),
           const SizedBox(width: 16),
           Expanded(
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: const [
                 Text(
                   "Cuenta Protegida",
                   style: TextStyle(
                     fontWeight: FontWeight.bold,
                     fontSize: 16,
                     color: Colors.black,
                   ),
                 ),
                 SizedBox(height: 8),
                 Text(
                   "Tu cuenta está activa y protegida. Mantén tus datos seguros siguiendo nuestras recomendaciones.",
                   style: TextStyle(
                     color: Colors.black87,
                     fontSize: 14,
                     height: 1.4,
                   ),
                 ),
               ],
             ),
           )
        ],
      ),
    );
  }

  Widget _buildProfilePrivacyCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Privacidad de perfil",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 24),
          // Email Switch
          Row(
            children: [
              const Icon(Icons.mail_outline, color: Color(0xFF83002A), size: 28),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text("Mostrar correo electrónico", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    Text("Visible en tu perfil público", style: TextStyle(color: Colors.grey, fontSize: 13)),
                  ],
                ),
              ),
              Switch(
                value: _showEmail,
                activeColor: Colors.white,
                activeTrackColor: const Color(0xFF83002A),
                onChanged: (val) {
                  setState(() {
                    _showEmail = val;
                  });
                },
              )
            ],
          ),
          const SizedBox(height: 20),
          // Phone Switch
          Row(
            children: [
              const Icon(Icons.phone, color: Color(0xFF83002A), size: 28),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text("Mostrar teléfono", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    Text("Visible en tu perfil público", style: TextStyle(color: Colors.grey, fontSize: 13)),
                  ],
                ),
              ),
              Switch(
                value: _showPhone,
                activeColor: Colors.white,
                activeTrackColor: const Color(0xFF83002A),
                onChanged: (val) {
                  setState(() {
                    _showPhone = val;
                  });
                },
              )
            ],
          ),
        ],
      ),
    );
  }
}