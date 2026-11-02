import 'package:flutter/material.dart';
import '../models/usuario.dart';
import '../services/usuario_service.dart';
import '../services/preferencias_service.dart';
import '../widgets/campo_texto_app.dart';
import '../widgets/boton_principal.dart';
import 'principal_screen.dart';
import 'registro_page.dart';
import 'administracion_page.dart';
// Pantalla de inicio de sesión.
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}
class _LoginPageState extends State<LoginPage> {
  final _correo = TextEditingController();
  final _contrasena = TextEditingController();
  final _servicio = UsuarioService();
  String? _error;
  bool _cargando = false;
  @override
  void dispose() {
    _correo.dispose();
    _contrasena.dispose();
    super.dispose();
  }
  Future<void> _entrar() async {
    if (_correo.text.trim().isEmpty || _contrasena.text.isEmpty) {
      setState(() => _error = 'Introduce el correo y la contraseña.');
      return;
    }
    setState(() { _cargando = true; _error = null; });
    final Usuario? usuario = await _servicio.iniciarSesion(
      _correo.text.trim(), _contrasena.text,
    );
    if (!mounted) return;
    setState(() => _cargando = false);
    if (usuario == null) {
      setState(() => _error = 'El correo o la contraseña no son correctos.');
      return;
    }
    await PreferenciasService().setNombreUsuario(usuario.nombre);
    final destino = usuario.administrador
        ? const AdministracionPage()
        : const PrincipalScreen();
    Navigator.pushAndRemoveUntil(
      context, MaterialPageRoute(builder: (_) => destino), (route) => false,
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Iniciar sesión')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Icon(Icons.track_changes, size: 70),
          const SizedBox(height: 20),
          CampoTextoApp(etiqueta: 'Correo electrónico', controller: _correo),
          const SizedBox(height: 16),
          CampoTextoApp(etiqueta: 'Contraseña', controller: _contrasena, ocultar: true),
          if (_error != null) ...[
            const SizedBox(height: 12),
            Text(_error!, style: const TextStyle(color: Colors.red)),
          ],
          const SizedBox(height: 20),
          BotonPrincipal(
            texto: _cargando ? 'Comprobando...' : 'Iniciar sesión',
            onPressed: _cargando ? () {} : _entrar,
          ),
          TextButton(
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const RegistroPage())),
            child: const Text('¿No tienes cuenta? Regístrate'),
          ),
          const SizedBox(height: 12),
          const Text(
            'Cuenta inicial de administrador: admin@habitosapp.com / admin123',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}