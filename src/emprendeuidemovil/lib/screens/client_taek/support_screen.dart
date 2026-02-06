import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

// Modelo para manejar quién envía el mensaje
class ChatMessage {
  final String text;
  final bool isUser;
  ChatMessage({required this.text, required this.isUser});
}

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [
    ChatMessage(text: 'Hola soy tu asistente virtual de Emprende UIDE. ¿En qué puedo ayudarte?', isUser: false),
  ];

  // CONFIGURACIÓN DEL CHATBOT
  // Reemplaza con tu API KEY real
  static const _apiKey = 'AIzaSyCJzxhSXtKJllTOwXR14gR7Y7A9u3lBYqA'; 
  final model = GenerativeModel(
    model: 'gemini-1.5-flash',
    apiKey: _apiKey,
  );

  bool _isLoading = false;

  Future<void> _sendMessage() async {
    if (_messageController.text.isEmpty) return;

    final userText = _messageController.text;
    setState(() {
      _messages.add(ChatMessage(text: userText, isUser: true));
      _isLoading = true;
    });
    _messageController.clear();

    try {
      // Prompt para darle personalidad al bot
      final content = [Content.text("Actúa como el asistente de Emprende UIDE. Responde de forma amable y profesional sobre emprendimiento universitario: $userText")];
      final response = await model.generateContent(content);

      setState(() {
        _messages.add(ChatMessage(text: response.text ?? 'Lo siento, tuve un error al procesar.', isUser: false));
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _messages.add(ChatMessage(text: 'Error de conexión. Revisa tu API Key.', isUser: false));
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ayuda y Soporte'),
        backgroundColor: Colors.orange,
      ),
      body: Column(
        children: [
          // Espacio para Email y WhatsApp (Simplificado)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _ContactIcon(icon: Icons.email, label: 'Email', color: Colors.orange),
                _ContactIcon(icon: Icons.message, label: 'WhatsApp', color: Colors.green),
              ],
            ),
          ),
          const Divider(),
          // Área de Chat
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return _ChatBubble(message: msg);
              },
            ),
          ),
          if (_isLoading) const LinearProgressIndicator(color: Colors.orange),
          // Input de mensaje
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Escribe tu duda...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.orange),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Widget de Burbuja de Chat
class _ChatBubble extends StatelessWidget {
  final ChatMessage message;
  const _ChatBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.symmetric(vertical: 4),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
        decoration: BoxDecoration(
          color: message.isUser ? Colors.orange[100] : Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(message.text),
      ),
    );
  }
}

// Widget auxiliar para iconos de contacto
class _ContactIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _ContactIcon({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 30, color: color),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}