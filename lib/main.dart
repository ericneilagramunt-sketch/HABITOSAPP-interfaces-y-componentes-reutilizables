import 'package:flutter/material.dart';
import 'pantallas/habitos_page.dart';
import 'pantallas/login_page.dart';
import 'pantallas/registro_page.dart';
import 'servicios/sesion_service.dart';
import 'servicios/usuario_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const HabitosApp());
}

/// Inicio y configuración general: un único MaterialApp.
class HabitosApp extends StatefulWidget {
  const HabitosApp({super.key});

  @override
  State<HabitosApp> createState() => _HabitosAppState();
}

class _HabitosAppState extends State<HabitosApp> {
  // Mientras se lee la sesión se muestra un indicador de carga
  Widget _inicio = const Scaffold(
    body: Center(child: CircularProgressIndicator()),
  );

  @override
  void initState() {
    super.initState();
    _arrancar();
  }

  // 1) Si hay sesión guardada y el usuario existe en la base de datos -> sus hábitos.
  // 2) Si nunca ha accedido nadie (primera vez) -> Registro.
  // 3) En cualquier otro caso -> Inicio de sesión.
  Future<void> _arrancar() async {
    final sesion = SesionService();
    Widget pantalla = const LoginPage();

    final id = await sesion.obtenerUsuarioId();
    if (id != null) {
      final usuario = await UsuarioService().obtenerPorId(id);
      if (usuario != null) {
        pantalla = HabitosPage(usuario: usuario);
      }
    } else {
      final primeraVez = await sesion.esPrimeraVez();
      if (primeraVez) {
        pantalla = const RegistroPage();
      }
    }

    if (!mounted) return;
    setState(() => _inicio = pantalla);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HábitosApp',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
      home: _inicio,
    );
  }
}
