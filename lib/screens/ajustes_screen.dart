import 'package:flutter/material.dart';
import '../services/preferencias_service.dart';
import 'bienvenida_screen.dart';

// Pantalla donde se pueden modificar los ajustes de la aplicación.
class AjustesScreen extends StatefulWidget {
  const AjustesScreen({super.key});

  // Crea el estado que permite actualizar la pantalla.
  @override
  State<AjustesScreen> createState() => _AjustesScreenState();
}

// Clase que contiene las variables y la lógica de los ajustes.
class _AjustesScreenState extends State<AjustesScreen> {
  // Servicio encargado de guardar y recuperar las preferencias.
  final _prefsService = PreferenciasService();

  // Indica si el modo oscuro está activado.
  bool _modoOscuro = false;

  // Guarda el tamaño de letra seleccionado.
  double _tamanoLetra = 16.0;

  // Indica si se deben ocultar los hábitos completados hoy.
  bool _ocultarCompletados = false;

  // Indica si todavía se están cargando los ajustes guardados.
  bool _cargando = true;

  // Se ejecuta al iniciar la pantalla.
  @override
  void initState() {
    super.initState();

    // Carga los ajustes guardados anteriormente.
    _cargar();
  }

  // Recupera las preferencias guardadas en el dispositivo.
  Future<void> _cargar() async {
    final m = await _prefsService.getModoOscuro();
    final t = await _prefsService.getTamanoLetra();
    final o = await _prefsService.getOcultarCompletados();

    // Actualiza las variables para mostrar los ajustes recuperados.
    setState(() {
      _modoOscuro = m;
      _tamanoLetra = t;
      _ocultarCompletados = o;
      _cargando = false;
    });
  }

  // Construye la interfaz de la pantalla de ajustes.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Barra superior con el título de la pantalla.
      appBar: AppBar(title: const Text('Ajustes')),

      // Mientras se cargan las preferencias, muestra un indicador.
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : ListView(
        children: [
          // Interruptor para activar o desactivar el modo oscuro.
          SwitchListTile(
            title: const Text('Modo Oscuro'),
            value: _modoOscuro,

            // Actualiza el estado y guarda la preferencia seleccionada.
            onChanged: (v) async {
              setState(() => _modoOscuro = v);
              await _prefsService.setModoOscuro(v);
            },
          ),

          // Opción para cambiar el tamaño de letra.
          ListTile(
            title: const Text('Tamaño de letra'),
            subtitle: Slider(
              // Establece el tamaño mínimo y máximo de letra.
              min: 12, max: 24, divisions: 6,
              value: _tamanoLetra,

              // Muestra el tamaño seleccionado como número entero.
              label: _tamanoLetra.round().toString(),

              // Actualiza el tamaño y guarda la nueva preferencia.
              onChanged: (v) async {
                setState(() => _tamanoLetra = v);
                await _prefsService.setTamanoLetra(v);
              },
            ),
          ),

          // Interruptor para ocultar los hábitos completados durante el día.
          SwitchListTile(
            title: const Text('Ocultar hábitos completados hoy'),
            value: _ocultarCompletados,

            // Actualiza el estado y guarda la preferencia.
            onChanged: (v) async {
              setState(() => _ocultarCompletados = v);
              await _prefsService.setOcultarCompletados(v);
            },
          ),

          // Línea divisoria para separar las opciones.
          const Divider(),

          // Opción para borrar los datos de la aplicación.
          ListTile(
            leading: const Icon(Icons.delete_forever, color: Colors.pink),
            title: const Text('Borrar datos', style: TextStyle(color: Colors.pink)),
            subtitle: const Text('Deja la app como recién instalada'),

            // Borra las preferencias y vuelve a la pantalla de bienvenida.
            onTap: () async {
              await _prefsService.borrarTodo();

              // Comprueba que la pantalla siga activa antes de navegar.
              if (!mounted) return;

              // Elimina las pantallas anteriores y muestra la bienvenida.
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const BienvenidaScreen()),
                    (r) => false,
              );
            },
          )
        ],
      ),
    );
  }
}