import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // BARRA SUPERIOR CON BUSCADOR
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Color(0xFF90063a).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const TextField(
            decoration: InputDecoration(
              icon: Icon(Icons.search, color: Color(0xFF90063a)),
              border: InputBorder.none,
              hintText: 'Buscar emprendimientos...',
            ),
          ),
        ),
      ),

      body: const Center(
        child: Text(
          'Bienvenido a EmprendeUIDE',
          style: TextStyle(
            fontSize: 22,
            color: Color(0xFF90063a),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ); // <-- ESTE FALTABA
  }
}
