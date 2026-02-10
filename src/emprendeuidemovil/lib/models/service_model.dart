class ServiceModel {
  final String id;
  final String name;
  final String subtitle;
  final String category;
  final double price;
  final double rating;
  final int reviewCount;
  final bool isFavorite;
  final String imageUrl;
  final List<ProductItem> products;
  final List<ServiceItem> services;
  final String location;
  final bool isMine; // Indicates if this service belongs to the current user
  final String ownerId;
  final TransferData? transferData;
  final List<String> scheduleDays;
  final String openTime;
  final String closeTime;

  const ServiceModel({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.category,
    required this.price,
    required this.rating,
    required this.reviewCount,
    this.isFavorite = false,
    this.imageUrl = 'assets/LOGO.png',
    this.products = const [],
    this.services = const [],
    this.location = 'Loja Ecuador (Campus UIDE)',
    this.isMine = false,
    this.ownerId = '',
    this.transferData,
    this.scheduleDays = const ['Lun', 'Mar', 'Mie', 'Jue', 'Vie'],
    this.openTime = '09:00',
    this.closeTime = '18:00',
  });

  ServiceModel copyWith({
    String? id,
    String? name,
    String? subtitle,
    String? category,
    double? price,
    double? rating,
    int? reviewCount,
    bool? isFavorite,
    String? imageUrl,
    List<ProductItem>? products,
    List<ServiceItem>? services,
    String? location,
    bool? isMine,
    String? ownerId,
    TransferData? transferData,
    List<String>? scheduleDays,
    String? openTime,
    String? closeTime,
  }) {
    return ServiceModel(
      id: id ?? this.id,
      name: name ?? this.name,
      subtitle: subtitle ?? this.subtitle,
      category: category ?? this.category,
      price: price ?? this.price,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      isFavorite: isFavorite ?? this.isFavorite,
      imageUrl: imageUrl ?? this.imageUrl,
      products: products ?? this.products,
      services: services ?? this.services,
      location: location ?? this.location,
      isMine: isMine ?? this.isMine,
      ownerId: ownerId ?? this.ownerId,
      transferData: transferData ?? this.transferData,
      scheduleDays: scheduleDays ?? this.scheduleDays,
      openTime: openTime ?? this.openTime,
      closeTime: closeTime ?? this.closeTime,
    );
  }

  // Factory para crear desde Firestore
  factory ServiceModel.fromMap(Map<String, dynamic> map, String docId, String currentUserId) {
    return ServiceModel(
      id: docId,
      name: map['title'] ?? '',
      subtitle: map['subtitle'] ?? '',
      category: map['category'] ?? '',
      price: (map['price'] is int) ? (map['price'] as int).toDouble() : (map['price'] as double? ?? 0.0),
      rating: (map['rating'] is int) ? (map['rating'] as int).toDouble() : (map['rating'] as double? ?? 0.0),
      reviewCount: map['reviewCount'] ?? 0,
      imageUrl: map['imagePath'] ?? '',
      location: map['location'] ?? 'Loja Ecuador (Campus UIDE)',
      isMine: map['ownerId'] == currentUserId,
      ownerId: map['ownerId'] ?? '',
      transferData: (map['transferData'] != null && map['transferData'] is Map<String, dynamic>) 
          ? TransferData.fromMap(map['transferData']) 
          : null,
      scheduleDays: (map['scheduleDays'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? ['Lun', 'Mar', 'Mie', 'Jue', 'Vie'],
      openTime: map['openTime'] ?? '09:00',
      closeTime: map['closeTime'] ?? '18:00',
      products: (map['products'] as List<dynamic>?)
              ?.map((item) => ProductItem.fromMap(item))
              .toList() ??
          [],
      services: (map['services'] as List<dynamic>?)
              ?.map((item) => ServiceItem.fromMap(item))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': name,
      'subtitle': subtitle,
      'category': category,
      'price': price,
      'rating': rating,
      'reviewCount': reviewCount,
      'imagePath': imageUrl,
      'location': location,
      'ownerId': ownerId,
      'products': products.map((p) => p.toMap()).toList(),
      'services': services.map((s) => s.toMap()).toList(),
      'transferData': transferData?.toMap(),
      'scheduleDays': scheduleDays,
      'openTime': openTime,
      'closeTime': closeTime,
    };
  }

  // Helper para determinar tipo
  bool get isProduct => ['Comida', 'Libros', 'Accesorios'].contains(category);
  bool get isService => !isProduct;
}

class TransferData {
  final String bankName;
  final String accountNumber;
  final String accountType; // "Corriente" or "Ahorros"
  final String holderName;
  final String cedula;

  const TransferData({
    required this.bankName,
    required this.accountNumber,
    required this.accountType,
    required this.holderName,
    required this.cedula,
  });

  factory TransferData.fromMap(Map<String, dynamic> map) {
    return TransferData(
      bankName: map['bankName'] ?? '',
      accountNumber: map['accountNumber'] ?? '',
      accountType: map['accountType'] ?? 'Ahorros',
      holderName: map['holderName'] ?? '',
      cedula: map['cedula'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'bankName': bankName,
      'accountNumber': accountNumber,
      'accountType': accountType,
      'holderName': holderName,
      'cedula': cedula,
    };
  }
}

// Modelos para items
class ProductItem {
  final String name;
  final double price;
  final String description;
  final int stock;

  const ProductItem({
    required this.name,
    required this.price,
    required this.description,
    this.stock = 0,
  });

  factory ProductItem.fromMap(Map<String, dynamic> map) {
    return ProductItem(
      name: map['name'] ?? '',
      price: (map['price'] is int) ? (map['price'] as int).toDouble() : (map['price'] as double? ?? 0.0),
      description: map['description'] ?? '',
      stock: (map['stock'] is String) ? int.tryParse(map['stock']) ?? 0 : (map['stock'] as int? ?? 0),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'description': description,
      'stock': stock,
      'type': 'product',
    };
  }
}

class ServiceItem {
  final String name;
  final double price;
  final String description;
  final int stock;

  const ServiceItem({
    required this.name,
    required this.price,
    required this.description,
    this.stock = 0,
  });

  factory ServiceItem.fromMap(Map<String, dynamic> map) {
    return ServiceItem(
      name: map['name'] ?? '',
      price: (map['price'] is int) ? (map['price'] as int).toDouble() : (map['price'] as double? ?? 0.0),
      description: map['description'] ?? '',
      stock: (map['stock'] is String) ? int.tryParse(map['stock']) ?? 0 : (map['stock'] as int? ?? 0),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'description': description,
      'stock': stock,
      'type': 'service',
    };
  }
}
