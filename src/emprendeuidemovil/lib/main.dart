import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Importa tus providers
import 'providers/user_role_provider.dart';
import 'providers/service_provider.dart';
import 'providers/cart_provider.dart';

// Importa tus pantallas
import 'widgets/bottom_navigation.dart';
import 'screens/login_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserRoleProvider()),
        ChangeNotifierProvider(create: (_) => ServiceProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: MaterialApp(
        title: 'Emprende UIDE',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: const Color(0xFFC8102E),
          useMaterial3: true,
        ),
        // Entramos directo al contenido principal
        home: const BottomNavigation(), 
        routes: {
          '/login': (context) => const LoginScreen(),
          '/main': (context) => const BottomNavigation(),
        },
      ),
    );
  }
}