import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// 🔹 Localización
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';

// 🔹 Providers
import 'providers/service_provider.dart';
import 'providers/cart_provider.dart';

// 🔹 Widgets
import 'widgets/bottom_navigation.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ServiceProvider()),
        ChangeNotifierProvider(create: (context) => CartProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      // 🔹 Título (puede traducirse luego)
      title: 'Servicio App Cliente',

      // 🔹 TEMA (no se toca)
      theme: ThemeData(
        primarySwatch: Colors.red,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFC8102E),
          foregroundColor: Colors.white,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedItemColor: Color(0xFFC8102E),
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
        ),
      ),

      // ===============================
      // 🔹 LOCALIZACIÓN (LO IMPORTANTE)
      // ===============================
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      supportedLocales: const [
        Locale('es'),
        Locale('en'),
      ],

      // 🔹 Fallback si el idioma no existe (ej. francés)
      localeResolutionCallback: (locale, supportedLocales) {
        for (final supported in supportedLocales) {
          if (supported.languageCode == locale?.languageCode) {
            return supported;
          }
        }
        return const Locale('es'); // idioma por defecto
      },

      // 🔹 Pantalla principal (no se toca)
      home: const BottomNavigation(),
    );
  }
}
