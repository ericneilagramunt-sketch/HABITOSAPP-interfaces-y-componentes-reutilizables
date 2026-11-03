import 'package:shared_preferences/shared_preferences.dart';
/// SharedPreferences: recuerda quién ha iniciado sesión y si es la primera vez.
/// (La base de datos guarda los datos; SharedPreferences, valores sueltos.)
class SesionService {
  static const String _claveUsuarioId = 'sesion_usuario_id'; // int
  static const String _clavePrimeraVez = 'primera_vez'; // bool

  /// Guarda el usuario que ha entrado. Entrar ya cuenta como "haber accedido".
  Future<void> guardarUsuarioId(int id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_claveUsuarioId, id);
    await prefs.setBool(_clavePrimeraVez, false);
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

  /// true si nunca se ha registrado ni entrado nadie en esta app.
  /// Si la clave no existe (null), es la primera vez.
  Future<bool> esPrimeraVez() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_clavePrimeraVez) ?? true;
  }

  Future<void> marcarPrimeraVezCompletada() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_clavePrimeraVez, false);
  }
}
