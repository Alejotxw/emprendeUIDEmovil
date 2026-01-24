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
}
  final String uid;
  final String nombre;
  final String email;
  final String rol;

  UserModel({
    required this.uid,
    required this.nombre,
    required this.email,
    required this.rol,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    String readString(dynamic value, [String defaultValue = '']) {
      if (value == null) return defaultValue;
      return value.toString();
    }

    return UserModel(
      // algunos backends usan "id" en lugar de "uid"
      uid: readString(json['uid'] ?? json['id']),
      nombre: readString(json['nombre'] ?? json['name']),
      email: readString(json['email']),
      rol: readString(json['rol'] ?? json['role']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'uid': uid, 'nombre': nombre, 'email': email, 'rol': rol};
  }
}
