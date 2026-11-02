import 'package:flutter/material.dart';
import '../modelos/habito.dart';
import '../modelos/usuario.dart';
import '../servicios/habito_service.dart';
import '../servicios/sesion_service.dart';
import '../widgets/confirmar_eliminar.dart';
import '../widgets/tarjeta_habito.dart';
import 'administracion_page.dart';
import 'editar_habito_page.dart';
import 'estadisticas_page.dart';
import 'login_page.dart';

/// Lista de hábitos del usuario que ha iniciado sesión.
class HabitosPage extends StatefulWidget {
  final Usuario usuario;

  const HabitosPage({super.key, required this.usuario});

  @override
  State<HabitosPage> createState() => _HabitosPageState();
}

class _HabitosPageState extends State<HabitosPage> {
  final _habitoService = HabitoService();
  bool _cargando = true;
  List<Habito> _habitos = [];

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  // Un usuario solo ve SUS hábitos
  Future<void> _cargar() async {
    final lista = await _habitoService.obtenerPorUsuario(widget.usuario.id!);
    if (!mounted) return;
    setState(() {
      _habitos = lista;
      _cargando = false;
    });
  }

  Future<void> _completar(Habito h) async {
    await _habitoService.alternarHoy(h);
    if (!mounted) return;
    await _cargar();
  }

  Future<void> _eliminar(Habito h) async {
    final ok = await confirmarEliminar(context, '¿Eliminar "${h.nombre}"?');
    if (!ok) return;
    await _habitoService.eliminar(h.id!);
    if (!mounted) return;
    await _cargar();
  }

  // Abre el editor (hábito nuevo si h es null) y recarga si se guardó
  Future<void> _abrirEditor([Habito? h]) async {
    final guardado = await Navigator.push<bool>(
      context,
      MaterialPageRoute<bool>(
        builder: (_) => EditarHabitoPage(usuario: widget.usuario, habito: h),
      ),
    );
    if (!mounted) return;
    if (guardado == true) await _cargar();
  }

  void _abrirEstadisticas() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (_) => EstadisticasPage(usuario: widget.usuario)),
    );
  }

  void _abrirAdministracion() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (_) => AdministracionPage(usuario: widget.usuario)),
    );
  }

  Future<void> _cerrarSesion() async {
    await SesionService().cerrarSesion();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (ruta) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: const Text('Mis hábitos'),
      actions: [
        IconButton(
          tooltip: 'Estadísticas',
          icon: const Icon(Icons.bar_chart),
          onPressed: _abrirEstadisticas,
        ),
        // La administración solo aparece para el administrador
        if (widget.usuario.esAdmin)
          IconButton(
            tooltip: 'Administración',
            icon: const Icon(Icons.admin_panel_settings),
            onPressed: _abrirAdministracion,
          ),
        IconButton(
          tooltip: 'Cerrar sesión',
          icon: const Icon(Icons.logout),
          onPressed: _cerrarSesion,
        ),
      ],
    );

    if (_cargando) {
      return Scaffold(
        appBar: appBar,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final hechos = _habitos.where((h) => h.estaCompletadoHoy()).length;

    return Scaffold(
      appBar: appBar,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '¡Hola, ${widget.usuario.nombre}!',
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text('Hoy: $hechos de ${_habitos.length} hábitos'),
              ],
            ),
          ),
          Expanded(
            child: _habitos.isEmpty
                ? const Center(
                    child: Text('Todavía no hay hábitos. Pulsa + para crear uno.'),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 80),
                    itemCount: _habitos.length,
                    itemBuilder: (context, index) {
                      final h = _habitos[index];
                      return TarjetaHabito(
                        nombre: h.nombre,
                        color: Color(h.colorHex),
                        completadoHoy: h.estaCompletadoHoy(),
                        alCompletar: () => _completar(h),
                        alEditar: () => _abrirEditor(h),
                        alEliminar: () => _eliminar(h),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Nuevo hábito',
        onPressed: () => _abrirEditor(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
