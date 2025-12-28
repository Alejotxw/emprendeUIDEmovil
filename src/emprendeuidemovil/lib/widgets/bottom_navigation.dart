import 'package:flutter/material.dart';
import '../screens/client_taek/home_screen.dart';
import '../screens/client_taek/favorites_screen.dart';
import '../screens/client_taek/cart_screen.dart';
import '../screens/client_taek/profile_screen.dart';
import '../l10n/app_localizations.dart';

class BottomNavigation extends StatefulWidget {
  final VoidCallback toggleTheme;     // Para cambiar tema claro/oscuro
  final Function(Locale) setLocale;   // Para cambiar idioma

  const BottomNavigation({
    super.key,
    required this.toggleTheme,
    required this.setLocale,
  });

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _currentIndex = 0;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      HomeScreen(toggleTheme: widget.toggleTheme),       // ← Pasa toggleTheme
      const FavoritesScreen(),
      const CartScreen(),
      ProfileScreen(setLocale: widget.setLocale),       // ← Pasa setLocale
    ];
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home_outlined),
            activeIcon: const Icon(Icons.home),
            label: t.dashboard,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.favorite_border),
            activeIcon: const Icon(Icons.favorite),
            label: t.favorites,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.shopping_cart_outlined),
            activeIcon: const Icon(Icons.shopping_cart),
            label: t.cart,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person_outline),
            activeIcon: const Icon(Icons.person),
            label: t.profile,
          ),
        ],
      ),
    );
  }
}