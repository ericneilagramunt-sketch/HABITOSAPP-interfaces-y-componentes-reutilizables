/// Modelo de una estadística (tabla estadisticas): una fila por hábito.
class Estadistica {
  int? id; // puede ser null hasta que se guarda en la base de datos
  int habitoId; // el hábito al que pertenecen estos datos
  int rachaActual; // días seguidos completados hasta hoy
  int totalDias; // total de días que se ha completado el hábito

  Estadistica({
    this.id,
    required this.habitoId,
    required this.rachaActual,
    required this.totalDias,
  });
 // Convierte la estadística en un mapa para guardarla en la base de datos
  Map<String, dynamic> toMap() => {
        'id': id,
        'habito_id': habitoId,
        'racha_actual': rachaActual,
        'total_dias': totalDias,
      };
  // Hace lo contrario: crea una estadística a partir de una fila de la base de datos
  factory Estadistica.fromMap(Map<String, dynamic> m) => Estadistica(
        id: m['id'] as int,
        habitoId: m['habito_id'] as int,
        rachaActual: m['racha_actual'] as int,
        totalDias: m['total_dias'] as int,
      );
}
