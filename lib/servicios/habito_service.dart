import '../modelos/habito.dart';
import 'base_datos.dart';
import 'estadistica_service.dart';

/// CRUD de la tabla habitos.
class HabitoService {
  // CREATE: crea el hábito y su fila de estadísticas
  Future<int> crear(Habito h) async {
    final db = await BaseDatos.abrir();
    final id = await db.insert('habitos', h.toMap());
    h.id = id;
    await EstadisticaService().sincronizar(h);
    return id;
  }

  // READ (todos, para el administrador)
  Future<List<Habito>> obtenerTodos() async {
    final db = await BaseDatos.abrir();
    final filas = await db.query('habitos');
    return filas.map((f) => Habito.fromMap(f)).toList();
  }

  // READ (los de un usuario)
  Future<List<Habito>> obtenerPorUsuario(int usuarioId) async {
    final db = await BaseDatos.abrir();
    final filas = await db
        .query('habitos', where: 'usuario_id = ?', whereArgs: [usuarioId]);
    return filas.map((f) => Habito.fromMap(f)).toList();
  }

  // READ (uno por id)
  Future<Habito?> obtenerPorId(int id) async {
    final db = await BaseDatos.abrir();
    final filas = await db.query('habitos', where: 'id = ?', whereArgs: [id]);
    if (filas.isEmpty) return null;
    return Habito.fromMap(filas.first);
  }

  // UPDATE
  Future<void> actualizar(Habito h) async {
    final db = await BaseDatos.abrir();
    await db.update('habitos', h.toMap(), where: 'id = ?', whereArgs: [h.id]);
  }

  // DELETE: borra también sus estadísticas
  Future<void> eliminar(int id) async {
    final db = await BaseDatos.abrir();
    await db.delete('estadisticas', where: 'habito_id = ?', whereArgs: [id]);
    await db.delete('habitos', where: 'id = ?', whereArgs: [id]);
  }

  /// Marca o desmarca el hábito como hecho hoy y actualiza sus estadísticas.
  Future<void> alternarHoy(Habito h) async {
    h.alternarCompletadoHoy();
    await actualizar(h);
    await EstadisticaService().sincronizar(h);
  }
}
