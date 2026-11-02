/// Modelo de una estadística (tabla estadisticas): una fila por hábito.
class Estadistica {
  int? id;
  int habitoId;
  int rachaActual;
  int totalDias;

  Estadistica({
    this.id,
    required this.habitoId,
    required this.rachaActual,
    required this.totalDias,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'habito_id': habitoId,
        'racha_actual': rachaActual,
        'total_dias': totalDias,
      };

  factory Estadistica.fromMap(Map<String, dynamic> m) => Estadistica(
        id: m['id'] as int,
        habitoId: m['habito_id'] as int,
        rachaActual: m['racha_actual'] as int,
        totalDias: m['total_dias'] as int,
      );
}
