import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/habito.dart';

// Servicio encargado de guardar y recuperar los datos de la aplicación.
class PreferenciasService {
  // Claves que identifican cada dato guardado en SharedPreferences.
  static const String _keyNombreUsuario = 'pref_nombre_usuario';
  static const String _keyObjetivoDiario = 'pref_objetivo_diario';
  static const String _keyModoOscuro = 'pref_modo_oscuro';
  static const String _keyTamanoLetra = 'pref_tamano_letra';
  static const String _keyOcultarCompletados = 'pref_ocultar_completados';
  static const String _keyHabitosList = 'pref_habitos_list';
  static const String _keyContadorAperturas = 'pref_contador_aperturas';
  static const String _keyUltimaApertura = 'pref_ultima_apertura';
  static const String _keyPrimeraVez = 'pref_primera_vez';

  // Variable donde se guarda la instancia de SharedPreferences.
  static SharedPreferences? _prefs;

  // Obtiene la instancia de SharedPreferences.
  // Si todavía no existe, la inicializa y la guarda para reutilizarla.
  Future<SharedPreferences> get _instance async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  // Recupera el nombre del usuario guardado.
  Future<String?> getNombreUsuario() async =>
      (await _instance).getString(_keyNombreUsuario);

  // Guarda el nombre del usuario.
  Future<void> setNombreUsuario(String nombre) async =>
      (await _instance).setString(_keyNombreUsuario, nombre);

  // Recupera el objetivo diario.
  // Si no hay ningún valor guardado, devuelve 3 por defecto.
  Future<int> getObjetivoDiario() async =>
      (await _instance).getInt(_keyObjetivoDiario) ?? 3;

  // Guarda el objetivo diario indicado.
  Future<void> setObjetivoDiario(int objetivo) async =>
      (await _instance).setInt(_keyObjetivoDiario, objetivo);

  // Comprueba si el modo oscuro está activado.
  // Si no existe un valor guardado, devuelve false.
  Future<bool> getModoOscuro() async =>
      (await _instance).getBool(_keyModoOscuro) ?? false;

  // Guarda si el modo oscuro está activado o desactivado.
  Future<void> setModoOscuro(bool valor) async =>
      (await _instance).setBool(_keyModoOscuro, valor);

  // Indica si se deben ocultar los hábitos completados.
  // Por defecto, devuelve false.
  Future<bool> getOcultarCompletados() async =>
      (await _instance).getBool(_keyOcultarCompletados) ?? false;

  // Guarda la preferencia para ocultar los hábitos completados.
  Future<void> setOcultarCompletados(bool ocultar) async =>
      (await _instance).setBool(_keyOcultarCompletados, ocultar);

  // Recupera el tamaño de letra guardado.
  // Si no hay ningún valor, utiliza 16.0 como tamaño predeterminado.
  Future<double> getTamanoLetra() async =>
      (await _instance).getDouble(_keyTamanoLetra) ?? 16.0;

  // Guarda el tamaño de letra seleccionado.
  Future<void> setTamanoLetra(double tamano) async =>
      (await _instance).setDouble(_keyTamanoLetra, tamano);

  // Recupera la lista de hábitos guardada.
  Future<List<Habito>> getHabitos() async {
    // Obtiene los hábitos almacenados como una lista de textos JSON.
    final List<String>? jsonList =
    (await _instance).getStringList(_keyHabitosList);

    // Si no hay hábitos guardados, devuelve una lista vacía.
    if (jsonList == null) return [];

    // Convierte cada texto JSON en un objeto Habito.
    return jsonList.map((str) => Habito.fromRawJson(str)).toList();
  }

  // Guarda la lista de hábitos en SharedPreferences.
  Future<void> saveHabitos(List<Habito> habitos) async {
    // Convierte cada hábito en texto JSON para poder almacenarlo.
    final List<String> jsonList =
    habitos.map((h) => h.toRawJson()).toList();

    // Guarda la lista de hábitos convertida.
    await (await _instance).setStringList(_keyHabitosList, jsonList);
  }

  // Registra una nueva apertura de la aplicación.
  Future<int> registrarApertura() async {
    // Obtiene la instancia de preferencias.
    final p = await _instance;

    // Suma una apertura al contador actual.
    // Si todavía no existe, comienza desde cero.
    int aperturas = (p.getInt(_keyContadorAperturas) ?? 0) + 1;

    // Guarda el nuevo número de aperturas.
    await p.setInt(_keyContadorAperturas, aperturas);

    // Guarda la fecha y hora de la apertura actual.
    await p.setString(
        _keyUltimaApertura, DateTime.now().toIso8601String());

    // Devuelve el número total de aperturas.
    return aperturas;
  }

  // Devuelve el número de veces que se ha abierto la aplicación.
  // Si no hay ningún dato guardado, devuelve cero.
  Future<int> getContadorAperturas() async =>
      (await _instance).getInt(_keyContadorAperturas) ?? 0;

  // Recupera la fecha y hora de la última apertura.
  Future<String?> getUltimaApertura() async =>
      (await _instance).getString(_keyUltimaApertura);

  // Comprueba si es la primera vez que se abre la aplicación.
  // Si no hay ningún valor guardado, devuelve true.
  Future<bool> esPrimeraVez() async =>
      (await _instance).getBool(_keyPrimeraVez) ?? true;

  // Marca la bienvenida como completada para no mostrarla otra vez.
  Future<void> setPrimeraVezCompletada() async =>
      (await _instance).setBool(_keyPrimeraVez, false);

  // Elimina todos los datos almacenados en SharedPreferences.
  Future<void> borrarTodo() async => (await _instance).clear();
}