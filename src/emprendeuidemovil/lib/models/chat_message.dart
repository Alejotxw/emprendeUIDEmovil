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
}