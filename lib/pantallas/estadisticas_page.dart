import 'package:flutter/material.dart';
import '../modelos/estadistica.dart';
import '../modelos/habito.dart';
import '../modelos/usuario.dart';
import '../servicios/estadistica_service.dart';
import '../servicios/habito_service.dart';
import '../widgets/dato_estadistica.dart';

/// Estadísticas de los hábitos del usuario (leídas de la tabla estadisticas).
class EstadisticasPage extends StatefulWidget {
  final Usuario usuario;

  const EstadisticasPage({super.key, required this.usuario});

  @override
  State<EstadisticasPage> createState() => _EstadisticasPageState();
}

class _EstadisticasPageState extends State<EstadisticasPage> {
  bool _cargando = true;
  List<Habito> _habitos = [];
  final Map<int, Estadistica> _estadisticas = {};

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    final habitos = await HabitoService().obtenerPorUsuario(widget.usuario.id!);
    for (final h in habitos) {
      final e = await EstadisticaService().obtenerPorHabito(h.id!);
      if (e != null) _estadisticas[h.id!] = e;
    }
    if (!mounted) return;
    setState(() {
      _habitos = habitos;
      _cargando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Estadísticas')),
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : _habitos.isEmpty
              ? const Center(child: Text('Todavía no hay hábitos.'))
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: _habitos.length,
                  itemBuilder: (context, index) {
                    final h = _habitos[index];
                    final e = _estadisticas[h.id!];
                    // Cada hábito: su nombre y debajo sus dos datos
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 12, bottom: 4),
                          child: Text(
                            h.nombre,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(h.colorHex),
                            ),
                          ),
                        ),
                        DatoEstadistica(
                          etiqueta: 'Racha actual',
                          valor: '${e?.rachaActual ?? 0} días',
                          icono: Icons.local_fire_department,
                          color: Colors.orange,
                        ),
                        DatoEstadistica(
                          etiqueta: 'Días completados',
                          valor: '${e?.totalDias ?? 0}',
                          icono: Icons.check_circle,
                          color: Colors.green,
                        ),
                      ],
                    );
                  },
                ),
    );
  }
}
