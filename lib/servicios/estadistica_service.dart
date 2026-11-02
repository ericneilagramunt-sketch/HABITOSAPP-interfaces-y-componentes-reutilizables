import '../modelos/estadistica.dart';
import '../modelos/habito.dart';
import 'base_datos.dart';

/// CRUD de la tabla estadisticas.
class EstadisticaService {
  // CREATE
  Future<int> crear(Estadistica e) async {
    final db = await BaseDatos.abrir();
    return db.insert('estadisticas', e.toMap());
  }

  // READ (todas)
  Future<List<Estadistica>> obtenerTodas() async {
    final db = await BaseDatos.abrir();
    final filas = await db.query('estadisticas');
    return filas.map((f) => Estadistica.fromMap(f)).toList();
  }

  // READ (la de un hábito)
  Future<Estadistica?> obtenerPorHabito(int habitoId) async {
    final db = await BaseDatos.abrir();
    final filas = await db
        .query('estadisticas', where: 'habito_id = ?', whereArgs: [habitoId]);
    if (filas.isEmpty) return null;
    return Estadistica.fromMap(filas.first);
  }

  // UPDATE
  Future<void> actualizar(Estadistica e) async {
    final db = await BaseDatos.abrir();
    await db.update('estadisticas', e.toMap(),
        where: 'id = ?', whereArgs: [e.id]);
  }

  // DELETE
  Future<void> eliminar(int id) async {
    final db = await BaseDatos.abrir();
    await db.delete('estadisticas', where: 'id = ?', whereArgs: [id]);
  }

  /// Recalcula racha y total de un hábito y los guarda.
  Future<void> sincronizar(Habito h) async {
    final existente = await obtenerPorHabito(h.id!);
    if (existente == null) {
      await crear(Estadistica(
          habitoId: h.id!, rachaActual: h.rachaActual, totalDias: h.totalDias));
    } else {
      existente.rachaActual = h.rachaActual;
      existente.totalDias = h.totalDias;
      await actualizar(existente);
    }
  }
}
