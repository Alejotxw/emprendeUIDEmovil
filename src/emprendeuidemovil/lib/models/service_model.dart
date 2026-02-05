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

  const ServiceModel({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.category,
    required this.price,
    required this.rating,
    required this.reviewCount,
    this.isFavorite = false,
    this.imageUrl = 'assets/placeholder_service.png',
    this.products = const [],
    this.services = const [],
    this.location = 'Sede Loja Universidad Internacional del Ecuador',
    this.isMine = false,
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
    );
  }

  // Helper para determinar tipo
  bool get isProduct => ['Comida', 'Libros', 'Accesorios'].contains(category);
  bool get isService => !isProduct;
}

// Modelos para items
class ProductItem {
  final String name;
  final double price;
  final String description;

  const ProductItem({
    required this.name,
    required this.price,
    required this.description,
  });
}

class ServiceItem {
  final String name;
  final double price;
  final String description;

  const ServiceItem({
    required this.name,
    required this.price,
    required this.description,
  });
}