import 'package:flutter/material.dart';
import '../models/habito.dart';

// Widget que muestra un hábito y permite completarlo, editarlo o eliminarlo.
class HabitoTile extends StatelessWidget {
  // Hábito que se va a mostrar.
  final Habito habito;

  // Tamaño de letra utilizado para mostrar el nombre del hábito.
  final double tamanoLetra;

  // Función que se ejecuta cuando cambia el estado del hábito.
  final Function(bool?) onToggle;

  // Función que se ejecuta al pulsar el botón de eliminar.
  final VoidCallback onDelete;

  // Función que se ejecuta al pulsar el botón de editar.
  final VoidCallback onEdit;

  // Constructor que recibe los datos y las funciones necesarias.
  const HabitoTile({
    super.key,
    required this.habito,
    required this.tamanoLetra,
    required this.onToggle,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    // Comprueba si el hábito está completado durante el día de hoy.
    final estaHecho = habito.estaCompletadoHoy();

    // Tarjeta que contiene toda la información del hábito.
    return Card(
      // Añade una pequeña sombra a la tarjeta.
      elevation: 2,

      // Establece el margen exterior de la tarjeta.
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),

      child: ListTile(
        // Icono circular que muestra el estado del hábito.
        leading: CircleAvatar(
          // Utiliza el color guardado en el propio hábito.
          backgroundColor: Color(habito.colorHex),
          child: Icon(
            // Muestra un check si está completado y una casilla vacía si no.
            estaHecho ? Icons.check : Icons.check_box_outline_blank,
            color: Colors.white,
          ),
        ),

        // Muestra el nombre del hábito.
        title: Text(
          habito.nombre,
          style: TextStyle(
            // Aplica el tamaño de letra seleccionado.
            fontSize: tamanoLetra,

            // Tacha el nombre cuando el hábito está completado.
            decoration: estaHecho ? TextDecoration.lineThrough : null,
          ),
        ),

        // Botones que aparecen a la derecha de la tarjeta.
        trailing: Row(
          // Evita que la fila ocupe todo el ancho disponible.
          mainAxisSize: MainAxisSize.min,
          children: [
            // Casilla para marcar o desmarcar el hábito.
            Checkbox(value: estaHecho, onChanged: onToggle),

            // Botón para editar el hábito.
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: onEdit,
            ),

            // Botón para eliminar el hábito.
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}