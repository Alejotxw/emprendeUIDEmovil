import 'package:flutter/material.dart';
import 'botpress_asistente.dart'; // Importa el archivo que creamos antes

class AsistenteFlotante extends StatefulWidget {
  final Widget child;
  const AsistenteFlotante({super.key, required this.child});

  @override
  State<AsistenteFlotante> createState() => _AsistenteFlotanteState();
}

class _AsistenteFlotanteState extends State<AsistenteFlotante> {
  Offset position = const Offset(20, 100); // Posición inicial

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child, // Aquí va toda tu app (el sistema)
        Positioned(
          left: position.dx,
          top: position.dy,
          child: Draggable(
            feedback: _buildBubble(opacity: 0.5),
            childWhenDragging: Container(),
            onDragEnd: (details) {
              setState(() {
                // Ajustamos la posición al soltar (restando el margen del sistema si es necesario)
                position = details.offset;
              });
            },
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BotpressAsistente()),
                );
              },
              child: _buildBubble(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBubble({double opacity = 1.0}) {
    return Opacity(
      opacity: opacity,
      child: Material(
        elevation: 10,
        shape: const CircleBorder(),
        color: Colors.blueAccent, // Puedes usar el color de EmprendeUIDE
        child: const Padding(
          padding: EdgeInsets.all(12.0),
          child: Icon(Icons.support_agent, color: Colors.white, size: 30),
        ),
      ),
    );
  }
}