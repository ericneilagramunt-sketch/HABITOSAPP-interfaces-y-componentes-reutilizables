import 'package:flutter/material.dart';
import '../services/preferencias_service.dart';
import 'principal_screen.dart';

// Pantalla inicial que aparece cuando el usuario entra por primera vez.
class BienvenidaScreen extends StatefulWidget {
  const BienvenidaScreen({super.key});

  // Crea el estado de la pantalla de bienvenida.
  @override
  State<BienvenidaScreen> createState() => _BienvenidaScreenState();
}

class _BienvenidaScreenState extends State<BienvenidaScreen> {
  // Controla el campo donde el usuario escribe su nombre.
  final _nombreController = TextEditingController();

  // Controla el campo del objetivo diario, que empieza con el valor 3.
  final _objetivoController = TextEditingController(text: "3");

  // Servicio que permite guardar las preferencias del usuario.
  final _prefsService = PreferenciasService();

  // Guarda los datos introducidos y pasa a la pantalla principal.
  void _guardarYContinuar() async {
    // Obtiene el nombre y elimina los espacios del principio y del final.
    final nombre = _nombreController.text.trim();

    // Convierte el objetivo a un número entero.
    // Si no se puede convertir, utiliza el valor 3.
    final objetivo = int.tryParse(_objetivoController.text.trim()) ?? 3;

    // Si el nombre está vacío, no permite continuar.
    if (nombre.isEmpty) return;

    // Guarda el nombre del usuario en las preferencias.
    await _prefsService.setNombreUsuario(nombre);

    // Guarda el objetivo diario de hábitos.
    await _prefsService.setObjetivoDiario(objetivo);

    // Guarda que la configuración inicial ya se ha completado.
    await _prefsService.setPrimeraVezCompletada();

    // Comprueba que la pantalla siga activa antes de continuar.
    if (!mounted) return;

    // Abre la pantalla principal y sustituye la pantalla de bienvenida.
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const PrincipalScreen()),
    );
  }

  // Construye la interfaz de la pantalla de bienvenida.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        // Añade espacio alrededor de todos los elementos.
        padding: const EdgeInsets.all(24.0),
        child: Column(
          // Centra los elementos verticalmente.
          mainAxisAlignment: MainAxisAlignment.center,

          // Hace que los elementos ocupen el ancho disponible.
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Icono decorativo de la aplicación.
            const Icon(Icons.auto_awesome, size: 80, color: Colors.blue),

            // Añade espacio entre el icono y el título.
            const SizedBox(height: 20),

            // Muestra el título de bienvenida centrado y en negrita.
            const Text(
              '¡Bienvenido a HábitosApp!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            // Añade espacio antes del campo del nombre.
            const SizedBox(height: 30),

            // Campo donde el usuario introduce su nombre.
            TextField(
              controller: _nombreController,
              decoration: const InputDecoration(
                labelText: '¿Cómo te llamas?',
                border: OutlineInputBorder(),
              ),
            ),

            // Añade espacio entre los dos campos.
            const SizedBox(height: 16),

            // Campo donde se introduce el objetivo diario de hábitos.
            TextField(
              controller: _objetivoController,

              // Muestra un teclado numérico para facilitar la entrada.
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Objetivo diario de hábitos (número)',
                border: OutlineInputBorder(),
              ),
            ),

            // Añade espacio antes del botón.
            const SizedBox(height: 24),

            // Botón para guardar los datos y comenzar a utilizar la app.
            ElevatedButton(
              onPressed: _guardarYContinuar,

              // Añade espacio interior al botón.
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),

              // Texto que aparece dentro del botón.
              child: const Text(
                'Comenzar',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}