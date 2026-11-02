import 'package:flutter/material.dart';
import '../models/habito.dart';
import '../services/preferencias_service.dart';
import '../widgets/habito_tile.dart';
import 'gestion_habitos_screen.dart';
import 'estadisticas_screen.dart';
import 'ajustes_screen.dart';

// Pantalla principal donde se muestran y gestionan los hábitos.
class PrincipalScreen extends StatefulWidget {
  const PrincipalScreen({super.key});

  // Crea el estado de la pantalla principal.
  @override
  State<PrincipalScreen> createState() => _PrincipalScreenState();
}

class _PrincipalScreenState extends State<PrincipalScreen> {
  // Servicio encargado de guardar y recuperar las preferencias.
  final _prefsService = PreferenciasService();

  // Indica si los datos todavía se están cargando.
  bool _cargando = true;

  // Nombre del usuario que utiliza la aplicación.
  String _nombreUsuario = '';

  // Número de hábitos que el usuario quiere completar cada día.
  int _objetivoDiario = 0;

  // Tamaño de letra configurado en los ajustes.
  double _tamanoLetra = 16.0;

  // Indica si se deben ocultar los hábitos completados hoy.
  bool _ocultarCompletados = false;

  // Lista de hábitos guardados.
  List<Habito> _habitos = [];

  // Se ejecuta al iniciar la pantalla.
  @override
  void initState() {
    super.initState();

    // Carga los datos guardados del usuario.
    _cargarDatos();
  }

  // Recupera las preferencias y los hábitos guardados.
  Future<void> _cargarDatos() async {
    // Activa el indicador de carga mientras se recuperan los datos.
    setState(() => _cargando = true);

    // Registra una nueva apertura de la aplicación.
    await _prefsService.registrarApertura();

    // Recupera el nombre del usuario o utiliza "Usuario" si no existe.
    final nombre = await _prefsService.getNombreUsuario() ?? 'Usuario';

    // Recupera el objetivo diario, el tamaño de letra y las preferencias.
    final objetivo = await _prefsService.getObjetivoDiario();
    final tamano = await _prefsService.getTamanoLetra();
    final ocultar = await _prefsService.getOcultarCompletados();

    // Recupera la lista de hábitos guardados.
    final habitos = await _prefsService.getHabitos();

    // Actualiza las variables con los datos recuperados.
    setState(() {
      _nombreUsuario = nombre;
      _objetivoDiario = objetivo;
      _tamanoLetra = tamano;
      _ocultarCompletados = ocultar;
      _habitos = habitos;
      _cargando = false;
    });
  }

  // Marca un hábito como completado hoy o lo desmarca.
  void _toggleHabito(Habito habito) async {
    // Actualiza el estado del hábito y refresca la interfaz.
    setState(() => habito.alternarCompletadoHoy());

    // Guarda la lista actualizada de hábitos.
    await _prefsService.saveHabitos(_habitos);
  }

  // Elimina un hábito de la lista.
  void _borrarHabito(Habito habito) async {
    // Busca el hábito por su identificador y lo elimina.
    setState(() => _habitos.removeWhere((h) => h.id == habito.id));

    // Guarda los cambios realizados en la lista.
    await _prefsService.saveHabitos(_habitos);
  }

  // Construye la interfaz de la pantalla principal.
  @override
  Widget build(BuildContext context) {
    // Mientras se cargan los datos, muestra un indicador de espera.
    if (_cargando) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    // Cuenta cuántos hábitos se han completado durante el día actual.
    final completados = _habitos.where((h) => h.estaCompletadoHoy()).length;

    // Filtra los hábitos si está activada la opción de ocultar completados.
    final visibles = _ocultarCompletados
        ? _habitos.where((h) => !h.estaCompletadoHoy()).toList()
        : _habitos;

    return Scaffold(
      // Barra superior con el saludo y los accesos a otras pantallas.
      appBar: AppBar(
        title: Text('¡Hola, $_nombreUsuario!'),
        actions: [
          // Botón para abrir la pantalla de estadísticas.
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const EstadisticasScreen()),

              // Recarga los datos al volver de la pantalla de estadísticas.
            ).then((_) => _cargarDatos()),
          ),

          // Botón para abrir la pantalla de ajustes.
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AjustesScreen()),

              // Recarga los datos al volver de los ajustes.
            ).then((_) => _cargarDatos()),
          ),
        ],
      ),

      // Organiza el progreso diario y la lista de hábitos en vertical.
      body: Column(
        children: [
          // Contenedor que muestra el progreso del usuario.
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Texto que indica la sección del progreso diario.
                Text('Progreso diario:', style: TextStyle(fontSize: _tamanoLetra, fontWeight: FontWeight.bold)),

                // Muestra cuántos hábitos se han completado respecto al objetivo.
                Text(
                  '$completados de $_objetivoDiario hábitos',
                  style: TextStyle(
                    fontSize: _tamanoLetra,

                    // Utiliza verde si se alcanza el objetivo y naranja si no.
                    color: completados >= _objetivoDiario ? Colors.green : Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Ocupa el espacio restante para mostrar la lista de hábitos.
          Expanded(
            child: visibles.isEmpty

            // Si no hay hábitos visibles, muestra un mensaje.
                ? Center(child: Text('No hay hábitos.', style: TextStyle(fontSize: _tamanoLetra)))

            // Crea la lista de hábitos a partir de los elementos disponibles.
                : ListView.builder(
              itemCount: visibles.length,
              itemBuilder: (context, index) {
                // Obtiene el hábito correspondiente a la posición actual.
                final habito = visibles[index];

                // Construye el elemento visual de cada hábito.
                return HabitoTile(
                  habito: habito,
                  tamanoLetra: _tamanoLetra,

                  // Ejecuta la acción para marcar o desmarcar el hábito.
                  onToggle: (_) => _toggleHabito(habito),

                  // Ejecuta la acción para eliminar el hábito.
                  onDelete: () => _borrarHabito(habito),

                  // Abre la pantalla de edición del hábito seleccionado.
                  onEdit: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => GestionHabitosScreen(habitoAEditar: habito)),
                    );

                    // Recarga los datos después de volver de la edición.
                    _cargarDatos();
                  },
                );
              },
            ),
          ),
        ],
      ),

      // Botón flotante para añadir un hábito nuevo.
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          // Abre la pantalla para crear un hábito.
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const GestionHabitosScreen()),
          );

          // Actualiza la lista cuando se vuelve a la pantalla principal.
          _cargarDatos();
        },
      ),
    );
  }
}