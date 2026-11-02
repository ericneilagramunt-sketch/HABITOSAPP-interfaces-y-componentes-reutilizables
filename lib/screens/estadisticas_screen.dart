import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/habito.dart';
import '../services/preferencias_service.dart';

// Pantalla que muestra las estadísticas de uso y los hábitos del usuario.
class EstadisticasScreen extends StatefulWidget {
  const EstadisticasScreen({super.key});

  // Crea el estado de la pantalla de estadísticas.
  @override
  State<EstadisticasScreen> createState() => _EstadisticasScreenState();
}

class _EstadisticasScreenState extends State<EstadisticasScreen> {
  // Servicio que permite recuperar los datos guardados.
  final _prefsService = PreferenciasService();

  // Indica si todavía se están cargando las estadísticas.
  bool _cargando = true;

  // Número total de veces que se ha abierto la aplicación.
  int _aperturas = 0;

  // Texto que muestra la fecha de la última apertura.
  String _ultimaAperturaTexto = 'N/A';

  // Lista de hábitos guardados por el usuario.
  List<Habito> _habitos = [];

  // Se ejecuta al iniciar la pantalla.
  @override
  void initState() {
    super.initState();

    // Carga los datos necesarios para mostrar las estadísticas.
    _cargar();
  }

  // Recupera las estadísticas y los hábitos guardados.
  Future<void> _cargar() async {
    final aperturas = await _prefsService.getContadorAperturas();
    final fechaIso = await _prefsService.getUltimaApertura();
    final habitos = await _prefsService.getHabitos();

    // Valor que se muestra si no existe una fecha guardada.
    String fechaFormatted = 'Sin registro';

    // Si hay una fecha guardada, la convierte al formato día/mes/año y hora.
    if (fechaIso != null) {
      fechaFormatted = DateFormat('dd/MM/yyyy HH:mm:ss').format(DateTime.parse(fechaIso));
    }

    // Actualiza las variables de la pantalla con los datos recuperados.
    setState(() {
      _aperturas = aperturas;
      _ultimaAperturaTexto = fechaFormatted;
      _habitos = habitos;
      _cargando = false;
    });
  }

  // Calcula cuántos días seguidos se ha completado un hábito.
  int _racha(Habito h) {
    // La racha empieza en cero días.
    int r = 0;

    // Obtiene la fecha actual.
    DateTime hoy = DateTime.now();

    // Comprueba las fechas hacia atrás hasta encontrar un día sin completar.
    while (true) {
      // Convierte la fecha actual en una cadena con el formato año-mes-día.
      String f = "${hoy.year.toString().padLeft(4, '0')}-${hoy.month.toString().padLeft(2, '0')}-${hoy.day.toString().padLeft(2, '0')}";

      // Si el hábito se completó ese día, aumenta la racha.
      if (h.fechasCompletadas.contains(f)) {
        r++;

        // Retrocede un día para comprobar si también se completó.
        hoy = hoy.subtract(const Duration(days: 1));
      } else {
        // Detiene el cálculo cuando encuentra un día sin completar.
        break;
      }
    }

    // Devuelve el número de días consecutivos completados.
    return r;
  }

  // Construye la interfaz de la pantalla de estadísticas.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Barra superior con el título de la pantalla.
      appBar: AppBar(title: const Text('Estadísticas')),

      // Muestra un indicador mientras se cargan los datos.
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : ListView(
        // Añade espacio alrededor del contenido.
        padding: const EdgeInsets.all(16),
        children: [
          // Tarjeta que muestra el número total de aperturas de la aplicación.
          Card(child: ListTile(title: const Text('Total aperturas app:'), trailing: Text('$_aperturas', style: const TextStyle(fontWeight: FontWeight.bold)))),

          // Tarjeta que muestra la fecha y la hora de la última apertura.
          Card(child: ListTile(title: const Text('Última apertura:'), subtitle: Text(_ultimaAperturaTexto))),

          // Añade espacio entre las estadísticas generales y las rachas.
          const SizedBox(height: 20),

          // Título de la sección donde aparecen las rachas de los hábitos.
          const Text('Racha por hábito:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

          // Añade espacio antes de la lista de hábitos.
          const SizedBox(height: 10),

          // Recorre todos los hábitos para mostrar sus estadísticas.
          ..._habitos.map((h) => ListTile(
            // Muestra un círculo con el color asignado al hábito.
            leading: CircleAvatar(backgroundColor: Color(h.colorHex)),

            // Muestra el nombre del hábito.
            title: Text(h.nombre),

            // Muestra el total de días en los que se ha completado.
            subtitle: Text('Total completado: ${h.fechasCompletadas.length} días'),

            // Muestra la racha actual de días consecutivos.
            trailing: Text('🔥 ${_racha(h)} días', style: const TextStyle(fontWeight: FontWeight.bold)),
          )),
        ],
      ),
    );
  }
}