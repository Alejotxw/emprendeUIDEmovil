import 'package:flutter/material.dart';
import '../main.dart'; // Import para MainScreen (ajusta si es necesario)

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _showWelcome = true; // True para vista inicial, false para formulario
  bool _isSignIn = true; // True para Sign In, false para Sign Up
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  bool _rememberMe = false;
  bool _agreeTerms = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _toggleView() {
    setState(() {
      _isSignIn = !_isSignIn;
      _clearFields(); // Limpia campos al cambiar
    });
  }

  void _toggleWelcome(bool isSignIn) {
    setState(() {
      _showWelcome = false;
      _isSignIn = isSignIn;
      _clearFields(); // Limpia campos al cambiar
    });
  }

  void _clearFields() {
    _emailController.clear();
    _passwordController.clear();
    _nameController.clear();
    _agreeTerms = false;
    _rememberMe = false;
  }

  void _backToWelcome() {
    setState(() {
      _showWelcome = true;
      _clearFields();
    });
  }

  void _handleSignIn() {
    if (_formKey.currentState!.validate()) {
      // Simula login exitoso
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('¡Bienvenido! Iniciando sesión...'), backgroundColor: Colors.green),
      );
      // Navega a MainScreen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
    }
  }

  void _handleSignUp() {
    if (_formKey.currentState!.validate() && _agreeTerms) {
      // Simula registro exitoso
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('¡Registro exitoso! Verifica tu email.'), backgroundColor: Colors.green),
      );
      // Regresa a vista inicial
      _backToWelcome();
    } else if (!_agreeTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Debes aceptar los términos.'), backgroundColor: Colors.red),
      );
    }
  }

  void _handleForgotPassword() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Olvidé Contraseña'),
        content: const Text('Enviamos un link de reset a tu email. ¿Continuar?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Link enviado a tu email.'), backgroundColor: Colors.green),
              );
            },
            child: const Text('Enviar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue, Colors.purple],
          ),
        ),
        child: SafeArea(
          child: _showWelcome ? _buildWelcomeView() : _buildFormView(),
        ),
      ),
    );
  }

  // Vista inicial con opciones (de la imagen)
  Widget _buildWelcomeView() {
    return Column(
      children: [
        // Header con ondas abstractas
        Expanded(
          child: CustomPaint(
            painter: WavePainter(),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Welcome Back!',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Enter personal details to your employee account',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                ],
              ),
            ),
          ),
        ),
        // Botones Sign in y Sign up (funcionales)
        Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ElevatedButton(
                    onPressed: () => _toggleWelcome(true), // Activa Sign In
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: const Text(
                      'Sign in',
                      style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: OutlinedButton(
                    onPressed: () => _toggleWelcome(false), // Activa Sign Up
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.blue),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: const Text(
                      'Sign up',
                      style: TextStyle(fontSize: 16, color: Colors.blue, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Vista de formulario (Sign In o Sign Up)
  Widget _buildFormView() {
    return Column(
      children: [
        Expanded(
          child: CustomPaint(
            painter: WavePainter(),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _isSignIn ? 'Welcome Back!' : 'Get Started',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _isSignIn
                        ? 'Enter personal details to your employee account'
                        : 'Enter your personal details to you employee account',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                ],
              ),
            ),
          ),
        ),
        // Formulario
        Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  if (!_isSignIn) ...[
                    // Full Name solo en Sign Up
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Full Name',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) => value!.isEmpty ? 'Nombre requerido' : null,
                    ),
                    const SizedBox(height: 16),
                  ],
                  // Email
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => value!.isEmpty ? 'Email requerido' : null,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  // Password
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => value!.length < 6 ? 'Mínimo 6 caracteres' : null,
                  ),
                  const SizedBox(height: 16),
                  if (!_isSignIn) ...[
                    // Checkbox términos en Sign Up
                    Row(
                      children: [
                        Checkbox(
                          value: _agreeTerms,
                          onChanged: (value) => setState(() => _agreeTerms = value!),
                          activeColor: Colors.blue,
                        ),
                        const Expanded(
                          child: Text('I agree to the processing of personal data'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ] else ...[
                    // Remember me y Forgot en Sign In
                    Row(
                      children: [
                        Checkbox(
                          value: _rememberMe,
                          onChanged: (value) => setState(() => _rememberMe = value!),
                          activeColor: Colors.blue,
                        ),
                        const Text('Remember me'),
                      ],
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: _handleForgotPassword,
                        child: const Text('Forgot password?'),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                  // Botón principal
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isSignIn ? _handleSignIn : _handleSignUp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                      ),
                      child: Text(
                        _isSignIn ? 'Sign in' : 'Sign up',
                        style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Botón back a bienvenida
                  TextButton(
                    onPressed: _backToWelcome,
                    child: const Text('Back to options'),
                  ),
                  const SizedBox(height: 24),
                  // Botones sociales
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _SocialButton(icon: Icons.facebook, color: Colors.blue),
                      _SocialButton(icon: Icons.alternate_email, color: Colors.lightBlue), // Twitter simulado
                      _SocialButton(icon: Icons.account_circle, color: Colors.red), // Google
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Link alterno
                  TextButton(
                    onPressed: _toggleView, // Fix: Ahora definido y accesible
                    child: Text(
                      _isSignIn ? "Don't have an account? Sign up" : "Already have an account? Sign in",
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// Widget para ondas abstractas
class WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withOpacity(0.1);
    final path = Path();
    path.moveTo(0, size.height * 0.3);
    path.quadraticBezierTo(size.width * 0.25, size.height * 0.2, size.width * 0.5, size.height * 0.4);
    path.quadraticBezierTo(size.width * 0.75, size.height * 0.6, size.width, size.height * 0.3);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Widget para botones sociales
class _SocialButton extends StatelessWidget {
  final IconData icon;
  final Color color;

  const _SocialButton({required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Iniciando con ${icon == Icons.facebook ? 'Facebook' : icon == Icons.alternate_email ? 'Twitter' : 'Google'}')),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color, size: 24),
      ),
    );
  }
}