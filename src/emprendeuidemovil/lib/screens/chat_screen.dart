import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/chat_provider.dart';
import '../models/chat_message.dart';


class ChatScreen extends StatelessWidget {
  final String chatId;
  final String title;
  final bool isEntrepreneurView;
  
  // Default to 'default' chat ID and 'Asistente Virtual' title if not provided
  const ChatScreen({
    super.key, 
    this.chatId = 'default', 
    this.title = 'Asistente Virtual',
    this.isEntrepreneurView = false,
  });

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
                    return _MessageBubble(
                      message: message, 
                      isEntrepreneurView: isEntrepreneurView,
                      isAI: chatId == 'default',
                    );
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
          _MessageInput(
            chatId: chatId, 
            isAI: chatId == 'default',
            isEntrepreneurView: isEntrepreneurView,
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isEntrepreneurView;
  final bool isAI;

  const _MessageBubble({
    super.key,
    required this.message, 
    required this.isEntrepreneurView,
    this.isAI = false,
  });

  @override
  Widget build(BuildContext context) {
    // Current User Role based on the View
    final String myRole = isEntrepreneurView ? 'entrepreneur' : 'client';
    
    // Check if I sent the message
    // "IsUser" logic is now: Does the message sender role match my current role?
    // OR if it's the legacy isUser flag (for AI chat mostly).
    // For P2P, we trust senderRole.
    
    final bool isMe = isAI ? message.isUser : (message.senderRole == myRole);
    
    // Determine visuals based on role
    late final String label;
    late final IconData icon;
    late final Color bubbleColor;
    
    if (isAI) {
      if (isMe) {
        label = "Tú";
        icon = Icons.person;
        bubbleColor = const Color(0xFF424242); 
      } else {
        label = "Asistente Virtual";
        icon = Icons.smart_toy;
        bubbleColor = const Color.fromARGB(255, 152, 2, 7);
      }
    } else {
      // P2P Chat Logic based simply on Sender Role
      if (message.senderRole == 'entrepreneur') {
        label = isMe ? "Tú (Emprendedor)" : "Emprendedor";
        icon = Icons.store;
        bubbleColor = const Color(0xFF83002A); // Emprendedor Red
      } else {
        label = isMe ? "Tú (Cliente)" : "Cliente";
        icon = Icons.person;
        bubbleColor = const Color(0xFF455A64); // Blue Grey for Client
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          // Label above bubble
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey[600],
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end, // Align avatar at bottom
            children: [
              if (!isMe) ...[
                CircleAvatar(
                  backgroundColor: bubbleColor.withOpacity(0.1),
                  radius: 18,
                  child: Icon(icon, color: bubbleColor, size: 20),
                ),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: Container(
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: bubbleColor,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      // "Tail" effect
                      bottomLeft: isMe ? const Radius.circular(16) : Radius.zero,
                      bottomRight: isMe ? Radius.zero : const Radius.circular(16),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 2,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Text(
                    message.text,
                    style: const TextStyle(
                      color: Colors.white, 
                      fontSize: 15,
                      height: 1.3,
                    ),
                  ),
                ),
              ),
              if (isMe) ...[
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: bubbleColor.withOpacity(0.1),
                  radius: 18,
                  child: Icon(icon, color: bubbleColor, size: 20),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _MessageInput extends StatefulWidget {
  final String chatId;
  final bool isAI;
  final bool isEntrepreneurView;
  
  const _MessageInput({
    required this.chatId, 
    required this.isAI,
    this.isEntrepreneurView = false,
  });

  @override
  State<_MessageInput> createState() => _MessageInputState();
}

class _MessageInputState extends State<_MessageInput> {
  final _controller = TextEditingController();

  void _sendMessage() {
    if (_controller.text.trim().isEmpty) return;
    
    // Determine sender role
    final String role = widget.isAI 
        ? 'client' // Default for AI chat
        : (widget.isEntrepreneurView ? 'entrepreneur' : 'client');

    // Check if we are handling the default AI chat or a specific chat
    context.read<ChatProvider>().sendMessageToChat(
      widget.chatId, 
      _controller.text, 
      isUser: true, // Always user sending from UI
      isAI: widget.isAI,
      senderRole: role,
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