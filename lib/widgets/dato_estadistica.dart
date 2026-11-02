import 'package:flutter/material.dart';
// Muestra una estadística con un diseño común.
class DatoEstadistica extends StatelessWidget {
  final String etiqueta;
  final String valor;
  final IconData icono;
  final Color color;
  const DatoEstadistica({
    super.key,
    required this.etiqueta,
    required this.valor,
    required this.icono,
    this.color = Colors.blue,
  });
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(icono, color: color, size: 30),
            const SizedBox(width: 12),
            Expanded(child: Text(etiqueta)),
            Text(valor, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}