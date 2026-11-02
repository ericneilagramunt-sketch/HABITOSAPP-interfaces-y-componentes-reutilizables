// Todas las claves de SharedPreferences en un único sitio.
// Así no hay cadenas sueltas repartidas por el código y evitamos erratas.
class ClavesPrefs {
  // Constructor privado para impedir que se creen objetos de esta clase.
  ClavesPrefs._(); // clase solo de constantes: no se instancia

  // Clave para guardar el nombre del usuario como texto.
  static const String nombreUsuario = 'pref_nombre_usuario';

  // Clave para guardar el objetivo diario como número entero.
  static const String objetivoDiario = 'pref_objetivo_diario';

  // Clave para guardar si el modo oscuro está activado.
  static const String modoOscuro = 'pref_modo_oscuro';

  // Clave para guardar el tamaño de letra.
  static const String tamanoLetra = 'pref_tamano_letra';

  // Clave para guardar si se ocultan los hábitos completados.
  static const String ocultarCompletados = 'pref_ocultar_completados';

  // Clave para guardar la lista de hábitos en formato JSON.
  static const String habitos = 'pref_habitos_list';

  // Clave para guardar el número de aperturas de la aplicación.
  static const String contadorAperturas = 'pref_contador_aperturas';

  // Clave para guardar la fecha y hora de la última apertura.
  static const String ultimaApertura = 'pref_ultima_apertura';

  // Clave para indicar si el usuario ya ha completado la bienvenida.
  static const String primeraVez = 'pref_primera_vez';
}