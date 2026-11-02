import 'package:flutter/material.dart';
import '../modelos/usuario.dart';
import '../servicios/usuario_service.dart';
import '../widgets/boton_principal.dart';
import '../widgets/campo_texto_app.dart';

/// Formulario para crear (usuario == null) o editar un usuario (admin).
class UsuarioFormPage extends StatefulWidget {
  final Usuario? usuario;

  const UsuarioFormPage({super.key, this.usuario});

  @override
  State<UsuarioFormPage> createState() => _UsuarioFormPageState();
}

class _UsuarioFormPageState extends State<UsuarioFormPage> {
  late final TextEditingController _usuarioController;
  late final TextEditingController _nombreController;
  late final TextEditingController _apellidosController;
  late final TextEditingController _emailController;
  late final TextEditingController _claveController;
  late String _rol;
  String _mensaje = '';

  @override
  void initState() {
    super.initState();
    final u = widget.usuario;
    _usuarioController = TextEditingController(text: u?.usuario ?? '');
    _nombreController = TextEditingController(text: u?.nombre ?? '');
    _apellidosController = TextEditingController(text: u?.apellidos ?? '');
    _emailController = TextEditingController(text: u?.email ?? '');
    _claveController = TextEditingController(text: u?.contrasena ?? '');
    _rol = u?.rol ?? Usuario.rolUsuario;
  }

  @override
  void dispose() {
    _usuarioController.dispose();
    _nombreController.dispose();
    _apellidosController.dispose();
    _emailController.dispose();
    _claveController.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
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

    // El nombre de usuario no puede repetirse
    final existente = await servicio.buscarPorUsuario(usuario);
    if (existente != null && existente.id != widget.usuario?.id) {
      setState(() => _mensaje = 'Ese usuario ya existe');
      return;
    }

    if (widget.usuario == null) {
      await servicio.crear(Usuario(
        usuario: usuario,
        nombre: nombre,
        apellidos: apellidos,
        email: email,
        contrasena: clave,
        fechaCreacion: DateTime.now().toIso8601String(),
        rol: _rol,
      ));
    } else {
      final u = widget.usuario!;
      u.usuario = usuario;
      u.nombre = nombre;
      u.apellidos = apellidos;
      u.email = email;
      u.contrasena = clave;
      u.rol = _rol;
      await servicio.actualizar(u);
    }

    if (!mounted) return;
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.usuario == null ? 'Nuevo usuario' : 'Editar usuario'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
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
            const SizedBox(height: 8),
            const Text('Rol'),
            DropdownButton<String>(
              value: _rol,
              isExpanded: true,
              items: const [
                DropdownMenuItem(
                    value: Usuario.rolUsuario, child: Text('usuario')),
                DropdownMenuItem(
                    value: Usuario.rolAdmin, child: Text('administrador')),
              ],
              onChanged: (valor) {
                if (valor != null) setState(() => _rol = valor);
              },
            ),
            if (_mensaje.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(_mensaje, style: const TextStyle(color: Colors.red)),
              ),
            const SizedBox(height: 16),
            BotonPrincipal(texto: 'Guardar', alPulsar: _guardar),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
          ],
        ),
      ),
    );
  }
}
