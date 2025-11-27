import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/services_screen.dart';
import 'screens/chat_screen.dart';
import 'screens/history_screen.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EmprendeUIDE',
      debugShowCheckedModeBanner: false,
      home: const LoginScreen(),
      routes: {
        '/main': (context) => const MainScreen(),
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  // SOLO 3 PANTALLAS PARA LA NUEVA NAVEGACIÓN
  final List<Widget> _pages = [
    const HomeScreen(),        // 0
    const ServicesScreen(),    // 1 (crear emprendimiento)
    const ProfileScreen(),     // 2
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],

      // ----------- NUEVA NAVEGACIÓN INFERIOR -----------
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 10,
        child: SizedBox(
          height: 65,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // BOTÓN INICIO
              IconButton(
                icon: Icon(
                  Icons.home,
                  color: _currentIndex == 0 ? const Color(0xFF90063a) : Colors.grey,
                  size: 30,
                ),
                onPressed: () => setState(() => _currentIndex = 0),
              ),

              const SizedBox(width: 40), // espacio para FAB

              // BOTÓN PERFIL
              IconButton(
                icon: Icon(
                  Icons.person,
                  color: _currentIndex == 2 ? const Color(0xFF90063a) : Colors.grey,
                  size: 30,
                ),
                onPressed: () => setState(() => _currentIndex = 2),
              ),
            ],
          ),
        ),
      ),

      // BOTÓN CENTRAL (CREAR)
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFdaa520),
        child: const Icon(Icons.add, size: 32, color: Colors.white),
        onPressed: () => setState(() => _currentIndex = 1),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
