import 'package:flutter/material.dart';

/// Campo de texto con el diseño común de toda la app.
/// Sirve para campos normales y para contraseñas (ocultar: true).
/// El controlador lo crea y lo libera la pantalla que usa el campo.
class CampoTextoApp extends StatelessWidget {
  final String etiqueta;
  final TextEditingController controlador;
  final bool ocultar;

  const CampoTextoApp({
    super.key,
    required this.etiqueta,
    required this.controlador,
    this.ocultar = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controlador,
        obscureText: ocultar,
        decoration: InputDecoration(
          labelText: etiqueta,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
