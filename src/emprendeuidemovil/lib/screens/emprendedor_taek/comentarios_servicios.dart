import 'package:flutter/material.dart';
import 'package:emprendeuidemovil/screens/emprendedor_taek/formulario_comentarios_responder_emprendedor.dart';

class ComentariosServiciosScreen extends StatelessWidget {
  const ComentariosServiciosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                  rating: 3,
                ),
                SizedBox(height: 16),
                CommentCard(
                  serviceName: "Comida Casera",
                  userName: "Romny Rios",
                  time: "12:00",
                  comment: "Estuvieron Buenas, el problema es que se demora mucho",
                  rating: 5,
                ),
                SizedBox(height: 16),
                CommentCard(
                  serviceName: "Comida Casera",
                  userName: "Romny Rios",
                  time: "12:00",
                  comment: "Estuvieron Buenas, el problema es que se demora mucho",
                  rating: 4,
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
              'Reseñas',
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
  final int rating;

  const CommentCard({
    super.key,
    required this.serviceName,
    required this.userName,
    required this.time,
    required this.comment,
    required this.rating,
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isDark ? Colors.grey.shade800 : Colors.grey.shade400),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.serviceName,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
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
                  color: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                widget.time,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Star Rating Row
          Row(
            children: List.generate(5, (index) {
              return Icon(
                index < widget.rating ? Icons.star : Icons.star_border,
                color: const Color(0xFFFFA600),
                size: 20,
              );
            }),
          ),
          const SizedBox(height: 12),
          Text(
            widget.comment,
            style: TextStyle(
              fontSize: 15,
              color: isDark ? Colors.white70 : Colors.black,
              fontWeight: FontWeight.w400,
            ),
          ),
          if (_reply != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              width: double.infinity,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF2C2C2C) : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: isDark ? Colors.grey.shade700 : Colors.grey.shade300),
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
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? Colors.white70 : Colors.black87,
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
