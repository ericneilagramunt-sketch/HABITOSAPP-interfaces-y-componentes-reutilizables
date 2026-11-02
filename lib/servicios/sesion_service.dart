import 'package:shared_preferences/shared_preferences.dart';

/// Recuerda qué usuario ha iniciado sesión (SharedPreferences).
class SesionService {
  static const String _claveUsuarioId = 'sesion_usuario_id';

  Future<void> guardarUsuarioId(int id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_claveUsuarioId, id);
  }

  /// Devuelve null si nadie ha iniciado sesión.
  Future<int?> obtenerUsuarioId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_claveUsuarioId);
  }

  Future<void> cerrarSesion() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_claveUsuarioId);
  }
}
