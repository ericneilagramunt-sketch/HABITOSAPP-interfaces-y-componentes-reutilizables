import 'package:flutter/material.dart';
import '../models/habito.dart';
import '../models/usuario.dart';
import '../services/preferencias_service.dart';
// Permite al administrador consultar y gestionar los hábitos de una cuenta.
class AdministrarHabitosUsuarioPage extends StatefulWidget {
  final Usuario usuario;
  const AdministrarHabitosUsuarioPage({super.key, required this.usuario});
  @override
  State<AdministrarHabitosUsuarioPage> createState() =>
      _AdministrarHabitosUsuarioPageState();
}
class _AdministrarHabitosUsuarioPageState
    extends State<AdministrarHabitosUsuarioPage> {
  final _servicio = PreferenciasService();
  List<Habito> _habitos = [];
  bool _cargando = true;
  @override
  void initState() {
    super.initState();
    _cargar();
  }
  Future<void> _cargar() async {
    final datos = await _servicio.getHabitos(usuarioId: widget.usuario.id);
    if (!mounted) return;
    setState(() {
      _habitos = datos;
      _cargando = false;
    });
  }
  Future<void> _guardar() async {
    await _servicio.saveHabitos(_habitos, usuarioId: widget.usuario.id);
    if (mounted) setState(() {});
  }
  Future<void> _formulario({Habito? habito}) async {
    final nombre = TextEditingController(text: habito?.nombre ?? '');
    int color = habito?.colorHex ?? Colors.blue.value;
    final colores = [Colors.blue, Colors.red, Colors.green, Colors.orange, Colors.purple, Colors.teal];
    final resultado = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, actualizar) => AlertDialog(
          title: Text(habito == null ? 'Nuevo hábito' : 'Editar hábito'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nombre, decoration: const InputDecoration(labelText: 'Nombre')),
              const SizedBox(height: 14),
              Wrap(
                spacing: 8,
                children: colores.map((c) => GestureDetector(
                  onTap: () => actualizar(() => color = c.value),
                  child: CircleAvatar(
                    backgroundColor: c,
                    child: color == c.value ? const Icon(Icons.check, color: Colors.white) : null,
                  ),
                )).toList(),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(dialogContext, false), child: const Text('Cancelar')),
            TextButton(onPressed: () => Navigator.pop(dialogContext, true), child: const Text('Guardar')),
          ],
        ),
      ),
    );
    if (resultado == true && nombre.text.trim().isNotEmpty) {
      if (habito == null) {
        _habitos.add(Habito(
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          nombre: nombre.text.trim(),
          colorHex: color,
        ));
      } else {
        habito.nombre = nombre.text.trim();
        habito.colorHex = color;
      }
      await _guardar();
    }
    nombre.dispose();
  }
  Future<void> _eliminar(Habito habito) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Eliminar hábito'),
        content: Text('¿Eliminar ${habito.nombre}?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Eliminar')),
        ],
      ),
    );

    if (confirmar == true) {
    _habitos.removeWhere((h) => h.id == habito.id);
    await _guardar();
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Hábitos de ${widget.usuario.nombre}')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _formulario(),
        child: const Icon(Icons.add),
      ),
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : _habitos.isEmpty
          ? const Center(child: Text('Este usuario todavía no tiene hábitos.'))
          : ListView(
        children: _habitos.map((h) => Card(
          child: ListTile(
            leading: CircleAvatar(backgroundColor: Color(h.colorHex)),
            title: Text(h.nombre),
            subtitle: Text('Días completados: ${h.fechasCompletadas.length}'),
            trailing: Wrap(
              children: [
                IconButton(icon: const Icon(Icons.edit), onPressed: () => _formulario(habito: h)),
                IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => _eliminar(h)),
              ],
            ),
          ),
        )).toList(),
      ),
    );
  }
}