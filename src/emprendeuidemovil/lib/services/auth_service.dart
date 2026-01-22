import '../models/user_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  final String baseUrl = "http://10.0.2.2:4000"; // emulador Android

  Future<UserModel?> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return UserModel.fromJson(data["user"]);
      } else {
        return null;
      }
    } catch (e) {
      throw Exception("Error de conexión");
    }
  }

  Future<UserModel?> register({
    required String nombre,
    required String email,
    required String password,
    required String rol,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "nombre": nombre,
        "email": email,
        "password": password,
        "rol": rol, // 👈 aquí va SÍ o SÍ
      }),
    );

    print("STATUS CODE: ${response.statusCode}");
    print("BODY: ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return UserModel.fromJson(data["user"]);
    } else {
      final data = jsonDecode(response.body);
      throw Exception(data["message"]);
    }
  }
}
