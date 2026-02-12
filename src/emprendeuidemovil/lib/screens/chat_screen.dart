import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../providers/chat_provider.dart';
import '../providers/notification_provider.dart';
import '../models/chat_message.dart';

class ChatScreen extends StatefulWidget {
  final String chatId;
  final String title;
  final bool isEntrepreneurView;
  final String? recipientId;
  
  const ChatScreen({
    super.key, 
    this.chatId = 'default', 
    this.title = 'Asistente Virtual',
    this.isEntrepreneurView = false,
    this.recipientId,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String? _clientImageUrl;
  String? _sellerImageUrl;
  String? _clientId;
  String? _sellerId;

  @override
  void initState() {
    super.initState();
    // If recipientId is passed, use it immediately
    if (widget.recipientId != null) {
      if (widget.isEntrepreneurView) {
        _clientId = widget.recipientId;
      } else {
        _sellerId = widget.recipientId;
      }
    }
    _loadParticipants();
  }

  Future<void> _loadParticipants() async {
    if (widget.chatId.startsWith('order-')) {
      final orderId = widget.chatId.replaceFirst('order-', '');
      final orderDoc = await FirebaseFirestore.instance.collection('orders').doc(orderId).get();
      
      if (orderDoc.exists && mounted) {
        setState(() {
          // Use data from Firestore, but keep passed ID if firestore fails or is empty
          _clientId ??= orderDoc.data()?['clientId'];
          _sellerId ??= orderDoc.data()?['sellerId'];
        });
        
        if (_clientId != null) {
          FirebaseFirestore.instance.collection('users').doc(_clientId).snapshots().listen((doc) {
            if (doc.exists && mounted) {
              setState(() {
                _clientImageUrl = doc.data()?['imageBase64'] ?? doc.data()?['imagePath'];
              });
            }
          });
        }
        
        if (_sellerId != null) {
          FirebaseFirestore.instance.collection('users').doc(_sellerId).snapshots().listen((doc) {
            if (doc.exists && mounted) {
              setState(() {
                _sellerImageUrl = doc.data()?['imageBase64'] ?? doc.data()?['imagePath'];
              });
            }
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: const Color.fromARGB(255, 152, 2, 7),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<ChatProvider>(
              builder: (context, chatProvider, child) {
                final messages = chatProvider.getMessages(widget.chatId);
                return ListView.builder(
                  reverse: true,
                  padding: const EdgeInsets.all(16.0),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    
                    // Logic for grouping messages (reverse: true, so index 0 is newest)
                    // messages[index + 1] is older, messages[index - 1] is newer
                    final bool isFirstInGroup = index == messages.length - 1 || 
                        messages[index + 1].senderRole != message.senderRole;
                    final bool isLastInGroup = index == 0 || 
                        messages[index - 1].senderRole != message.senderRole;

                    return _MessageBubble(
                      message: message, 
                      isEntrepreneurView: widget.isEntrepreneurView,
                      isAI: widget.chatId == 'default',
                      clientImage: _clientImageUrl,
                      sellerImage: _sellerImageUrl,
                      isFirstInGroup: isFirstInGroup,
                      isLastInGroup: isLastInGroup,
                    );
                  },
                );
              },
            ),
          ),
          if (widget.chatId == 'default' && context.watch<ChatProvider>().isTyping)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Escribiendo...",
                style: TextStyle(fontStyle: FontStyle.italic, color: Color.fromARGB(255, 81, 81, 81)),
              ),
            ),
          _MessageInput(
            chatId: widget.chatId, 
            isAI: widget.chatId == 'default',
            isEntrepreneurView: widget.isEntrepreneurView,
            recipientId: widget.isEntrepreneurView ? _clientId : _sellerId,
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
  final String? clientImage;
  final String? sellerImage;
  final bool isFirstInGroup;
  final bool isLastInGroup;

  const _MessageBubble({
    super.key,
    required this.message, 
    required this.isEntrepreneurView,
    this.isAI = false,
    this.clientImage,
    this.sellerImage,
    this.isFirstInGroup = true,
    this.isLastInGroup = true,
  });

  ImageProvider? _getImageProvider(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) return null;
    if (imagePath.startsWith('data:image')) {
      try {
        final b64 = imagePath.split(',').last;
        return MemoryImage(base64Decode(b64));
      } catch (e) {
        return null;
      }
    }
    if (imagePath.startsWith('http')) return NetworkImage(imagePath);
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final String myRole = isEntrepreneurView ? 'entrepreneur' : 'client';
    final bool isMe = isAI ? message.isUser : (message.senderRole == myRole);
    
    late final String label;
    late final IconData icon;
    late final Color bubbleColor;
    String? profileImage;

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
      if (message.senderRole == 'entrepreneur') {
        label = isMe ? "Tú (Emprendedor)" : "Emprendedor";
        icon = Icons.store;
        bubbleColor = const Color(0xFF83002A);
        profileImage = sellerImage;
      } else {
        label = isMe ? "Tú (Cliente)" : "Cliente";
        icon = Icons.person;
        bubbleColor = const Color(0xFF455A64);
        profileImage = clientImage;
      }
    }

    final imageProvider = _getImageProvider(profileImage);

    return Padding(
      padding: EdgeInsets.only(
        top: isFirstInGroup ? 36.0 : 4.0, // Aumento significativo de separación entre bloques
        bottom: isLastInGroup ? 12.0 : 0.0,
      ),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          // Nombre del remitente
          if (!isMe && isFirstInGroup)
            Padding(
              padding: const EdgeInsets.only(left: 48.0, bottom: 6.0),
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          Row(
            mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Lado Izquierdo: Avatar (solo para mensajes recibidos y último del bloque)
              if (!isMe) ...[
                SizedBox(
                  width: 40,
                  child: isLastInGroup 
                    ? CircleAvatar(
                        backgroundColor: bubbleColor.withOpacity(0.1),
                        radius: 18,
                        backgroundImage: imageProvider,
                        child: imageProvider == null ? Icon(icon, color: bubbleColor, size: 20) : null,
                      )
                    : const SizedBox.shrink(),
                ),
                const SizedBox(width: 8),
              ],
              
              // DESFASE LATERAL (OFFSET): Forzar el mensaje a no ocupar todo el ancho
              if (isMe) const SizedBox(width: 90), 

              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  decoration: BoxDecoration(
                    color: bubbleColor,
                    borderRadius: BorderRadius.circular(18).copyWith(
                      // WhatsApp style: Puntero (tail) solo en el primer mensaje
                      topLeft: (!isMe && isFirstInGroup) ? Radius.zero : null,
                      topRight: (isMe && isFirstInGroup) ? Radius.zero : null,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 3,
                        offset: const Offset(0, 2),
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

              // DESFASE LATERAL (OFFSET): Forzar el mensaje a no ocupar todo el ancho
              if (!isMe) const SizedBox(width: 90),

              // Lado Derecho: Avatar para mis mensajes (Opcional: quitado para limpiar el diseño, o dejar pequeño)
              if (isMe) ...[
                const SizedBox(width: 8),
                const SizedBox(width: 40), // Espacio para mantener alineación sin mostrar avatar propio
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
  final String? recipientId;
  
  const _MessageInput({
    required this.chatId, 
    required this.isAI,
    this.isEntrepreneurView = false,
    this.recipientId,
  });

  @override
  State<_MessageInput> createState() => _MessageInputState();
}

class _MessageInputState extends State<_MessageInput> {
  final _controller = TextEditingController();
  bool _isTypingSignalSent = false;
  Timer? _typingTimer;

  @override
  void dispose() {
    _controller.dispose();
    _typingTimer?.cancel();
    super.dispose();
  }

  void _onChanged(String value) {
    if (value.trim().isNotEmpty && !_isTypingSignalSent && widget.recipientId != null) {
      _isTypingSignalSent = true;
      
      // Notificación de que alguien está escribiendo
      final senderName = widget.isEntrepreneurView ? "El Emprendedor" : "El Cliente";
      final roleText = widget.isEntrepreneurView ? "emprendedor" : "cliente";
      
      if (widget.recipientId != null) {
        context.read<NotificationProvider>().addNotification(
          "Chat en vivo", 
          "$senderName ha empezado a escribir...",
          recipientId: widget.recipientId
        );
      }
      
      // Reset after 10 seconds of inactivity or after message sent
      _typingTimer?.cancel();
      _typingTimer = Timer(const Duration(seconds: 20), () {
        if (mounted) _isTypingSignalSent = false;
      });
    }
  }

  void _sendMessage() {
    if (_controller.text.trim().isEmpty) return;
    
    final String role = widget.isAI 
        ? 'client' 
        : (widget.isEntrepreneurView ? 'entrepreneur' : 'client');

    context.read<ChatProvider>().sendMessageToChat(
      widget.chatId, 
      _controller.text, 
      isUser: true,
      isAI: widget.isAI,
      senderRole: role,
    );
    _controller.clear();
    _isTypingSignalSent = false;
    _typingTimer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(253, 0, 0, 0).withOpacity(0.05),
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
                onChanged: _onChanged,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  hintText: 'Escribe un mensaje...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
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
