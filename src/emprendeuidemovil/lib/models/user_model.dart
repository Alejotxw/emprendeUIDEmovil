class UserModel {
  final String id;
  final String email;
  final String nombre;
  final String rol;

  const UserModel({
    required this.id,
    required this.email,
    required this.nombre,
    required this.rol,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      nombre: map['nombre'] ?? '',
      rol: map['rol'] ?? '',
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel.fromMap(json);
  }
}
