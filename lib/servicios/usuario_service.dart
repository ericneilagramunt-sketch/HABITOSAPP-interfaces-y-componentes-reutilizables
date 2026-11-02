import '../modelos/usuario.dart';
import 'base_datos.dart';

/// CRUD de la tabla usuarios.
class UsuarioService {
  // CREATE
  Future<int> crear(Usuario u) async {
    final db = await BaseDatos.abrir();
    return db.insert('usuarios', u.toMap());
  }

  // READ (todos)
  Future<List<Usuario>> obtenerTodos() async {
    final db = await BaseDatos.abrir();
    final filas = await db.query('usuarios');
    return filas.map((f) => Usuario.fromMap(f)).toList();
  }

  // READ (uno por id)
  Future<Usuario?> obtenerPorId(int id) async {
    final db = await BaseDatos.abrir();
    final filas = await db.query('usuarios', where: 'id = ?', whereArgs: [id]);
    if (filas.isEmpty) return null;
    return Usuario.fromMap(filas.first);
  }

  // READ (uno por nombre de usuario)
  Future<Usuario?> buscarPorUsuario(String usuario) async {
    final db = await BaseDatos.abrir();
    final filas =
        await db.query('usuarios', where: 'usuario = ?', whereArgs: [usuario]);
    if (filas.isEmpty) return null;
    return Usuario.fromMap(filas.first);
  }

  // Login: devuelve null si el usuario o la contraseña no coinciden
  Future<Usuario?> iniciarSesion(String usuario, String contrasena) async {
    final db = await BaseDatos.abrir();
    final filas = await db.query(
      'usuarios',
      where: 'usuario = ? AND contrasena = ?',
      whereArgs: [usuario, contrasena],
    );
    if (filas.isEmpty) return null;
    return Usuario.fromMap(filas.first);
  }

  // UPDATE
  Future<void> actualizar(Usuario u) async {
    final db = await BaseDatos.abrir();
    await db.update('usuarios', u.toMap(), where: 'id = ?', whereArgs: [u.id]);
  }

  // DELETE: también borra los hábitos del usuario y sus estadísticas
  Future<void> eliminar(int id) async {
    final db = await BaseDatos.abrir();
    final habitos =
        await db.query('habitos', where: 'usuario_id = ?', whereArgs: [id]);
    for (final h in habitos) {
      await db.delete('estadisticas',
          where: 'habito_id = ?', whereArgs: [h['id']]);
    }
    await db.delete('habitos', where: 'usuario_id = ?', whereArgs: [id]);
    await db.delete('usuarios', where: 'id = ?', whereArgs: [id]);
  }
}
