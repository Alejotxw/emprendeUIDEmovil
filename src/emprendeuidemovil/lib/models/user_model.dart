class UserModel {
  final String id;
  final String email;
  final String name;

  const UserModel({required this.id, required this.email, required this.name});

  // Método factory para fromMap (para auth)
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      name: map['name'] ?? '',
    );
  }
}
