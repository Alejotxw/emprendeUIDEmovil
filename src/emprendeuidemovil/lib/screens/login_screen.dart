import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../providers/user_role_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Estado: true = Login, false = Registro
  bool _isLogin = true;
  bool _isLoading = false;

  // Controladores
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController(); // Solo registro
  final TextEditingController _phoneController = TextEditingController(); // Solo registro

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _submit() async {
    setState(() => _isLoading = true);

    try {
      if (_isLogin) {
        // --- LOGIN ---
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        // Verificar rol en Firestore
        DocumentSnapshot doc = await _firestore.collection('users').doc(userCredential.user!.uid).get();
        
        if (mounted) {
          final roleProvider = Provider.of<UserRoleProvider>(context, listen: false);
          String role = 'cliente'; // Default
          
          if (doc.exists && doc.data() != null) {
            final data = doc.data() as Map<String, dynamic>;
            role = data['rol'] ?? 'cliente';
          }

          // Force admin role if it's the official admin email
          if (userCredential.user!.email == 'admin@uide.edu.ec') {
            role = 'admin';
          }

          if (role == 'admin') {
            roleProvider.setRole(UserRole.emprendedor); // The app uses emprendedor role enum for admin screens too
            Navigator.pushReplacementNamed(context, '/admin');
          } else if (role == 'emprendedor') {
            roleProvider.setRole(UserRole.emprendedor);
            Navigator.pushReplacementNamed(context, '/main');
          } else {
            roleProvider.setRole(UserRole.cliente);
            Navigator.pushReplacementNamed(context, '/main');
          }
        }

      } else {
        // --- REGISTRO ---
        final email = _emailController.text.trim();
        final password = _passwordController.text.trim();
        final name = _nameController.text.trim();
        final phone = _phoneController.text.trim();

        // 1. Validaciones básicas
        if (!email.endsWith('@uide.edu.ec')) {
          throw FirebaseAuthException(
              code: 'invalid-email-domain', 
              message: 'Debes usar un correo institucional (@uide.edu.ec)');
        }
        
        // Block unauthorized admin registrations
        if (email.toLowerCase().startsWith('admin') && email.toLowerCase() != 'admin@uide.edu.ec') {
          throw FirebaseAuthException(
              code: 'reserved-email', 
              message: 'Este correo está reservado.');
        }

        if (name.isEmpty || phone.isEmpty) {
          throw FirebaseAuthException(
              code: 'missing-fields', 
              message: 'Nombre y Teléfono son obligatorios');
        }

        // 2. Crear usuario Auth
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Determinar rol: SÓLO admin@uide.edu.ec puede ser admin
        String role = (email.toLowerCase() == 'admin@uide.edu.ec') ? 'admin' : 'cliente';

        // 3. Guardar datos en Firestore
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'nombre': name,
          'phone': phone,
          'email': email,
          'rol': role, 
          'createdAt': FieldValue.serverTimestamp(),
          'imagePath': '', 
        });

        // 4. Navegar según Rol
        if (mounted) {
           final roleProvider = Provider.of<UserRoleProvider>(context, listen: false);
           if (role == 'admin') {
             roleProvider.setRole(UserRole.emprendedor);
             Navigator.pushReplacementNamed(context, '/admin');
           } else {
             roleProvider.setRole(UserRole.cliente);
             Navigator.pushReplacementNamed(context, '/main');
           }
        }
      }
    } on FirebaseAuthException catch (e) {
      String message = e.message ?? 'Ocurrió un error';
      if (e.code == 'invalid-email-domain') message = 'Usa tu correo @uide.edu.ec';
      if (e.code == 'weak-password') message = 'La contraseña es muy débil';
      if (e.code == 'email-already-in-use') message = 'Este correo ya está registrado';
      if (e.code == 'user-not-found') message = 'Usuario no encontrado';
      if (e.code == 'wrong-password') message = 'Contraseña incorrecta';
      if (e.code == 'network-request-failed') message = 'Sin conexión a internet. Verifica tu Wi-Fi o datos.';

      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.red),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF90063a),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              Text(
                _isLogin ? 'Iniciar Sesión' : 'Registro',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),

              // Campos exclusivos de Registro
              if (!_isLogin) ...[
                _buildTextField(_nameController, Icons.person, 'Nombre Completo'),
                const SizedBox(height: 20),
                _buildTextField(_phoneController, Icons.phone, 'Teléfono'),
                const SizedBox(height: 20),
              ],

              // Campos comunes
              _buildTextField(_emailController, Icons.email, 'Correo Institucional'),
              const SizedBox(height: 20),
              _buildTextField(_passwordController, Icons.lock, 'Contraseña', isPassword: true),

              const SizedBox(height: 30),

              // Botón Principal (Ingresar / Registrarse)
              if (_isLoading)
                const CircularProgressIndicator(color: Colors.white)
              else
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFdaa520),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: _submit,
                    child: Text(
                      _isLogin ? 'Ingresar' : 'Registrarme',
                      style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),

              const SizedBox(height: 20),

              // Botón Toggle (Cambiar modo)
              TextButton(
                onPressed: () {
                  setState(() {
                    _isLogin = !_isLogin;
                  });
                },
                child: Text(
                  _isLogin ? '¿No tienes cuenta? Registrate' : '¿Ya tienes cuenta? Ingresa',
                  style: const TextStyle(color: Colors.white, fontSize: 16, decoration: TextDecoration.underline),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, IconData icon, String hint, {bool isPassword = false}) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      keyboardType: (!isPassword && hint.contains('Correo')) ? TextInputType.emailAddress : TextInputType.text,
      style: const TextStyle(color: Colors.black), // Texto visible sobre fondo blanco
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: const Color(0xFF90063a)), // Icono rojo institucional
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey), // Hint gris
        filled: true,
        fillColor: Colors.white, // Fondo BLANCO
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
      ),
    );
  }
}