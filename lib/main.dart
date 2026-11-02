import 'package:flutter/material.dart';
import 'services/preferencias_service.dart';
import 'screens/bienvenida_screen.dart';
import 'screens/principal_screen.dart';

// Punto de entrada de la aplicación.
void main() {
  // Inicializa Flutter antes de utilizar otras funciones del framework.
  WidgetsFlutterBinding.ensureInitialized();

  // Inicia la aplicación.
  runApp(const HabitosApp());
}

// Widget principal de la aplicación.
class HabitosApp extends StatefulWidget {
  const HabitosApp({super.key});

  @override
  State<HabitosApp> createState() => _HabitosAppState();
}

class _HabitosAppState extends State<HabitosApp> {
  // Servicio utilizado para guardar y recuperar las preferencias.
  final _prefsService = PreferenciasService();

  // Indica si todavía se están cargando los datos iniciales.
  bool _cargando = true;

  // Indica si es la primera vez que se abre la aplicación.
  bool _esPrimeraVez = true;

  // Guarda si el modo oscuro está activado.
  bool _modoOscuro = false;

  @override
  void initState() {
    super.initState();

    // Comprueba las preferencias guardadas al iniciar la aplicación.
    _comprobarInicial();
  }

  // Carga los datos necesarios para mostrar la pantalla inicial.
  Future<void> _comprobarInicial() async {
    // Comprueba si el usuario ya ha completado la bienvenida.
    final esPrimera = await _prefsService.esPrimeraVez();

    // Recupera la preferencia del modo oscuro.
    final modoOscuro = await _prefsService.getModoOscuro();

    // Actualiza las variables de estado con los datos recuperados.
    setState(() {
      _esPrimeraVez = esPrimera;
      _modoOscuro = modoOscuro;
      _cargando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Mientras se cargan los datos, muestra un indicador de progreso.
    if (_cargando) {
      return const MaterialApp(
        home: Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    // Configura el aspecto general y la pantalla inicial de la aplicación.
    return MaterialApp(
      // Nombre de la aplicación.
      title: 'HábitosApp',

      // Oculta la etiqueta de depuración de Flutter.
      debugShowCheckedModeBanner: false,

      // Define el tema claro.
      theme: ThemeData.light(useMaterial3: true),

      // Define el tema oscuro.
      darkTheme: ThemeData.dark(useMaterial3: true),

      // Selecciona el tema según la preferencia guardada.
      themeMode: _modoOscuro ? ThemeMode.dark : ThemeMode.light,

      // Si es la primera vez, muestra la bienvenida.
      // Si no, muestra directamente la pantalla principal.
      home: _esPrimeraVez
          ? const BienvenidaScreen()
          : const PrincipalScreen(),
    );
  }
}
