/// Modelo de un hábito (tabla habitos).
/// Las fechas completadas se guardan como texto separado por comas.
class Habito {
  int? id;
  int usuarioId;
  String nombre;
  int colorHex;
  List<String> fechasCompletadas;

  Habito({
    this.id,
    required this.usuarioId,
    required this.nombre,
    required this.colorHex,
    List<String>? fechasCompletadas,
  }) : fechasCompletadas = fechasCompletadas ?? [];

  /// Fecha en formato yyyy-MM-dd
  static String formatearFecha(DateTime f) {
    final mes = f.month.toString().padLeft(2, '0');
    final dia = f.day.toString().padLeft(2, '0');
    return '${f.year}-$mes-$dia';
  }

  bool estaCompletadoHoy() =>
      fechasCompletadas.contains(formatearFecha(DateTime.now()));

  /// Marca o desmarca el hábito como hecho hoy.
  void alternarCompletadoHoy() {
    final hoy = formatearFecha(DateTime.now());
    if (fechasCompletadas.contains(hoy)) {
      fechasCompletadas.remove(hoy);
    } else {
      fechasCompletadas.add(hoy);
    }
  }

  int get totalDias => fechasCompletadas.length;

  /// Días seguidos completados hasta hoy (si hoy no está hecho, cuenta desde ayer).
  int get rachaActual {
    final ahora = DateTime.now();
    var dia = DateTime(ahora.year, ahora.month, ahora.day);
    if (!fechasCompletadas.contains(formatearFecha(dia))) {
      dia = DateTime(dia.year, dia.month, dia.day - 1);
    }
    var racha = 0;
    while (fechasCompletadas.contains(formatearFecha(dia))) {
      racha++;
      dia = DateTime(dia.year, dia.month, dia.day - 1);
    }
    return racha;
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'usuario_id': usuarioId,
        'nombre': nombre,
        'color': colorHex,
        'fechas_completadas': fechasCompletadas.join(','),
      };

  factory Habito.fromMap(Map<String, dynamic> m) {
    final texto = m['fechas_completadas'] as String;
    return Habito(
      id: m['id'] as int,
      usuarioId: m['usuario_id'] as int,
      nombre: m['nombre'] as String,
      colorHex: m['color'] as int,
      fechasCompletadas: texto.isEmpty ? [] : texto.split(','),
    );
  }
}
