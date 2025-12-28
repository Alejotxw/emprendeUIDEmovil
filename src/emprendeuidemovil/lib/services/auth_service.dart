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

  Future<UserModel?> login({
    required String email,
    required String password,
  }) async {
    // Mock login
    await Future.delayed(const Duration(seconds: 1));
    if (email == 'test@example.com' && password == '123') {
      return UserModel(id: 'user1', email: email, name: 'Test User');
    }
    return null;
  }
}