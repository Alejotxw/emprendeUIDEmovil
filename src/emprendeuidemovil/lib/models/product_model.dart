class ProductModel {
  final String id;
  final String title;
  final String description;
  final double price;
  final String? category;
  final String? imageUrl;
  final String vendedorId;
  final String vendedorNombre;
  final bool isActive;

  ProductModel({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    this.category,
    this.imageUrl,
    required this.vendedorId,
    required this.vendedorNombre,
    required this.isActive,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      price: (json['price'] as num).toDouble(),
      category: json['category'],
      imageUrl: json['imageUrl'],
      vendedorId: json['vendedorId'],
      vendedorNombre: json['vendedorNombre'],
      isActive: json['isActive'] ?? true,
    );
  }
}
