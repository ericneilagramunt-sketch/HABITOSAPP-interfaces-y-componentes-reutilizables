import 'package:flutter/material.dart';
import '../modelos/estadistica.dart';
import '../servicios/estadistica_service.dart';
import '../widgets/confirmar_eliminar.dart';
import 'estadistica_form_page.dart';

/// El administrador gestiona todas las filas de la tabla estadisticas.
class AdminEstadisticasPage extends StatefulWidget {
  const AdminEstadisticasPage({super.key});

  @override
  State<AdminEstadisticasPage> createState() => _AdminEstadisticasPageState();
}

class _AdminEstadisticasPageState extends State<AdminEstadisticasPage> {
  List<Estadistica> _lista = [];
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    final datos = await EstadisticaService().obtenerTodas();
    if (!mounted) return;
    setState(() {
      _lista = datos;
      _cargando = false;
    });
  }

  Future<void> _abrirFormulario([Estadistica? e]) async {
    final guardado = await Navigator.push<bool>(
      context,
      MaterialPageRoute<bool>(
          builder: (_) => EstadisticaFormPage(estadistica: e)),
    );
    if (!mounted) return;
    if (guardado == true) await _cargar();
  }

  Future<void> _eliminar(Estadistica e) async {
    final ok = await confirmarEliminar(
        context, '¿Eliminar la estadística del hábito ${e.habitoId}?');
    if (!ok) return;
    await EstadisticaService().eliminar(e.id!);
    if (!mounted) return;
    await _cargar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Estadísticas (admin)')),
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.only(bottom: 80),
              itemCount: _lista.length,
              itemBuilder: (context, index) {
                final e = _lista[index];
                return Card(
                  child: ListTile(
                    title: Text('Hábito ${e.habitoId}'),
                    subtitle: Text(
                        'Racha: ${e.rachaActual} - Total: ${e.totalDias} días'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _abrirFormulario(e),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _eliminar(e),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Nueva estadística',
        onPressed: () => _abrirFormulario(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
