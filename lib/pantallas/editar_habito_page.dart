import 'package:flutter/material.dart';
import '../modelos/color_habito.dart';
import '../modelos/habito.dart';
import '../modelos/usuario.dart';
import '../servicios/habito_service.dart';
import '../servicios/usuario_service.dart';
import '../widgets/boton_principal.dart';
import '../widgets/campo_texto_app.dart';

/// Una misma pantalla para crear (habito == null) y editar un hábito.
/// Al guardar vuelve con Navigator.pop(context, true); al cancelar, sin valor.
class EditarHabitoPage extends StatefulWidget {
  final Usuario usuario; // quien está usando la app
  final Habito? habito;

  const EditarHabitoPage({super.key, required this.usuario, this.habito});

  @override
  State<EditarHabitoPage> createState() => _EditarHabitoPageState();
}

class _EditarHabitoPageState extends State<EditarHabitoPage> {
  late final TextEditingController _nombreController;
  late final TextEditingController _duenoController;
  late int _color;
  String _mensaje = '';

  @override
  void initState() {
    super.initState();
    // Crear: nombre vacío y color inicial. Editar: datos actuales.
    _nombreController = TextEditingController(text: widget.habito?.nombre ?? '');
    _color = widget.habito?.colorHex ?? ColoresHabito.azul.valor;
    final dueno = widget.habito?.usuarioId ?? widget.usuario.id;
    _duenoController = TextEditingController(text: dueno.toString());
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _duenoController.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    final nombre = _nombreController.text.trim();
    if (nombre.isEmpty) {
      setState(() => _mensaje = 'Escribe un nombre');
      return;
    }

    // Un usuario normal siempre guarda en su propia cuenta
    var dueno = widget.habito?.usuarioId ?? widget.usuario.id!;

    // El administrador puede elegir el usuario dueño del hábito
    if (widget.usuario.esAdmin) {
      final id = int.tryParse(_duenoController.text.trim());
      if (id == null) {
        setState(() => _mensaje = 'El ID del usuario debe ser un número');
        return;
      }
      final existe = await UsuarioService().obtenerPorId(id);
      if (existe == null) {
        setState(() => _mensaje = 'No existe un usuario con ese ID');
        return;
      }
      dueno = id;
    }

    final servicio = HabitoService();
    if (widget.habito == null) {
      await servicio.crear(
        Habito(usuarioId: dueno, nombre: nombre, colorHex: _color),
      );
    } else {
      final h = widget.habito!;
      h.nombre = nombre;
      h.colorHex = _color;
      h.usuarioId = dueno;
      await servicio.actualizar(h);
    }

    if (!mounted) return;
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final esNuevo = widget.habito == null;
    final colorBorde = Theme.of(context).colorScheme.onSurface;

    return Scaffold(
      appBar: AppBar(title: Text(esNuevo ? 'Nuevo hábito' : 'Editar hábito')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CampoTextoApp(
              etiqueta: 'Nombre del hábito',
              controlador: _nombreController,
            ),
            if (widget.usuario.esAdmin)
              CampoTextoApp(
                etiqueta: 'ID del usuario dueño',
                controlador: _duenoController,
              ),
            const SizedBox(height: 16),
            const Text('Color',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            // Botones de color en una Row (con scroll horizontal si no caben)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (final c in ColoresHabito.todos)
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ElevatedButton.icon(
                        onPressed: () => setState(() => _color = c.valor),
                        icon: Icon(
                          _color == c.valor
                              ? Icons.check_circle
                              : Icons.circle_outlined,
                          size: 18,
                        ),
                        label: Text(c.nombre),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(c.valor),
                          foregroundColor: Colors.white,
                          side: _color == c.valor
                              ? BorderSide(color: colorBorde, width: 3)
                              : BorderSide.none,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            if (_mensaje.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(_mensaje, style: const TextStyle(color: Colors.red)),
              ),
            const SizedBox(height: 24),
            BotonPrincipal(texto: 'Guardar', alPulsar: _guardar),
            // Cancelar vuelve sin guardar
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
