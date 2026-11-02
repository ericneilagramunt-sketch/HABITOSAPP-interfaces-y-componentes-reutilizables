import 'dart:convert';

// Clase que representa un hábito dentro de la aplicación.
class Habito {
  // Identificador único del hábito.
  final String id;

  // Nombre del hábito.
  String nombre;

  // Color del hábito guardado como un número hexadecimal.
  int colorHex;

  // Lista de fechas en las que se ha completado el hábito.
  List<String> fechasCompletadas;

  // Constructor para crear un hábito con sus datos.
  // Si no se indican fechas, se crea una lista vacía.
  Habito({
    required this.id,
    required this.nombre,
    required this.colorHex,
    List<String>? fechasCompletadas,
  }) : fechasCompletadas = fechasCompletadas ?? [];

  // Comprueba si el hábito se ha completado en una fecha determinada.
  // Si no se indica una fecha, utiliza la fecha actual.
  bool estaCompletadoHoy([DateTime? fecha]) {
    final f = fecha ?? DateTime.now();
    return fechasCompletadas.contains(_formatearFecha(f));
  }

  // Marca el hábito como completado hoy o lo desmarca si ya estaba completado.
  void alternarCompletadoHoy() {
    // Obtiene la fecha actual con el formato utilizado en la lista.
    final hoyStr = _formatearFecha(DateTime.now());

    // Si la fecha ya existe, la elimina; si no existe, la añade.
    if (fechasCompletadas.contains(hoyStr)) {
      fechasCompletadas.remove(hoyStr);
    } else {
      fechasCompletadas.add(hoyStr);
    }
  }

  // Convierte una fecha al formato año-mes-día.
  // Añade ceros delante del mes y del día cuando es necesario.
  static String _formatearFecha(DateTime fecha) {
    return "${fecha.year.toString().padLeft(4, '0')}-${fecha.month.toString().padLeft(2, '0')}-${fecha.day.toString().padLeft(2, '0')}";
  }

  // Convierte los datos del hábito en un mapa para poder guardarlos como JSON.
  Map<String, dynamic> toJson() => {
    'id': id,
    'nombre': nombre,
    'colorHex': colorHex,
    'fechasCompletadas': fechasCompletadas,
  };

  // Crea un objeto Habito a partir de los datos recibidos en formato JSON.
  factory Habito.fromJson(Map<String, dynamic> json) => Habito(
    id: json['id'] as String,
    nombre: json['nombre'] as String,
    colorHex: json['colorHex'] as int,
    fechasCompletadas: List<String>.from(json['fechasCompletadas'] ?? []),
  );

  // Convierte los datos del hábito a una cadena de texto JSON.
  String toRawJson() => jsonEncode(toJson());

  // Convierte una cadena JSON en un objeto Habito.
  factory Habito.fromRawJson(String str) => Habito.fromJson(jsonDecode(str));
}