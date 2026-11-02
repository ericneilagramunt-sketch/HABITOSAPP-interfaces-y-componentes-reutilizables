import 'package:flutter/material.dart';

/// Botón de las acciones principales (acceder, registrarse, guardar...).
/// La acción llega por el constructor (alPulsar).
class BotonPrincipal extends StatelessWidget {
  final String texto;
  final VoidCallback alPulsar;

  const BotonPrincipal({
    super.key,
    required this.texto,
    required this.alPulsar,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: alPulsar,
          style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16)),
          child: Text(texto, style: const TextStyle(fontSize: 18)),
        ),
      ),
    );
  }
}
