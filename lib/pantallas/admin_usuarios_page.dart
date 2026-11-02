import 'package:flutter/material.dart';
import '../modelos/usuario.dart';
import '../servicios/usuario_service.dart';
import '../widgets/confirmar_eliminar.dart';
import 'usuario_form_page.dart';

/// El administrador consulta, crea, edita y elimina usuarios.
class AdminUsuariosPage extends StatefulWidget {
  final Usuario admin;

  const AdminUsuariosPage({super.key, required this.admin});

  @override
  State<AdminUsuariosPage> createState() => _AdminUsuariosPageState();
}

class _AdminUsuariosPageState extends State<AdminUsuariosPage> {
  List<Usuario> _usuarios = [];
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    final lista = await UsuarioService().obtenerTodos();
    if (!mounted) return;
    setState(() {
      _usuarios = lista;
      _cargando = false;
    });
  }

  Future<void> _abrirFormulario([Usuario? u]) async {
    final guardado = await Navigator.push<bool>(
      context,
      MaterialPageRoute<bool>(builder: (_) => UsuarioFormPage(usuario: u)),
    );
    if (!mounted) return;
    if (guardado == true) await _cargar();
  }

  Future<void> _eliminar(Usuario u) async {
    if (u.id == widget.admin.id) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No puedes eliminarte a ti mismo')),
      );
      return;
    }
    final ok = await confirmarEliminar(
        context, '¿Eliminar a "${u.usuario}" y todos sus hábitos?');
    if (!ok) return;
    await UsuarioService().eliminar(u.id!);
    if (!mounted) return;
    await _cargar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Usuarios')),
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.only(bottom: 80),
              itemCount: _usuarios.length,
              itemBuilder: (context, index) {
                final u = _usuarios[index];
                return Card(
                  child: ListTile(
                    title: Text('${u.usuario} (ID ${u.id})'),
                    subtitle: Text(
                        '${u.nombre} ${u.apellidos}\n${u.email} - ${u.rol}'),
                    isThreeLine: true,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _abrirFormulario(u),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _eliminar(u),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Nuevo usuario',
        onPressed: () => _abrirFormulario(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
