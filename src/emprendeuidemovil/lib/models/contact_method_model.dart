enum ContactMethodType {
  phone,
  whatsapp,
  email,
  instagram,
  facebook,
  twitter,
  website,
  other,
}

class ContactMethodModel {
  final String id;
  final ContactMethodType type;
  final String value;
  final String label;
  final bool isPrimary;

  const ContactMethodModel({
    required this.id,
    required this.type,
    required this.value,
    required this.label,
    this.isPrimary = false,
  });

  factory ContactMethodModel.fromMap(Map<String, dynamic> map) {
    return ContactMethodModel(
      id: map['id'] ?? '',
      type: ContactMethodType.values.firstWhere(
        (e) => e.toString() == 'ContactMethodType.${map['type']}',
        orElse: () => ContactMethodType.other,
      ),
      value: map['value'] ?? '',
      label: map['label'] ?? '',
      isPrimary: map['isPrimary'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type.toString().split('.').last,
      'value': value,
      'label': label,
      'isPrimary': isPrimary,
    };
  }

  IconData get icon {
    switch (type) {
      case ContactMethodType.phone:
        return Icons.phone;
      case ContactMethodType.whatsapp:
        return Icons.chat;
      case ContactMethodType.email:
        return Icons.email;
      case ContactMethodType.instagram:
        return Icons.camera_alt;
      case ContactMethodType.facebook:
        return Icons.facebook;
      case ContactMethodType.twitter:
        return Icons.alternate_email;
      case ContactMethodType.website:
        return Icons.web;
      case ContactMethodType.other:
        return Icons.contact_page;
    }
  }

  Color get color {
    switch (type) {
      case ContactMethodType.phone:
        return Colors.green;
      case ContactMethodType.whatsapp:
        return Colors.green;
      case ContactMethodType.email:
        return Colors.blue;
      case ContactMethodType.instagram:
        return Colors.purple;
      case ContactMethodType.facebook:
        return Colors.blue;
      case ContactMethodType.twitter:
        return Colors.lightBlue;
      case ContactMethodType.website:
        return Colors.teal;
      case ContactMethodType.other:
        return Colors.grey;
    }
  }

  String get displayLabel {
    if (label.isNotEmpty) return label;
    switch (type) {
      case ContactMethodType.phone:
        return 'Teléfono';
      case ContactMethodType.whatsapp:
        return 'WhatsApp';
      case ContactMethodType.email:
        return 'Email';
      case ContactMethodType.instagram:
        return 'Instagram';
      case ContactMethodType.facebook:
        return 'Facebook';
      case ContactMethodType.twitter:
        return 'Twitter';
      case ContactMethodType.website:
        return 'Sitio Web';
      case ContactMethodType.other:
        return 'Otro';
    }
  }
}