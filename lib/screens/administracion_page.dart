import 'package:flutter/material.dart';
import '../models/usuario.dart';
import '../services/usuario_service.dart';
import '../services/preferencias_service.dart';
import 'login_page.dart';
import 'registro_page.dart';
import 'administrar_habitos_usuario_page.dart';
// Pantalla reservada para la cuenta de administrador.
class AdministracionPage extends StatefulWidget {
  const AdministracionPage({super.key});
  @override
  State<AdministracionPage> createState() => _AdministracionPageState();
}
class _AdministracionPageState extends State<AdministracionPage> {
  final _usuariosService = UsuarioService();
  final _preferencias = PreferenciasService();
  List<Usuario> _usuarios = [];
  Map<String, int> _habitosPorUsuario = {};
  bool _cargando = true;
  @override
  void initState() {
    super.initState();
    _cargar();
  }
  Future<void> _cargar() async {
    final actual = await _usuariosService.usuarioActual();
    if (actual == null || !actual.administrador) {
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (_) => const LoginPage()), (route) => false);
      return;
    }
    final usuarios = await _usuariosService.obtenerUsuarios();
    final Map<String, int> cantidades = {};
    for (final usuario in usuarios) {
      cantidades[usuario.id] =
          (await _preferencias.getHabitos(usuarioId: usuario.id)).length;
    }
    if (!mounted) return;
    setState(() {
      _usuarios = usuarios;
      _habitosPorUsuario = cantidades;
      _cargando = false;
    });
  }
  Future<void> _eliminar(Usuario usuario) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Eliminar usuario'),
        content: Text('¿Quieres eliminar la cuenta de ${usuario.nombre}?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Eliminar')),
        ],
      ),
    );
    if (confirmar == true) {
      await _usuariosService.eliminarUsuario(usuario.id);
      _cargar();
  }
  }
  Future<void> _editarNombre(Usuario usuario) async {
    final controller = TextEditingController(text: usuario.nombre);
    final nuevo = await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Editar usuario'),
        content: TextField(controller: controller, decoration: const InputDecoration(labelText: 'Nombre')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          TextButton(onPressed: () => Navigator.pop(context, controller.text.trim()), child: const Text('Guardar')),
        ],
      ),
    );
    controller.dispose();
    if (nuevo == null || nuevo.isEmpty) return;
    final lista = await _usuariosService.obtenerUsuarios();
    final indice = lista.indexWhere((u) => u.id == usuario.id);
    if (indice >= 0) {
      final u = lista[indice];
      lista[indice] = Usuario(
        id: u.id, nombre: nuevo, correo: u.correo,
        contrasena: u.contrasena, fechaCreacion: u.fechaCreacion,
        administrador: u.administrador,
      );
      await _usuariosService.guardarUsuarios(lista);
      _cargar();
    }
  }
  Future<void> _salir() async {
    await _usuariosService.cerrarSesion();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (_) => const LoginPage()), (route) => false);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Administración'),
        actions: [IconButton(onPressed: _salir, icon: const Icon(Icons.logout), tooltip: 'Cerrar sesión')],
      ),
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(child: ListTile(
            leading: const Icon(Icons.people),
            title: const Text('Usuarios registrados'),
            trailing: Text('${_usuarios.length}'),
          )),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Gestión de usuarios', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              IconButton(
                tooltip: 'Crear usuario',
                icon: const Icon(Icons.person_add),
                onPressed: () async {
                  await Navigator.push(context, MaterialPageRoute(builder: (_) => const RegistroPage()));
                  _cargar();
                },
              ),
            ],
          ),
          ..._usuarios.map((u) => Card(
            child: ListTile(
              leading: Icon(u.administrador ? Icons.admin_panel_settings : Icons.person),
              title: Text(u.nombre),
              onTap: () => Navigator.push(context, MaterialPageRoute(
                builder: (_) => AdministrarHabitosUsuarioPage(usuario: u),
              )).then((_) => _cargar()),
              subtitle: Text('${u.correo}\nCreado: ${u.fechaCreacion.split('T').first}\nHábitos: ${_habitosPorUsuario[u.id] ?? 0}'),
              isThreeLine: true,
              trailing: u.administrador
                  ? const Text('Admin')
                  : PopupMenuButton<String>(
                onSelected: (opcion) {
                  if (opcion == 'editar') _editarNombre(u);
                  if (opcion == 'eliminar') _eliminar(u);
                },
                itemBuilder: (_) => const [
                  PopupMenuItem(value: 'editar', child: Text('Editar')),
                  PopupMenuItem(value: 'eliminar', child: Text('Eliminar')),
                ],
              ),
            ),
          )),
          const SizedBox(height: 12),
          const Text(
            'Nota: esta versión de la actividad utiliza almacenamiento local. '
                'La gestión completa de hábitos por usuario debe conectarse a la persistencia de Acceso a Datos.',
          ),
        ],
      ),
    );
  }
}