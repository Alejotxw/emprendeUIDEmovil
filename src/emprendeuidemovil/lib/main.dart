import 'package:flutter/material.dart';

import 'package:emprendeuidemovil/screens/emprendedor_perfil.dart';
import 'package:emprendeuidemovil/screens/mis_emprendimientos.dart';
import 'package:emprendeuidemovil/screens/solicitudes.dart';

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
      home: const MainScreen(),
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
    const SolicitudesScreen(), // Index 0
    const MisEmprendimientosScreen(), // Index 1
    const EmprendedorPerfilScreen(), // Index 2
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Main Content
          _pages[_currentIndex],

          // Custom Bottom Navigation Bar
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _buildCustomBottomNavBar(),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomBottomNavBar() {
    return Container(
      height: 80,
      decoration: BoxDecoration(
         color: const Color(0xFFF0F0F0), // Light grey background
         borderRadius: const BorderRadius.only(
             topLeft: Radius.circular(30),
             topRight: Radius.circular(30)
         ),
         boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            )
         ],
      ),
      child: Stack(
         clipBehavior: Clip.none,
         alignment: Alignment.center,
         children: [
             Row(
               mainAxisAlignment: MainAxisAlignment.spaceAround,
               children: [
                  // Left Button (Edit/Note)
                  GestureDetector(
                     onTap: () {
                        setState(() {
                          _currentIndex = 0;
                        });
                     },
                     child: SizedBox(
                       width: 35,
                       height: 35,
                       child: CustomPaint(
                         painter: EditNoteIconPainter(
                           color: _currentIndex == 0 ? Colors.black : Colors.grey
                         ),
                       ),
                     ),
                  ),
                   const SizedBox(width: 60), // Space for center button
                   // Right Button (Profile)
                   GestureDetector(
                      onTap: () {
                         setState(() {
                           _currentIndex = 2;
                         });
                      },
                      child: SizedBox(
                        width: 35,
                        height: 35,
                         child: CustomPaint(
                           painter: UserIconPainter(
                             color: _currentIndex == 2 ? Colors.black : Colors.grey
                           ),
                         ),
                      ),
                  )
               ],
             ),
             // Floating Center Button
             Positioned(
                top: -30,
                child: GestureDetector(
                  onTap: () {
                    // Logic for center button (e.g. open create modal)
                    print("Center button tapped");
                    setState(() { _currentIndex = 1; });
                  },
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
                         )
                       ]
                     ),
                     padding: const EdgeInsets.all(15),
                     child: CustomPaint(
                       painter: PlusIconPainter(),
                     ),
                  ),
                ),
             )
         ],
      ),
    );
  }
}

class PlusIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    
    // Original SVG dimensions
    const double svgWidth = 138;
    const double svgHeight = 135;

    // Scale to fit
    final double scaleX = size.width / svgWidth;
    final double scaleY = size.height / svgHeight;
    final double scale = scaleX < scaleY ? scaleX : scaleY;
    
    canvas.save();
    
    // Center alignment
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
    
    path.moveTo(115.973, 112.678);
    path.cubicTo(90.0166, 137.881, 47.9298, 137.881, 21.9675, 112.678);
    path.cubicTo(-3.98917, 87.4749, -3.98917, 46.6103, 21.9675, 21.4021);
    path.cubicTo(47.9298, -3.80071, 90.0111, -3.80071, 115.973, 21.4021);
    path.cubicTo(141.936, 46.6103, 141.936, 87.4749, 115.973, 112.678);
    path.close();
    
    path.moveTo(108.141, 29.0125);
    path.cubicTo(86.8593, 8.34893, 51.8238, 7.63361, 29.8055, 29.0125);
    path.cubicTo(8.20815, 49.9825, 8.20815, 84.1026, 29.8055, 105.073);
    path.cubicTo(51.8238, 126.452, 86.8648, 125.731, 108.141, 105.073);
    path.cubicTo(129.738, 84.1026, 129.738, 49.9825, 108.141, 29.0125);
    path.close();

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
      ..color = color
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
      ..color = color
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
