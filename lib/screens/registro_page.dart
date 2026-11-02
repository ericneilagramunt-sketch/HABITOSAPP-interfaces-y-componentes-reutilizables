import 'package:flutter/material.dart';
import '../services/usuario_service.dart';
import '../widgets/campo_texto_app.dart';
import '../widgets/boton_principal.dart';
// Formulario para registrar una cuenta nueva.
class RegistroPage extends StatefulWidget {
  const RegistroPage({super.key});
  @override
  State<RegistroPage> createState() => _RegistroPageState();
}
class _RegistroPageState extends State<RegistroPage> {
  final _nombre = TextEditingController();
  final _correo = TextEditingController();
  final _contrasena = TextEditingController();
  final _servicio = UsuarioService();
  String? _mensaje;
  @override
  void dispose() {
    _nombre.dispose();
    _correo.dispose();
    _contrasena.dispose();
    super.dispose();
  }
  Future<void> _registrar() async {
    if (_nombre.text.trim().isEmpty ||
        _correo.text.trim().isEmpty ||
        _contrasena.text.isEmpty) {
      setState(() => _mensaje = 'Rellena todos los campos.');
      return;
    }
    final error = await _servicio.registrar(
      _nombre.text.trim(), _correo.text.trim(), _contrasena.text,
    );
    if (!mounted) return;
    if (error != null) {
      setState(() => _mensaje = error);
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Cuenta creada. Ya puedes iniciar sesión.')),
    );
    Navigator.pop(context);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crear cuenta')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          CampoTextoApp(etiqueta: 'Nombre', controller: _nombre),
          const SizedBox(height: 16),
          CampoTextoApp(etiqueta: 'Correo electrónico', controller: _correo),
          const SizedBox(height: 16),
          CampoTextoApp(etiqueta: 'Contraseña', controller: _contrasena, ocultar: true),
          if (_mensaje != null) ...[
            const SizedBox(height: 12),
            Text(_mensaje!, style: const TextStyle(color: Colors.red)),
          ],
          const SizedBox(height: 20),
          BotonPrincipal(texto: 'Registrarse', onPressed: _registrar),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Volver al inicio de sesión'),
          ),
        ],
      ),
    );
  }
}