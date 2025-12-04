import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/services_screen.dart';
import 'screens/history_screen.dart';
import 'screens/chat_screen.dart';
import 'screens/register_screen.dart';
import 'screens/notifications_screen.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  // Manejo opcional de notificaciones en segundo plano
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EmprendeUIDE',
      debugShowCheckedModeBanner: false,

      initialRoute: '/login',

      routes: {
        '/': (context) => const LoginScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/main': (context) => const MainScreen(),
        '/home': (context) => const HomeScreen(),
        '/services': (context) => const ServicesScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/history': (context) => const HistoryScreen(),
        '/chat': (context) => const ChatScreen(),

        // Más adelante aquí agregaremos '/notifications'
        '/notifications': (context) => const NotificationsScreen(),
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

  final List<Widget> _pages = [
    const HomeScreen(),
    const ServicesScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        elevation: 20,
        selectedItemColor: const Color(0xFF90063a),
        unselectedItemColor: Colors.grey.shade600,
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 12,
        unselectedFontSize: 11,
        onTap: (index) => setState(() => _currentIndex = index),
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home, size: 28),
            activeIcon: const Icon(
              Icons.home,
              size: 30,
              color: Color(0xFF90063a),
            ),
            label: "Inicio",
          ),
          BottomNavigationBarItem(
            icon: Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: Color(0xFFdaa520),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(Icons.add, color: Colors.white, size: 32),
            ),
            label: "Crear",
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person, size: 28),
            activeIcon: const Icon(
              Icons.person,
              size: 30,
              color: Color(0xFF90063a),
            ),
            label: "Perfil",
          ),
        ],
      ),
    );
  }
}
