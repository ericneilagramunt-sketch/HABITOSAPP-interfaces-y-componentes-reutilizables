import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/usuario.dart';
// Servicio local para el registro, acceso y administración de cuentas.
// En esta versión se usa SharedPreferences; no sustituye la base de datos
// que pueda haberse creado en la actividad de Acceso a Datos.
class UsuarioService {
  static const _claveUsuarios = 'act02_usuarios';
  static const _claveSesion = 'act02_usuario_sesion';
  Future<List<Usuario>> obtenerUsuarios() async {
    final prefs = await SharedPreferences.getInstance();
    final datos = prefs.getStringList(_claveUsuarios) ?? [];
    final usuarios = datos
        .map((dato) => Usuario.fromJson(jsonDecode(dato)))
        .toList();
// Crea una cuenta de administrador inicial si todavía no existe.
    if (!usuarios.any((u) => u.administrador)) {
      usuarios.add(Usuario(
        id: 'admin-inicial',
        nombre: 'Administrador',
        correo: 'admin@habitosapp.com',
        contrasena: 'admin123',
        fechaCreacion: DateTime.now().toIso8601String(),
        administrador: true,
      ));
      await guardarUsuarios(usuarios);
    }
    return usuarios;
  }
  Future<void> guardarUsuarios(List<Usuario> usuarios) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _claveUsuarios,
      usuarios.map((u) => jsonEncode(u.toJson())).toList(),
    );
  }
  Future<String?> registrar(String nombre, String correo, String contrasena) async {
    final usuarios = await obtenerUsuarios();
    if (usuarios.any((u) => u.correo.toLowerCase() == correo.toLowerCase())) {
      return 'Ya existe una cuenta con ese correo.';
    }
    usuarios.add(Usuario(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      nombre: nombre,
      correo: correo,
      contrasena: contrasena,
      fechaCreacion: DateTime.now().toIso8601String(),
    ));
    await guardarUsuarios(usuarios);
    return null;
  }
  Future<Usuario?> iniciarSesion(String correo, String contrasena) async {
    final usuarios = await obtenerUsuarios();
    for (final usuario in usuarios) {
      if (usuario.correo.toLowerCase() == correo.toLowerCase() &&
          usuario.contrasena == contrasena) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_claveSesion, usuario.id);
        return usuario;
      }
    }
    return null;
  }
  Future<Usuario?> usuarioActual() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getString(_claveSesion);
    if (id == null) return null;
    for (final usuario in await obtenerUsuarios()) {
      if (usuario.id == id) return usuario;
    }
    return null;
  }
  Future<void> cerrarSesion() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_claveSesion);
  }
  Future<void> eliminarUsuario(String id) async {
    final usuarios = await obtenerUsuarios();
    usuarios.removeWhere((u) => u.id == id && !u.administrador);
    await guardarUsuarios(usuarios);
  }
}