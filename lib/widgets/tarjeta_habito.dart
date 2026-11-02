import 'package:flutter/material.dart';
// Tarjeta reutilizable que muestra un hábito y sus acciones.
class TarjetaHabito extends StatelessWidget {
  final String nombre;
  final Color color;
  final bool completado;
  final IconData icono;
  final VoidCallback onCompletar;
  final VoidCallback onEditar;
  final VoidCallback onEliminar;
  const TarjetaHabito({
    super.key,
    required this.nombre,
    required this.color,
    required this.completado,
    this.icono = Icons.check_circle_outline,
    required this.onCompletar,
    required this.onEditar,
    required this.onEliminar,
  });
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color,
          child: Icon(completado ? Icons.check : icono, color: Colors.white),
        ),
        title: Text(
          nombre,
          style: TextStyle(
            decoration: completado ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Text(completado ? 'Completado hoy' : 'Pendiente'),
        trailing: Wrap(
          spacing: 0,
          children: [
            IconButton(
              tooltip: 'Completar',
              icon: Icon(completado ? Icons.undo : Icons.check),
              onPressed: onCompletar,
            ),
            IconButton(
              tooltip: 'Editar',
              icon: const Icon(Icons.edit),
              onPressed: onEditar,
            ),
            IconButton(
              tooltip: 'Eliminar',
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: onEliminar,
            ),
          ],
        ),
      ),
    );
  }
}