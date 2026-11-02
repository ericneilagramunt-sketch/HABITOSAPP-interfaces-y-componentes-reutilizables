import 'package:flutter/material.dart';
import '../modelos/usuario.dart';
import '../servicios/usuario_service.dart';
import '../widgets/boton_principal.dart';
import '../widgets/campo_texto_app.dart';

/// Registro de un usuario nuevo (rol "usuario").
class RegistroPage extends StatefulWidget {
  const RegistroPage({super.key});

  @override
  State<RegistroPage> createState() => _RegistroPageState();
}

class _RegistroPageState extends State<RegistroPage> {
  final _usuarioController = TextEditingController();
  final _nombreController = TextEditingController();
  final _apellidosController = TextEditingController();
  final _emailController = TextEditingController();
  final _claveController = TextEditingController();
  String _mensaje = '';

  @override
  void dispose() {
    _usuarioController.dispose();
    _nombreController.dispose();
    _apellidosController.dispose();
    _emailController.dispose();
    _claveController.dispose();
    super.dispose();
  }

  Future<void> _registrar() async {
    final usuario = _usuarioController.text.trim();
    final nombre = _nombreController.text.trim();
    final apellidos = _apellidosController.text.trim();
    final email = _emailController.text.trim();
    final clave = _claveController.text.trim();

    if (usuario.isEmpty ||
        nombre.isEmpty ||
        apellidos.isEmpty ||
        email.isEmpty ||
        clave.isEmpty) {
      setState(() => _mensaje = 'Rellena todos los campos');
      return;
    }

    final servicio = UsuarioService();
    final existente = await servicio.buscarPorUsuario(usuario);
    if (existente != null) {
      setState(() => _mensaje = 'Ese usuario ya existe');
      return;
    }

    await servicio.crear(Usuario(
      usuario: usuario,
      nombre: nombre,
      apellidos: apellidos,
      email: email,
      contrasena: clave,
      // La fecha de creación se asigna automáticamente
      fechaCreacion: DateTime.now().toIso8601String(),
      rol: Usuario.rolUsuario,
    ));

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Registro correcto. Ya puedes entrar.')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registro')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CampoTextoApp(etiqueta: 'Usuario', controlador: _usuarioController),
            CampoTextoApp(etiqueta: 'Nombre', controlador: _nombreController),
            CampoTextoApp(
                etiqueta: 'Apellidos', controlador: _apellidosController),
            CampoTextoApp(etiqueta: 'Email', controlador: _emailController),
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
            BotonPrincipal(texto: 'Registrarse', alPulsar: _registrar),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Volver al inicio de sesión'),
            ),
          ],
        ),
      ),
    );
  }
}
