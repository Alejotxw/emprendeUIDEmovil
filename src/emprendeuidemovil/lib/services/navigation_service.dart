import 'package:flutter/material.dart';
import '../screens/client_taek/home_screen.dart';
import '../screens/client_taek/favorites_screen.dart';
import '../screens/client_taek/cart_screen.dart';
import '../screens/client_taek/profile_screen.dart';

class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static final Map<String, WidgetBuilder> routes = {
    '/home': (context) => const HomeScreen(),
    '/favorites': (context) => const FavoritesScreen(),
    '/cart': (context) => const CartScreen(),
    '/profile': (context) => const ProfileScreen(),
  };

  static void goTo(String route) {
    navigatorKey.currentState?.pushNamed(route);
  }
}