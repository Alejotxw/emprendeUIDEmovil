class ChatMessage {
  final String text;
  final bool isUser; // true if sent by user, false if by AI
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}