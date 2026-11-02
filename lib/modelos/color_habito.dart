/// Color que se puede asignar a un hábito (se guarda como número).
class ColorHabito {
  final String nombre;
  final int valor;

  const ColorHabito(this.nombre, this.valor);
}

class ColoresHabito {
  static const ColorHabito azul = ColorHabito('Azul', 0xFF1976D2);
  static const ColorHabito verde = ColorHabito('Verde', 0xFF2E7D32);
  static const ColorHabito naranja = ColorHabito('Naranja', 0xFFEF6C00);
  static const ColorHabito rosa = ColorHabito('Rosa', 0xFFD81B60);
  static const ColorHabito cafe = ColorHabito('Café', 0xFF6D4C41);

  static const List<ColorHabito> todos = [azul, verde, naranja, rosa, cafe];
}
