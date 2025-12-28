import 'package:flutter/material.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<String> _messages = [
    'Hola soy tu asistente virtual de Emprende UIDE. ¿En qué puedo ayudarte?',
  ]; // Mock chat

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Ayuda y Soporte'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Icons Email y WhatsApp (centrados)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    const Icon(Icons.email, size: 48, color: Colors.orange),
                    const Text('Email'),
                  ],
                ),
                Column(
                  children: [
                    const Icon(
                      Icons.message,
                      size: 48,
                      color: Colors.green,
                    ), // Icons.message para WhatsApp (fix error)
                    const Text('WhatsApp'),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Chat area (mock messages)
            Expanded(
              child: ListView.builder(
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(_messages[index]),
                    ),
                  );
                },
              ),
            ),
            // TextField para mensaje
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Escribe tu mensaje...',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: null,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.orange),
                  onPressed: () {
                    if (_messageController.text.isNotEmpty) {
                      setState(() {
                        _messages.add(_messageController.text);
                      });
                      _messageController.clear();
                      // Mock respuesta
                      Future.delayed(const Duration(seconds: 1), () {
                        setState(() {
                          _messages.add(
                            'Gracias por tu mensaje. Te responderemos pronto.',
                          );
                        });
                      });
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}