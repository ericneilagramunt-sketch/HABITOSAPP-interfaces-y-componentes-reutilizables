import 'package:flutter/material.dart';

/// Tarjeta de un hábito dentro de la lista.
/// Recibe los datos y las acciones; no conoce la base de datos.
class TarjetaHabito extends StatelessWidget {
  final String nombre;
  final Color color;
  final bool completadoHoy;
  final IconData icono;
  final VoidCallback alCompletar;
  final VoidCallback alEditar;
  final VoidCallback alEliminar;

  const TarjetaHabito({
    super.key,
    required this.nombre,
    required this.color,
    required this.completadoHoy,
    this.icono = Icons.track_changes,
    required this.alCompletar,
    required this.alEditar,
    required this.alEliminar,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: color,
                  child: Icon(icono, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        nombre,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: color,
                          decoration:
                              completadoHoy ? TextDecoration.lineThrough : null,
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Texto + icono + color distinguen completado y pendiente
                      Row(
                        children: [
                          Icon(
                            completadoHoy
                                ? Icons.check_circle
                                : Icons.radio_button_unchecked,
                            size: 18,
                            color: completadoHoy ? Colors.green : Colors.orange,
                          ),
                          const SizedBox(width: 4),
                          Text(completadoHoy
                              ? 'Completado hoy'
                              : 'Pendiente'),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                  onPressed: alCompletar,
                  icon: Icon(completadoHoy ? Icons.undo : Icons.check),
                  label: Text(completadoHoy ? 'Desmarcar' : 'Completar'),
                ),
                Row(
                  children: [
                    IconButton(
                      tooltip: 'Editar hábito',
                      icon: const Icon(Icons.edit),
                      onPressed: alEditar,
                    ),
                    IconButton(
                      tooltip: 'Eliminar hábito',
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: alEliminar,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
