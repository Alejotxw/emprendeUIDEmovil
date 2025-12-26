import 'package:flutter/material.dart';

class PrivacyScreen extends StatefulWidget {
  const PrivacyScreen({super.key});

  @override
  State<PrivacyScreen> createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends State<PrivacyScreen> {
  bool _showEmail = true;
  bool _showPhone = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Privacidad y Seguridad'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cuenta Protegida
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.check_circle, color: Colors.green, size: 24),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text(
                            'Cuenta Protegida',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Tu cuenta está activa y protegida. Mantén tus datos seguros con nuestras recomendaciones.',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Privacidad de Perfil
            const Text(
              'Privacidad de perfil',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            SwitchListTile(
              title: const Text('Mostrar correo electrónico'),
              subtitle: const Text('Visible en tu perfil público'),
              value: _showEmail,
              onChanged: (value) => setState(() => _showEmail = value),
              activeColor: Colors.green,
            ),
            SwitchListTile(
              title: const Text('Mostrar teléfono'),
              subtitle: const Text('Visible en tu perfil público'),
              value: _showPhone,
              onChanged: (value) => setState(() => _showPhone = value),
              activeColor: Colors.green,
            ),
            const SizedBox(height: 16),
            // Compromiso de privacidad
            const Text(
              'Nos comprometemos a proteger tu privacidad y mantener tus datos seguros.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            // Links Política y Términos
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Política de Privacidad')));
                  },
                  child: const Text('Política de Privacidad'),
                ),
                TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Términos de Uso')));
                  },
                  child: const Text('Términos de Uso'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}