import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';

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
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(t.privacySecurity),
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
                        const Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            t.accountProtected, // Nueva clave en ARB
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(t.accountProtectedDescription), // Nueva clave en ARB
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Privacidad de Perfil
            Text(
              t.profilePrivacy, // Nueva clave
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            SwitchListTile(
              title: Text(t.showEmail),
              subtitle: Text(t.showEmailSubtitle),
              value: _showEmail,
              onChanged: (value) => setState(() => _showEmail = value),
              activeColor: Colors.green,
            ),
            SwitchListTile(
              title: Text(t.showPhone),
              subtitle: Text(t.showPhoneSubtitle),
              value: _showPhone,
              onChanged: (value) => setState(() => _showPhone = value),
              activeColor: Colors.green,
            ),
            const SizedBox(height: 16),
            // Compromiso de privacidad
            Text(
              t.privacyCommitment, // Nueva clave
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            // Links Política y Términos
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(t.privacyPolicy)));
                  },
                  child: Text(t.privacyPolicy),
                ),
                TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(t.termsOfUse)));
                  },
                  child: Text(t.termsOfUse),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}