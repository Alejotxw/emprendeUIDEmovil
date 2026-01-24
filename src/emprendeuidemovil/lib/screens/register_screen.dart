import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  bool rolVendedor = true;
  bool rolComprador = false;
  bool loading = false;

  final _authService = AuthService();

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _onRegister() async {
    if (!_formKey.currentState!.validate()) return;

    final email = _emailCtrl.text.trim();
    if (!email.endsWith('@uide.edu.ec')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Debe usar un correo institucional @uide.edu.ec'),
        ),
      );
      return;
    }

    // --- Determinar UN solo rol ---
    String? rolSeleccionado;
    if (rolVendedor && !rolComprador) {
      rolSeleccionado = 'vendedor';
    } else if (!rolVendedor && rolComprador) {
      rolSeleccionado = 'comprador';
    } else {
      // o ninguno marcado, o los dos marcados
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Debe elegir solo un rol: vendedor o comprador'),
        ),
      );
      return;
    }

    try {
      setState(() => loading = true);

      final UserModel user = await _authService.register(
        nombre: _nombreCtrl.text.trim(),
        email: email,
        password: _passwordCtrl.text,
        rol: rolSeleccionado, // <-- ahora sí mandamos UN rol válido
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Usuario ${user.nombre} registrado con éxito')),
      );

      // Después de registrarse, lo mando al login
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF90063a);
    const buttonColor = Color(0xFFdaa520);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro'),
        backgroundColor: primaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nombreCtrl,
                decoration: const InputDecoration(labelText: 'Nombre completo'),
                validator: (value) => (value == null || value.isEmpty)
                    ? 'Campo obligatorio'
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _emailCtrl,
                decoration: const InputDecoration(
                  labelText: 'Correo institucional',
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) => (value == null || value.isEmpty)
                    ? 'Campo obligatorio'
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _passwordCtrl,
                decoration: const InputDecoration(labelText: 'Contraseña'),
                obscureText: true,
                validator: (value) => (value == null || value.length < 6)
                    ? 'Mínimo 6 caracteres'
                    : null,
              ),
              const SizedBox(height: 16),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Selecciona tu rol',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              CheckboxListTile(
                title: const Text('Vendedor'),
                value: rolVendedor,
                onChanged: (val) {
                  setState(() {
                    rolVendedor = val ?? false;
                    if (rolVendedor) rolComprador = false; // solo uno a la vez
                  });
                },
              ),
              CheckboxListTile(
                title: const Text('Comprador'),
                value: rolComprador,
                onChanged: (val) {
                  setState(() {
                    rolComprador = val ?? false;
                    if (rolComprador) rolVendedor = false; // solo uno a la vez
                  });
                },
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: loading ? null : _onRegister,
                  child: loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Registrarme',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
