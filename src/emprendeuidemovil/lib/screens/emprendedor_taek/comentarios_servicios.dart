import 'package:flutter/material.dart';
import 'package:emprendeuidemovil/screens/emprendedor_taek/formulario_comentarios_responder_emprendedor.dart';

class ComentariosServiciosScreen extends StatelessWidget {
  const ComentariosServiciosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildTopBar(context),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: const [
                CommentCard(
                  serviceName: "Comida Casera",
                  userName: "Romny Rios",
                  time: "12:00",
                  comment: "Estuvieron Buenas, el problema es que se demora mucho",
                ),
                SizedBox(height: 16),
                CommentCard(
                  serviceName: "Comida Casera",
                  userName: "Romny Rios",
                  time: "12:00",
                  comment: "Estuvieron Buenas, el problema es que se demora mucho",
                ),
                SizedBox(height: 16),
                CommentCard(
                  serviceName: "Comida Casera",
                  userName: "Romny Rios",
                  time: "12:00",
                  comment: "Estuvieron Buenas, el problema es que se demora mucho",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 50, bottom: 20, left: 16, right: 16),
      decoration: const BoxDecoration(
        color: Color(0xFF83002A),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 8),
          const Expanded(
            child: Text(
              'Comentarios de mis Servicios / Productos',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 40), // Balance the back button
        ],
      ),
    );
  }
}

class CommentCard extends StatefulWidget {
  final String serviceName;
  final String userName;
  final String time;
  final String comment;

  const CommentCard({
    super.key,
    required this.serviceName,
    required this.userName,
    required this.time,
    required this.comment,
  });

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  String? _reply;

  void _openReplyForm() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return FormularioComentariosResponderEmprendedor(
          initialResponse: _reply,
          onResponder: (replyText) {
            setState(() {
              _reply = replyText;
            });
          },
          onDelete: () {
            setState(() {
              _reply = null;
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade400),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.serviceName,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              GestureDetector(
                onTap: _openReplyForm,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFA600),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    "Responder",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(
                widget.userName,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                widget.time,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            widget.comment,
            style: const TextStyle(
              fontSize: 15,
              color: Colors.black,
              fontWeight: FontWeight.w400,
            ),
          ),
          if (_reply != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Tu respuesta:",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF83002A),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _reply!,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
