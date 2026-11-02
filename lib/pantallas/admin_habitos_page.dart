import 'package:flutter/material.dart';
import '../modelos/habito.dart';
import '../modelos/usuario.dart';
import '../servicios/habito_service.dart';
import '../widgets/confirmar_eliminar.dart';
import '../widgets/tarjeta_habito.dart';
import 'editar_habito_page.dart';

/// El administrador ve y gestiona los hábitos de TODOS los usuarios.
class AdminHabitosPage extends StatefulWidget {
  final Usuario admin;

  const AdminHabitosPage({super.key, required this.admin});

  @override
  State<AdminHabitosPage> createState() => _AdminHabitosPageState();
}

class _AdminHabitosPageState extends State<AdminHabitosPage> {
  List<Habito> _habitos = [];
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    final lista = await HabitoService().obtenerTodos();
    if (!mounted) return;
    setState(() {
      _habitos = lista;
      _cargando = false;
    });
  }

  Future<void> _abrirEditor([Habito? h]) async {
    final guardado = await Navigator.push<bool>(
      context,
      MaterialPageRoute<bool>(
        builder: (_) => EditarHabitoPage(usuario: widget.admin, habito: h),
      ),
    );
    if (!mounted) return;
    if (guardado == true) await _cargar();
  }

  Future<void> _eliminar(Habito h) async {
    final ok = await confirmarEliminar(context, '¿Eliminar "${h.nombre}"?');
    if (!ok) return;
    await HabitoService().eliminar(h.id!);
    if (!mounted) return;
    await _cargar();
  }

  Future<void> _completar(Habito h) async {
    await HabitoService().alternarHoy(h);
    if (!mounted) return;
    await _cargar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Todos los hábitos')),
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : _habitos.isEmpty
              ? const Center(child: Text('Todavía no hay hábitos.'))
              : ListView.builder(
                  padding: const EdgeInsets.only(bottom: 80),
                  itemCount: _habitos.length,
                  itemBuilder: (context, index) {
                    final h = _habitos[index];
                    return TarjetaHabito(
                      nombre: '${h.nombre} (usuario ${h.usuarioId})',
                      color: Color(h.colorHex),
                      completadoHoy: h.estaCompletadoHoy(),
                      alCompletar: () => _completar(h),
                      alEditar: () => _abrirEditor(h),
                      alEliminar: () => _eliminar(h),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Nuevo hábito',
        onPressed: () => _abrirEditor(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
