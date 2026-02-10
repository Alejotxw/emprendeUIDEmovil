import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/chat_message.dart';
import '../services/chat_service.dart';

class ChatProvider with ChangeNotifier {
  final ChatService _chatService = ChatService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Map to store messages for each chat ID locally for UI
  final Map<String, List<ChatMessage>> _chats = {};
  
  // Map to store active listeners
  final Map<String, StreamSubscription> _listeners = {};
  
  bool _isTyping = false;
  String? _currentChatId;

  // Backward compatibility
  List<ChatMessage> get messages => getMessages('default');
  bool get isTyping => _isTyping;

  /// Helper to get messages for UI consumption
  List<ChatMessage> getMessages(String chatId) {
    if (!_chats.containsKey(chatId)) {
      _chats[chatId] = [];
      // Auto-subscribe if not already subscribed? 
      // Better to explicit subscribe, but for now let's auto-subscribe to be safe 
      // if UI calls this without init.
      subscribeToChat(chatId);
    }
    return List.unmodifiable(_chats[chatId]!);
  }

  /// Subscribe to real-time updates for a specific chat
  void subscribeToChat(String chatId) {
    if (_listeners.containsKey(chatId)) return; // Already listening

    _currentChatId = chatId;
    if (!_chats.containsKey(chatId)) {
      _chats[chatId] = [];
    }

    print("Subscribing to chat: $chatId");

    // Listen to the 'messages' subcollection of the specific chat document
    _listeners[chatId] = _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: false) // Oldest first
        .snapshots()
        .listen((snapshot) {
      
      final List<ChatMessage> newMessages = snapshot.docs.map((doc) {
        final data = doc.data();
        return ChatMessage.fromMap(data);
      }).toList();

      _chats[chatId] = newMessages;
      notifyListeners();
    }, onError: (e) {
      print("Error listening to chat $chatId: $e");
    });
  }

  /// Unsubscribe to clean up resources
  void unsubscribeFromChat(String chatId) {
    _listeners[chatId]?.cancel();
    _listeners.remove(chatId);
    // Optionally clear messages from memory if desired
    // _chats.remove(chatId); 
  }

  // Original sendMessage for AI chat (default) compatibility
  Future<void> sendMessage(String text) async {
    await sendMessageToChat('default', text, isUser: true, isAI: true, senderRole: 'client');
  }

  // Generic sendMessage for any chat
  Future<void> sendMessageToChat(String chatId, String text, {required bool isUser, bool isAI = false, required String senderRole}) async {
    if (text.trim().isEmpty) return;

    // Ensure we are subscribed so we see our own message come back
    subscribeToChat(chatId);

    final newMessage = ChatMessage(
      text: text,
      isUser: isUser,
      senderRole: senderRole,
      timestamp: DateTime.now(),
    );

    try {
      // 1. Save to Firestore
      await _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .add(newMessage.toMap());

      // 2. Update parent chat document metadata (optional but good for 'last message' lists)
      await _firestore.collection('chats').doc(chatId).set({
        'lastMessage': text,
        'lastMessageTime': DateTime.now().toIso8601String(),
        'participants': FieldValue.arrayUnion([senderRole]), // basic tagging
      }, SetOptions(merge: true));

    } catch (e) {
      print("Error sending message to Firestore: $e");
      // Fallback: add locally if offline (though Firestore handles offline mostly)
      if (!_chats.containsKey(chatId)) _chats[chatId] = [];
      _chats[chatId]!.add(newMessage);
      notifyListeners();
    }
    
    // AI Logic
    if (isAI) {
      _isTyping = true;
      notifyListeners();

      try {
        final responseText = await _chatService.sendMessage(text);
        
        final aiMessage = ChatMessage(
          text: responseText,
          isUser: false,
          senderRole: 'ai',
          timestamp: DateTime.now(),
        );

        await _firestore
            .collection('chats')
            .doc(chatId)
            .collection('messages')
            .add(aiMessage.toMap());

      } catch (e) {
        // Handle error
        print("AI Error: $e");
      } finally {
        _isTyping = false;
        notifyListeners();
      }
    }
  }

  @override
  void dispose() {
    for (var sub in _listeners.values) {
      sub.cancel();
    }
    _listeners.clear();
    super.dispose();
  }
}