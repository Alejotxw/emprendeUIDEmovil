import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/chat_provider.dart';
import '../models/chat_message.dart';


class ChatScreen extends StatelessWidget {
  final String chatId;
  final String title;
  
  // Default to 'default' chat ID and 'Asistente Virtual' title if not provided
  const ChatScreen({super.key, this.chatId = 'default', this.title = 'Asistente Virtual'});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: const Color.fromARGB(255, 152, 2, 7),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<ChatProvider>(
              builder: (context, chatProvider, child) {
                final messages = chatProvider.getMessages(chatId);
                return ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    return _MessageBubble(message: message);
                  },
                );
              },
            ),
          ),
          if (chatId == 'default' && context.watch<ChatProvider>().isTyping)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Escribiendo...",
                style: TextStyle(fontStyle: FontStyle.italic, color: Color.fromARGB(255, 81, 81, 81)),
              ),
            ),
          _MessageInput(chatId: chatId, isAI: chatId == 'default'),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final ChatMessage message;

  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4.0),
        padding: const EdgeInsets.all(12.0),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          color: isUser ? const Color.fromARGB(255, 116, 0, 33) : Colors.grey[200],
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(12),
            topRight: const Radius.circular(12),
            bottomLeft: isUser ? const Radius.circular(12) : Radius.zero,
            bottomRight: isUser ? Radius.zero : const Radius.circular(12),
          ),
        ),
        child: Text(
          message.text,
          style: TextStyle(
            color: isUser ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }
}

class _MessageInput extends StatefulWidget {
  final String chatId;
  final bool isAI;
  
  const _MessageInput({required this.chatId, required this.isAI});

  @override
  State<_MessageInput> createState() => _MessageInputState();
}

class _MessageInputState extends State<_MessageInput> {
  final _controller = TextEditingController();

  void _sendMessage() {
    if (_controller.text.trim().isEmpty) return;
    
    // Check if we are handling the default AI chat or a specific chat
    context.read<ChatProvider>().sendMessageToChat(
      widget.chatId, 
      _controller.text, 
      isUser: true, // Always user sending from UI
      isAI: widget.isAI
    );
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(253, 0, 0, 0),
            offset: const Offset(0, -1),
            blurRadius: 4,
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  hintText: 'Escribe un mensaje...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: const Color.fromARGB(255, 255, 255, 255),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
            const SizedBox(width: 8),
            FloatingActionButton(
              onPressed: _sendMessage,
              mini: true,
              backgroundColor: const Color.fromARGB(255, 120, 0, 42),
              child: const Icon(Icons.send, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}