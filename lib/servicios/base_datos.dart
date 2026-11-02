import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

/// Abre (y crea la primera vez) la base de datos SQLite local.
class BaseDatos {
  static Database? _db;

  static Future<Database> abrir() async {
    if (_db != null) return _db!;
    final ruta = join(await getDatabasesPath(), 'habitos_app.db');
    _db = await openDatabase(ruta, version: 1, onCreate: _crearTablas);
    return _db!;
  }

  // Se ejecuta solo la primera vez: crea las tres tablas.
  static Future<void> _crearTablas(Database db, int version) async {
    await db.execute('''
      CREATE TABLE usuarios (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        usuario TEXT NOT NULL UNIQUE,
        nombre TEXT NOT NULL,
        apellidos TEXT NOT NULL,
        email TEXT NOT NULL,
        contrasena TEXT NOT NULL,
        fecha_creacion TEXT NOT NULL,
        rol TEXT NOT NULL
      )''');
    await db.execute('''
      CREATE TABLE habitos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        usuario_id INTEGER NOT NULL,
        nombre TEXT NOT NULL,
        color INTEGER NOT NULL,
        fechas_completadas TEXT NOT NULL DEFAULT ''
      )''');
    await db.execute('''
      CREATE TABLE estadisticas (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        habito_id INTEGER NOT NULL,
        racha_actual INTEGER NOT NULL,
        total_dias INTEGER NOT NULL
      )''');

    // Administrador por defecto: usuario "admin" y contraseña "admin123".
    await db.insert('usuarios', {
      'usuario': 'admin',
      'nombre': 'Administrador',
      'apellidos': 'Principal',
      'email': 'admin@habitosapp.com',
      'contrasena': 'admin123',
      'fecha_creacion': DateTime.now().toIso8601String(),
      'rol': 'administrador',
    });
  }
}
