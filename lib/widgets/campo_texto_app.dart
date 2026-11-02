import 'package:flutter/material.dart';
// Campo de texto común para los formularios de la aplicación.
class CampoTextoApp extends StatelessWidget {
  final String etiqueta;
  final TextEditingController controller;
  final bool ocultar;
  const CampoTextoApp({
    super.key,
    required this.etiqueta,
    required this.controller,
    this.ocultar = false,
  });
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: ocultar,
      decoration: InputDecoration(
        labelText: etiqueta,
        border: const OutlineInputBorder(),
      ),
    );
  }
}