import 'package:flutter/material.dart';
import '../servicios/sesion_service.dart';
import '../servicios/usuario_service.dart';
import '../widgets/boton_principal.dart';
import '../widgets/campo_texto_app.dart';
import 'habitos_page.dart';
import 'registro_page.dart';

/// Inicio de sesión.
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usuarioController = TextEditingController();
  final _claveController = TextEditingController();
  String _mensaje = '';

  @override
  void dispose() {
    _usuarioController.dispose();
    _claveController.dispose();
    super.dispose();
  }

  Future<void> _entrar() async {
    final usuario = _usuarioController.text.trim();
    final clave = _claveController.text.trim();

    if (usuario.isEmpty || clave.isEmpty) {
      setState(() => _mensaje = 'Faltan datos');
      return;
    }

    final encontrado = await UsuarioService().iniciarSesion(usuario, clave);
    if (!mounted) return;
    if (encontrado == null) {
      setState(() => _mensaje = 'Usuario o contraseña incorrectos');
      return;
    }

    // Se guarda quién ha entrado (SharedPreferences) para recordar la sesión
    await SesionService().guardarUsuarioId(encontrado.id!);
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => HabitosPage(usuario: encontrado)),
    );
  }

  void _abrirRegistro() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const RegistroPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Iniciar sesión')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 24),
            const Icon(Icons.auto_awesome, size: 80, color: Colors.blue),
            const SizedBox(height: 16),
            const Text(
              'HábitosApp',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            CampoTextoApp(etiqueta: 'Usuario', controlador: _usuarioController),
            CampoTextoApp(
              etiqueta: 'Contraseña',
              controlador: _claveController,
              ocultar: true,
            ),
            if (_mensaje.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  _mensaje,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            BotonPrincipal(texto: 'Acceder', alPulsar: _entrar),
            TextButton(
              onPressed: _abrirRegistro,
              child: const Text('¿No tienes cuenta? Regístrate'),
            ),
          ],
        ),
      ),
    );
  }
}
