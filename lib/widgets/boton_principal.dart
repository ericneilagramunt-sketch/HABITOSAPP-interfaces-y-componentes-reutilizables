import 'package:flutter/material.dart';
// Botón reutilizable para las acciones principales.
class BotonPrincipal extends StatelessWidget {
  final String texto;
  final VoidCallback onPressed;
  const BotonPrincipal({
    super.key,
    required this.texto,
    required this.onPressed,
  });
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          textStyle: const TextStyle(fontSize: 16),
        ),
        child: Text(texto),
      ),
    );
  }
}