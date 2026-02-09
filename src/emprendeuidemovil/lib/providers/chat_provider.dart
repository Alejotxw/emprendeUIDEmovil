import 'package:flutter/material.dart';
import '../models/chat_message.dart';
import '../services/chat_service.dart';

class ChatProvider with ChangeNotifier {
  final ChatService _chatService = ChatService();
  
  // Map to store messages for each chat ID. 
  // Key: ID (e.g., 'default', 'order-123'), Value: List of messages
  final Map<String, List<ChatMessage>> _chats = {};
  
  bool _isTyping = false;

  // Backward compatibility for the default AI chat
  List<ChatMessage> get messages => getMessages('default');
  bool get isTyping => _isTyping;

  List<ChatMessage> getMessages(String chatId) {
    if (!_chats.containsKey(chatId)) {
      _chats[chatId] = [];
    }
    return List.unmodifiable(_chats[chatId]!);
  }

  // Original sendMessage for AI chat (default)
  Future<void> sendMessage(String text) async {
    await sendMessageToChat('default', text, isUser: true, isAI: true, senderRole: 'client');
  }

  // Generic sendMessage for any chat
  Future<void> sendMessageToChat(String chatId, String text, {required bool isUser, bool isAI = false, required String senderRole}) async {
    if (text.trim().isEmpty) return;

    if (!_chats.containsKey(chatId)) {
      _chats[chatId] = [];
    }

    // Add immediate message
    _chats[chatId]!.add(ChatMessage(
      text: text,
      isUser: isUser,
      senderRole: senderRole,
      timestamp: DateTime.now(),
    ));
    
    // Only if it's the AI chat, we trigger the bot response
    if (isAI) {
      _isTyping = true;
      notifyListeners();

      try {
        final responseText = await _chatService.sendMessage(text);
        _chats[chatId]!.add(ChatMessage(
          text: responseText,
          isUser: false,
          senderRole: 'ai',
          timestamp: DateTime.now(),
        ));
      } catch (e) {
        _chats[chatId]!.add(ChatMessage(
          text: "Lo siento, tuve un problema al conectar. Inténtalo de nuevo.",
          isUser: false,
          senderRole: 'ai',
          timestamp: DateTime.now(),
        ));
      } finally {
        _isTyping = false;
        notifyListeners();
      }
    } else {
      // For P2P chats (Entrepenuer <-> Client), just notify needed
      notifyListeners();
      
      // Simular respuesta del emprendedor/cliente si es necesario para demo
      // if (isUser) {
      //   Future.delayed(Duration(seconds: 1), () {
      //      _chats[chatId]!.add(ChatMessage(text: "Respuesta automática", isUser: !isUser, senderRole: senderRole == 'client' ? 'entrepreneur' : 'client', timestamp: DateTime.now()));
      //      notifyListeners();
      //   });
      // }
    }
  }
}