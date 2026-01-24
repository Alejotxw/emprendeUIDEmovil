import '../models/user_model.dart';

class AuthService {
  Future<UserModel> register({
    required String email,
    required String password,
    required String name,
  }) async {
    // Mock: Simula registro exitoso
    await Future.delayed(const Duration(seconds: 1));
    return UserModel(id: 'mock_id', email: email, name: name);
  }

  Future<UserModel?> login({required String email, required String password}) async {
    // Mock login
    await Future.delayed(const Duration(seconds: 1));
    if (email == 'test@example.com' && password == '123') {
      return UserModel(id: 'user1', email: email, name: 'Test User');
    }
    return null;
  }
}
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

class AuthService {
  static const String baseUrl = 'http://10.0.2.2:4000';

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final uri = Uri.parse('$baseUrl/auth/login');

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    print('STATUS LOGIN: ${response.statusCode}');
    print('BODY LOGIN: ${response.body}');

    try {
      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final dynamic rawUser = data['user'] ?? data;

        if (rawUser is Map) {
          final userJson = rawUser.map(
            (key, value) => MapEntry(key.toString(), value),
          );
          return UserModel.fromJson(userJson);
        } else {
          return UserModel(uid: '', nombre: '', email: '', rol: '');
        }
      } else {
        throw data['message'] ?? 'Error al iniciar sesión';
      }
    } catch (e, st) {
      print('ERROR EN AuthService.login: $e');
      print('STACKTRACE: $st');
      rethrow; // se vuelve a lanzar, para que llegue al SnackBar
    }
  }

  Future<UserModel> register({
    required String nombre,
    required String email,
    required String password,
    required String rol,
  }) async {
    final uri = Uri.parse('$baseUrl/auth/register');

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nombre': nombre,
        'email': email,
        'password': password,
        'rol': rol, // "vendedor" o "comprador"
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      final dynamic rawUser = data['user'] ?? data;
      if (rawUser is Map) {
        final userJson = rawUser.map(
          (key, value) => MapEntry(key.toString(), value),
        );
        return UserModel.fromJson(userJson);
      } else {
        return UserModel(uid: '', nombre: '', email: '', rol: '');
      }
    } else {
      throw data['message'] ?? 'Error al registrar usuario';
    }
  }
}