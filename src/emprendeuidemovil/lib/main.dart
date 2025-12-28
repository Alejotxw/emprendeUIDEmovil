import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/service_provider.dart';
import 'providers/cart_provider.dart';
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

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Servicio App Cliente',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFC8102E),
          brightness: Brightness.light,
        ),
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
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFC8102E),
          brightness: Brightness.dark,
        ),
        // Dark mode defaults usually create a dark background, but we can override if needed
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFC8102E), // Keep brand color or adapt
          foregroundColor: Colors.white,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedItemColor: Color(0xFFC8102E), // Visible on dark? Maybe lighten it?
          // If the background is dark, a red selected item might be hard to see or okay.
          // Let's stick to brand color or secondary. 
          // Actually, let's use the inverse primary or just red if it contrasts enough.
          // On dark surface, standard red 0xFFC8102E might be low contrast.
          // let's use a slightly lighter red or just keep it consistent for now.
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
        ),
      ),
      themeMode: _themeMode,
      home: BottomNavigation(toggleTheme: _toggleTheme),
      debugShowCheckedModeBanner: false,
    );
  }
}