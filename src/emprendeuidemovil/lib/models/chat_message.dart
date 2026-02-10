class ChatMessage {
  final String text;
  final bool isUser; // true if sent by user, false if by AI/Bot. Used for alignment fallback.
  final String senderRole; // 'client', 'entrepreneur', 'ai'
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.senderRole,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'text': text, // Corresponds to message content
      'isUser': isUser,
      'senderRole': senderRole,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      text: map['text'] ?? '',
      isUser: map['isUser'] ?? false,
      senderRole: map['senderRole'] ?? 'client',
      timestamp: map['timestamp'] != null 
          ? DateTime.tryParse(map['timestamp'].toString()) ?? DateTime.now() 
          : DateTime.now(),
    );
  }
}