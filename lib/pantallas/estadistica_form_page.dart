import 'package:flutter/material.dart';
import '../modelos/estadistica.dart';
import '../servicios/estadistica_service.dart';
import '../servicios/habito_service.dart';
import '../widgets/boton_principal.dart';
import '../widgets/campo_texto_app.dart';

/// Formulario para crear (estadistica == null) o editar una estadística (admin).
class EstadisticaFormPage extends StatefulWidget {
  final Estadistica? estadistica;

  const EstadisticaFormPage({super.key, this.estadistica});

  @override
  State<EstadisticaFormPage> createState() => _EstadisticaFormPageState();
}

class _EstadisticaFormPageState extends State<EstadisticaFormPage> {
  late final TextEditingController _habitoController;
  late final TextEditingController _rachaController;
  late final TextEditingController _totalController;
  String _mensaje = '';

  @override
  void initState() {
    super.initState();
    final e = widget.estadistica;
    _habitoController = TextEditingController(text: e?.habitoId.toString() ?? '');
    _rachaController =
        TextEditingController(text: e?.rachaActual.toString() ?? '0');
    _totalController =
        TextEditingController(text: e?.totalDias.toString() ?? '0');
  }

  @override
  void dispose() {
    _habitoController.dispose();
    _rachaController.dispose();
    _totalController.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    final habitoId = int.tryParse(_habitoController.text.trim());
    final racha = int.tryParse(_rachaController.text.trim());
    final total = int.tryParse(_totalController.text.trim());

    if (habitoId == null || racha == null || total == null) {
      setState(() => _mensaje = 'Los tres campos deben ser números');
      return;
    }

    // El hábito indicado tiene que existir
    final habito = await HabitoService().obtenerPorId(habitoId);
    if (habito == null) {
      setState(() => _mensaje = 'No existe un hábito con ese ID');
      return;
    }

    final servicio = EstadisticaService();
    if (widget.estadistica == null) {
      await servicio.crear(Estadistica(
          habitoId: habitoId, rachaActual: racha, totalDias: total));
    } else {
      final e = widget.estadistica!;
      e.habitoId = habitoId;
      e.rachaActual = racha;
      e.totalDias = total;
      await servicio.actualizar(e);
    }

    if (!mounted) return;
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.estadistica == null
            ? 'Nueva estadística'
            : 'Editar estadística'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CampoTextoApp(
                etiqueta: 'ID del hábito', controlador: _habitoController),
            CampoTextoApp(
                etiqueta: 'Racha actual', controlador: _rachaController),
            CampoTextoApp(
                etiqueta: 'Total de días completados',
                controlador: _totalController),
            if (_mensaje.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(_mensaje, style: const TextStyle(color: Colors.red)),
              ),
            const SizedBox(height: 16),
            BotonPrincipal(texto: 'Guardar', alPulsar: _guardar),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
          ],
        ),
      ),
    );
  }
}
