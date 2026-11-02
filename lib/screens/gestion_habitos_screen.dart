import 'package:flutter/material.dart';
import '../models/habito.dart';
import '../services/preferencias_service.dart';

// Pantalla para crear un hábito nuevo o editar uno existente.
class GestionHabitosScreen extends StatefulWidget {
  // Guarda el hábito que se quiere editar, si se ha seleccionado uno.
  final Habito? habitoAEditar;

  const GestionHabitosScreen({super.key, this.habitoAEditar});

  // Crea el estado de la pantalla.
  @override
  State<GestionHabitosScreen> createState() => _GestionHabitosScreenState();
}

class _GestionHabitosScreenState extends State<GestionHabitosScreen> {
  // Controla el campo donde se escribe el nombre del hábito.
  final _nombreController = TextEditingController();

  // Servicio encargado de guardar y recuperar los hábitos.
  final _prefsService = PreferenciasService();

  // Guarda el color seleccionado. Por defecto, es el azul.
  int _colorSeleccionado = Colors.blue.value;

  // Lista de colores que el usuario puede elegir.
  final List<Color> _colores = [Colors.blue, Colors.red, Colors.green, Colors.orange, Colors.purple, Colors.teal];

  // Se ejecuta al iniciar la pantalla.
  @override
  void initState() {
    super.initState();

    // Si se ha seleccionado un hábito para editar, carga sus datos.
    if (widget.habitoAEditar != null) {
      _nombreController.text = widget.habitoAEditar!.nombre;
      _colorSeleccionado = widget.habitoAEditar!.colorHex;
    }
  }

  // Guarda un hábito nuevo o actualiza uno existente.
  void _guardar() async {
    // Obtiene el nombre y elimina los espacios sobrantes.
    final nombre = _nombreController.text.trim();

    // No permite guardar el hábito si el nombre está vacío.
    if (nombre.isEmpty) return;

    // Recupera la lista de hábitos guardados.
    List<Habito> habitos = await _prefsService.getHabitos();

    // Comprueba si se está creando un hábito nuevo.
    if (widget.habitoAEditar == null) {
      // Crea un hábito con un identificador único y lo añade a la lista.
      habitos.add(Habito(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        nombre: nombre,
        colorHex: _colorSeleccionado,
      ));
    } else {
      // Busca la posición del hábito que se quiere editar.
      final index = habitos.indexWhere((h) => h.id == widget.habitoAEditar!.id);

      // Si encuentra el hábito, actualiza su nombre y su color.
      if (index != -1) {
        habitos[index].nombre = nombre;
        habitos[index].colorHex = _colorSeleccionado;
      }
    }

    // Guarda la lista actualizada de hábitos.
    await _prefsService.saveHabitos(habitos);

    // Comprueba que la pantalla siga activa antes de volver atrás.
    if (!mounted) return;

    // Cierra la pantalla actual y regresa a la anterior.
    Navigator.pop(context);
  }

  // Construye la interfaz de la pantalla.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // El título cambia según se cree un hábito o se edite uno existente.
      appBar: AppBar(title: Text(widget.habitoAEditar != null ? 'Editar Hábito' : 'Nuevo Hábito')),

      body: Padding(
        // Añade espacio alrededor del contenido.
        padding: const EdgeInsets.all(16.0),
        child: Column(
          // Alinea los elementos al inicio horizontalmente.
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Campo para escribir el nombre del hábito.
            TextField(
              controller: _nombreController,
              decoration: const InputDecoration(labelText: 'Nombre del hábito', border: OutlineInputBorder()),
            ),

            // Añade espacio entre el campo y la selección de color.
            const SizedBox(height: 20),

            // Texto que indica que se puede elegir un color.
            const Text('Selecciona un color:', style: TextStyle(fontWeight: FontWeight.bold)),

            // Añade espacio antes de mostrar los colores.
            const SizedBox(height: 10),

            // Muestra todos los colores disponibles en una fila.
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: _colores.map((c) => GestureDetector(
                // Al pulsar un color, lo establece como seleccionado.
                onTap: () => setState(() => _colorSeleccionado = c.value),

                // Representa cada color mediante un círculo.
                child: CircleAvatar(
                  backgroundColor: c,

                  // Muestra una marca blanca en el color seleccionado.
                  child: _colorSeleccionado == c.value ? const Icon(Icons.check, color: Colors.white) : null,
                ),
              )).toList(),
            ),

            // Ocupa el espacio libre para colocar el botón abajo.
            const Spacer(),

            // Hace que el botón ocupe todo el ancho disponible.
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                // Ejecuta el método que guarda los cambios.
                onPressed: _guardar,

                // Añade espacio interior al botón.
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16)),

                // Texto que aparece en el botón.
                child: const Text('Guardar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}