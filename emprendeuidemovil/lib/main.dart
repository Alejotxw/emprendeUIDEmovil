import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/services_screen.dart';
import 'screens/chat_screen.dart';
import 'screens/history_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EmprendeUIDE',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[50],
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedItemColor: Colors.purple,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed, // Para 5 items sin scroll
          backgroundColor: Colors.white,
          elevation: 8,
        ),
      ),
      home: const MainScreen(), // Nueva pantalla principal con navegación
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0; // Índice de la página actual (inicia en Inicio)

  // Lista de páginas (5 diferentes, mapeadas a las nuevas etiquetas)
final List<Widget> _pages = [
  const HomeScreen(),      // 0. Inicio
  const HistoryScreen(),   // 1. Explorar (nueva pantalla)
  const ServicesScreen(),   // 2. Servicios
  const ChatScreen(),  // 3. Chat
  const ProfileScreen(),   // 4. Perfil
];

  // Íconos y etiquetas actualizados según la imagen
  final List<BottomNavigationBarItem> _navItems = [
    const BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: 'Inicio',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.search), // Lupa en cuadrado (search)
      label: 'Explorar',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.work), // Maletín (briefcase) para servicios
      label: 'Servicios',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.chat_bubble_outline), // Burbuja de chat
      label: 'Chat',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.person),
      label: 'Perfil',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack( // Mantiene el estado de cada página
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Cambia página al tocar
          });
        },
        items: _navItems,
        type: BottomNavigationBarType.fixed, // Fijo para 5 items
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedFontSize: 12,
        unselectedFontSize: 12,
      ),
    );
  }
}