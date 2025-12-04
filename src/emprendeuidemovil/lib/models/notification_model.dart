class AppNotification {
  final String id;
  final String title;
  final String body;
  final DateTime? createdAt;
  final bool read;

  AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.createdAt,
    required this.read,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    DateTime? parseCreatedAt(dynamic value) {
      if (value == null) return null;

      // Cuando el backend manda el timestamp de Firestore serializado
      if (value is Map && value['_seconds'] != null) {
        final seconds = value['_seconds'] as int;
        return DateTime.fromMillisecondsSinceEpoch(seconds * 1000);
      }

      if (value is String) {
        return DateTime.tryParse(value);
      }

      return null;
    }

    return AppNotification(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      createdAt: parseCreatedAt(json['createdAt']),
      read: json['read'] ?? false,
    );
  }
}
