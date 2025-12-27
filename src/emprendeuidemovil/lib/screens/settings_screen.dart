import 'package:flutter/material.dart';
import 'client_taek/edit_profile_screen.dart';
import 'client_taek/support_screen.dart';
import 'client_taek/privacy_screen.dart';
import '../l10n/app_localizations.dart';

class SettingsScreen extends StatefulWidget {
  final Function(Locale) setLocale; // recibe función para cambiar idioma
  const SettingsScreen({super.key, required this.setLocale});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _generalNotifications = true;
  bool _requestNotifications = false;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(t.settings),
        backgroundColor: const Color(0xFFC8102E),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Mi Perfil
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t.myProfile,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${t.nameLabel}: Sebastián Chocho',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${t.phoneLabel}: 09931762',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.edit, color: Colors.white),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditProfileScreen(),
                            ),
                          );
                        },
                        label: Text(t.edit),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Notificaciones generales
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t.generalNotifications,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SwitchListTile(
                      title: Text(t.importantUpdates),
                      value: _generalNotifications,
                      onChanged: (value) =>
                          setState(() => _generalNotifications = value),
                      activeColor: const Color(0xFFC8102E),
                    ),
                    SwitchListTile(
                      title: Text(t.requestStatus),
                      value: _requestNotifications,
                      onChanged: (value) =>
                          setState(() => _requestNotifications = value),
                      activeColor: const Color(0xFFC8102E),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Idioma
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t.language,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButton<Locale>(
                      value: Localizations.localeOf(context),
                      items: const [
                        DropdownMenuItem(
                          value: Locale('es'),
                          child: Text('Español'),
                        ),
                        DropdownMenuItem(
                          value: Locale('en'),
                          child: Text('English'),
                        ),
                      ],
                      onChanged: (locale) {
                        if (locale != null) widget.setLocale(locale);
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Privacidad y Seguridad
            Card(
              child: ListTile(
                leading: const Icon(
                  Icons.privacy_tip,
                  color: Color(0xFFC8102E),
                ),
                title: Text(t.privacySecurity),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PrivacyScreen()),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            // Ayuda y Soporte
            Card(
              child: ListTile(
                leading: const Icon(
                  Icons.help_outline,
                  color: Color(0xFFC8102E),
                ),
                title: Text(t.helpSupport),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SupportScreen()),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            // Acerca de UIDE V1
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.warning, color: Colors.red, size: 24),
                    const SizedBox(height: 8),
                    Text(
                      t.aboutUIDE,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      t.aboutUIDEDescription,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: Text(
                        t.copyright,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
