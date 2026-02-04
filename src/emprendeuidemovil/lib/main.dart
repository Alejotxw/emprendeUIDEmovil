import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

// Providers
import 'providers/service_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/user_role_provider.dart';
import 'providers/dashboard_provider.dart';
import 'providers/settings_provider.dart';
import 'providers/settings_provider.dart';
import 'providers/ratings_provider.dart';
import 'providers/chat_provider.dart';
import 'providers/user_profile_provider.dart'; // Agregado

import 'providers/chat_provider.dart'; // Agregado
import 'providers/order_provider.dart'; // Agregado
import 'providers/notification_provider.dart'; // Agregado

import 'providers/user_profile_provider.dart';
import 'providers/order_provider.dart';
import 'providers/notification_provider.dart';
import 'providers/event_provider.dart';

// Pantallas modo Emprendedor
import 'screens/emprendedor_taek/solicitudes.dart';
import 'screens/emprendedor_taek/mis_emprendimientos.dart';

// Pantallas modo Cliente
import 'screens/client_taek/home_screen.dart';
import 'screens/client_taek/favorites_screen.dart';
import 'screens/client_taek/cart_screen.dart';

// Pantalla de perfil unificada y Chat
import 'screens/profile_screen.dart';
// 🔹 Localización
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';

// 🔹 Providers
import 'providers/service_provider.dart';
import 'providers/cart_provider.dart';

// 🔹 Widgets
import 'widgets/bottom_navigation.dart';
import 'screens/chat_screen.dart'; // Agregado
import 'screens/login_screen.dart';
import 'screens/admin_screen.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ServiceProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => UserRoleProvider()),
        ChangeNotifierProvider(create: (context) => ServiceProvider()),
        ChangeNotifierProvider(create: (context) => CartProvider()),
        ChangeNotifierProxyProvider<ServiceProvider, DashboardProvider>(
          create: (context) =>
              DashboardProvider(context.read<ServiceProvider>()),
          update: (context, serviceProvider, _) =>
              DashboardProvider(serviceProvider),
        ),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),

        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => RatingsProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => RatingsProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
        ChangeNotifierProvider(create: (_) => UserProfileProvider()), // Agregado
        ChangeNotifierProvider(create: (_) => ChatProvider()), // Agregado
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()), // AGREGA ESTO

        ChangeNotifierProvider(create: (_) => NotificationProvider()),
        ChangeNotifierProvider(create: (_) => EventProvider()),
      ],
      child: const MyApp(),
    ),
  );
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
      ),
      home: const MainScreen(),}
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedItemColor: Color(0xFFC8102E),
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
        ),
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
    return Consumer<SettingsProvider>(
      builder: (context, settings, child) {
        return MaterialApp(
          title: 'EmprendeUIDE',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.red,
            scaffoldBackgroundColor: Colors.white,
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFFC8102E),
              foregroundColor: Colors.white,
            ),
          ),
          darkTheme: ThemeData.dark().copyWith(
            primaryColor: const Color(0xFFC8102E),
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFFC8102E),
              foregroundColor: Colors.white,
            ),
          ),
          themeMode: settings.darkMode ? ThemeMode.dark : ThemeMode.light,
          builder: (context, child) {
            final scale = settings.largeFont ? 1.18 : 1.0;
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: TextScaler.linear(scale),
              ),
              child: child!,
            );
          },
          home: const LoginScreen(),
          routes: {
            '/login': (context) => const LoginScreen(),
            '/main': (context) => const MainScreen(),
            '/admin': (context) => const AdminScreen(),
          },
        );
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
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Consumer<UserRoleProvider>(
      builder: (context, roleProvider, child) {
        final role = roleProvider.role;
        final isCliente = role == UserRole.cliente;

        // Definición de páginas según el rol
        final List<Widget> pages = isCliente
            ? [
                const HomeScreen(),
                const FavoritesScreen(),
                const CartScreen(),
                const ProfileScreen(),
              ]
            : [
                const SolicitudesScreen(),
                const MisEmprendimientosScreen(),
                const ProfileScreen(),
              ];

        // Seguridad por si el índice queda fuera de rango al cambiar de rol
        if (_selectedIndex >= pages.length) {
          _selectedIndex = 0;
        }

        return Scaffold(
          body: IndexedStack(
            index: _selectedIndex,
            children: pages,
          ),
          bottomNavigationBar: isCliente
              ? _buildClienteBottomBar()
              : _buildEmprendedorBottomBar(),
          floatingActionButton: FloatingActionButton(
            heroTag: 'chat_fab',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ChatScreen()),
              );
            },
            backgroundColor: const Color.fromARGB(255, 127, 0, 2),
            child: const Icon(Icons.support_agent, color: Colors.white),
          ),
        );
      },
    );
  }

  // ================== BARRA CLIENTE ==================
  Widget _buildClienteBottomBar() {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : const Color(0xFFF0F0F0),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -5)),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildClienteNavItem(icon: Icons.home_outlined, index: 0),
          _buildClienteNavItem(icon: Icons.favorite_border, index: 1),
          _buildClienteNavItem(icon: Icons.shopping_cart_outlined, index: 2),
          _buildClienteNavItem(icon: Icons.person_outline, index: 3),
        ],
      ),
    );
  }

  Widget _buildClienteNavItem({required IconData icon, required int index}) {
    final bool isSelected = _selectedIndex == index;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    
    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      child: Container(
        padding: const EdgeInsets.all(12),
        child: Icon(
          icon,
          size: 30,
          color: isSelected 
              ? const Color(0xFF83002A) 
              : (isDark ? Colors.white70 : Colors.grey),
        ),
      ),
    );
  }

  // ================== BARRA EMPRENDEDOR ==================
  Widget _buildEmprendedorBottomBar() {
    const Color activeColor = Color(0xFF83002A);
    final Color inactiveColor = Theme.of(context).brightness == Brightness.dark 
        ? Colors.white70 
        : Colors.grey;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : const Color(0xFFF0F0F0),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -5)),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Solicitudes (Izquierda) - Índice 0
              GestureDetector(
                onTap: () => setState(() => _selectedIndex = 0),
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: CustomPaint(
                    key: ValueKey('solicitudes_${_selectedIndex == 0}'),
                    painter: EditNoteIconPainter(
                      color: _selectedIndex == 0 ? activeColor : inactiveColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 60),
              // Perfil (Derecha) - Índice 2
              GestureDetector(
                onTap: () => setState(() => _selectedIndex = 2),
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: CustomPaint(
                    key: ValueKey('perfil_${_selectedIndex == 2}'),
                    painter: UserIconPainter(
                      color: _selectedIndex == 2 ? activeColor : inactiveColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Botón central flotante (+) - Índice 1
          Positioned(
            top: -30,
            child: GestureDetector(
              onTap: () => setState(() => _selectedIndex = 1),
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: const Color(0xFF83002A),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF83002A).withOpacity(0.4),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(15),
                child: CustomPaint(painter: PlusIconPainter()),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ... (Aquí van tus clases PlusIconPainter, UserIconPainter y EditNoteIconPainter que ya tienes definidas)

// ==================== CUSTOM PAINTERS CORREGIDOS ====================

class PlusIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    const double svgWidth = 138;
    const double svgHeight = 135;
    final double scaleX = size.width / svgWidth;
    final double scaleY = size.height / svgHeight;
    final double scale = scaleX < scaleY ? scaleX : scaleY;

    canvas.save();
    final double translateX = (size.width - (svgWidth * scale)) / 2;
    final double translateY = (size.height - (svgHeight * scale)) / 2;
    canvas.translate(translateX, translateY);
    canvas.scale(scale);

    final path = Path();
    path.fillType = PathFillType.evenOdd;

    path.moveTo(113.287, 61.6643);
    path.lineTo(113.287, 72.4209);
    path.lineTo(74.5124, 72.4209);
    path.lineTo(74.5124, 110.069);
    path.lineTo(63.434, 110.069);
    path.lineTo(63.434, 72.4209);
    path.lineTo(24.6596, 72.4209);
    path.lineTo(24.6596, 61.6643);
    path.lineTo(63.434, 61.6643);
    path.lineTo(63.434, 24.016);
    path.lineTo(74.5124, 24.016);
    path.lineTo(74.5124, 61.6643);
    path.lineTo(113.287, 61.6643);
    path.close();

    // Completa aquí el resto de tu path original del +
    // (el que tenías antes, no lo borres)

    canvas.drawPath(path, paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class UserIconPainter extends CustomPainter {
  final Color color;

  UserIconPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color  // ← Usa el color recibido
      ..style = PaintingStyle.fill;

    const double svgWidth = 181;
    const double svgHeight = 209;
    final double scaleX = size.width / svgWidth;
    final double scaleY = size.height / svgHeight;
    final double scale = scaleX < scaleY ? scaleX : scaleY;

    canvas.save();
    final double translateX = (size.width - (svgWidth * scale)) / 2;
    final double translateY = (size.height - (svgHeight * scale)) / 2;
    canvas.translate(translateX, translateY);
    canvas.scale(scale);

    final path = Path();
    path.fillType = PathFillType.evenOdd;

    path.moveTo(141.462, 52.9084);
    path.cubicTo(141.462, 86.2961, 119.607, 114.95, 90.5049, 114.95);
    path.cubicTo(61.3799, 114.95, 39.5475, 86.2961, 39.5475, 52.8979);
    path.cubicTo(39.5475, 19.5206, 58.3451, 0, 90.5049, 0);
    path.cubicTo(122.665, 0, 141.462, 19.5102, 141.462, 52.9084);
    path.close();

    path.moveTo(1.06904, 189.584);
    path.cubicTo(5.42872, 194.37, 24.2037, 209, 90.5049, 209);
    path.cubicTo(156.806, 209, 175.57, 194.37, 179.941, 189.594);
    path.cubicTo(180.346, 189.135, 180.646, 188.605, 180.821, 188.035);
    path.cubicTo(180.996, 187.465, 181.043, 186.869, 180.96, 186.282);
    path.cubicTo(179.963, 177.065, 170.972, 135.85, 90.5049, 135.85);
    path.cubicTo(10.0375, 135.85, 1.04639, 177.065, 0.0385631, 186.282);
    path.cubicTo(-0.0434451, 186.87, 0.00566034, 187.467, 0.182868, 188.036);
    path.cubicTo(0.360077, 188.606, 0.661645, 189.126, 1.06904, 189.584);
    path.close();

    canvas.drawPath(path, paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant UserIconPainter oldDelegate) => oldDelegate.color != color;
}

class EditNoteIconPainter extends CustomPainter {
  final Color color;

  EditNoteIconPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color  // ← Ahora SÍ usa el color que le pasas
      ..style = PaintingStyle.fill;

    const double svgWidth = 204;
    const double svgHeight = 210;
    final double scaleX = size.width / svgWidth;
    final double scaleY = size.height / svgHeight;
    final double scale = scaleX < scaleY ? scaleX : scaleY;

    canvas.save();
    final double translateX = (size.width - (svgWidth * scale)) / 2;
    final double translateY = (size.height - (svgHeight * scale)) / 2;
    canvas.translate(translateX, translateY);
    canvas.scale(scale);

    final path = Path();
    path.fillType = PathFillType.evenOdd;

    // Todo tu path original del lápiz/nota (cópialo completo aquí)
    path.moveTo(13.229, 12.3015);
    path.cubicTo(-1.34607e-06, 24.6031, 0, 44.402, 0, 84);
    path.lineTo(0, 126);
    path.cubicTo(0, 165.598, -1.34607e-06, 185.397, 13.229, 197.698);
    path.cubicTo(26.4581, 210, 47.7497, 210, 90.3333, 210);
    path.lineTo(112.917, 210);
    path.cubicTo(155.5, 210, 176.792, 210, 190.021, 197.698);
    path.cubicTo(203.038, 185.594, 203.247, 166.232, 203.25, 127.891);
    path.lineTo(171.427, 157.483);
    path.cubicTo(168.38, 160.317, 165.886, 162.639, 163.069, 164.683);
    path.cubicTo(159.767, 167.077, 156.195, 169.13, 152.416, 170.805);
    path.cubicTo(149.19, 172.234, 145.842, 173.271, 141.753, 174.536);
    path.lineTo(115.65, 182.628);
    path.cubicTo(107.197, 185.247, 97.8784, 183.202, 91.5777, 177.343);
    path.cubicTo(85.2781, 171.484, 83.0773, 162.818, 85.8957, 154.958);
    path.lineTo(88.984, 146.344);
    path.lineTo(94.3487, 131.377);
    path.lineTo(94.5959, 130.686);
    path.cubicTo(95.9577, 126.884, 97.0722, 123.77, 98.609, 120.77);
    path.cubicTo(100.41, 117.256, 102.618, 113.934, 105.193, 110.865);
    path.cubicTo(107.391, 108.244, 109.887, 105.925, 112.936, 103.092);
    path.lineTo(158.175, 61.0247);
    path.lineTo(170.73, 49.3504);
    path.lineTo(172.166, 48.0146);
    path.cubicTo(180.244, 40.5028, 190.833, 36.748, 201.421, 36.75);
    path.cubicTo(199.712, 25.9292, 196.408, 18.2413, 190.021, 12.3015);
    path.cubicTo(176.792, 1.2517e-06, 155.5, 0, 112.917, 0);
    path.lineTo(90.3333, 0);
    path.cubicTo(47.7497, 0, 26.4581, 1.2517e-06, 13.229, 12.3015);
    path.close();

    // Las 3 líneas horizontales
    path.moveTo(47.9896, 73.5);
    path.cubicTo(47.9896, 69.1508, 51.7812, 65.625, 56.4583, 65.625);
    path.lineTo(129.854, 65.625);
    path.cubicTo(134.531, 65.625, 138.323, 69.1508, 138.323, 73.5);
    path.cubicTo(138.323, 77.8492, 134.531, 81.375, 129.854, 81.375);
    path.lineTo(56.4583, 81.375);
    path.cubicTo(51.7812, 81.375, 47.9896, 77.8492, 47.9896, 73.5);
    path.close();

    path.moveTo(47.9896, 115.5);
    path.cubicTo(47.9896, 111.151, 51.7812, 107.625, 56.4583, 107.625);
    path.lineTo(84.6875, 107.625);
    path.cubicTo(89.3645, 107.625, 93.1562, 111.151, 93.1562, 115.5);
    path.cubicTo(93.1562, 119.849, 89.3645, 123.375, 84.6875, 123.375);
    path.lineTo(56.4583, 123.375);
    path.cubicTo(51.7812, 123.375, 47.9896, 119.849, 47.9896, 115.5);
    path.close();

    path.moveTo(47.9896, 157.5);
    path.cubicTo(47.9896, 153.151, 51.7812, 149.625, 56.4583, 149.625);
    path.lineTo(73.3958, 149.625);
    path.cubicTo(78.073, 149.625, 81.8646, 153.151, 81.8646, 157.5);
    path.cubicTo(81.8646, 161.849, 78.073, 165.375, 73.3958, 165.375);
    path.lineTo(56.4583, 165.375);
    path.cubicTo(51.7812, 165.375, 47.9896, 161.849, 47.9896, 157.5);
    path.close();

    canvas.drawPath(path, paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant EditNoteIconPainter oldDelegate) => oldDelegate.color != color;
}
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
