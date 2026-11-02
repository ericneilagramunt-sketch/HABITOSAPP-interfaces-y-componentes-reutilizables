import 'package:flutter/material.dart';
import '../modelos/usuario.dart';
import '../widgets/boton_principal.dart';
import 'admin_estadisticas_page.dart';
import 'admin_habitos_page.dart';
import 'admin_usuarios_page.dart';

/// Panel de administración: solo para el rol "administrador".
class AdministracionPage extends StatelessWidget {
  final Usuario usuario;

  const AdministracionPage({super.key, required this.usuario});

  @override
  Widget build(BuildContext context) {
    // Protección: si no es administrador no ve las opciones
    if (!usuario.esAdmin) {
      return Scaffold(
        appBar: AppBar(title: const Text('Administración')),
        body: const Center(child: Text('Acceso solo para administradores')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Administración')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            BotonPrincipal(
              texto: 'Gestionar usuarios',
              alPulsar: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => AdminUsuariosPage(admin: usuario)),
              ),
            ),
            BotonPrincipal(
              texto: 'Gestionar hábitos',
              alPulsar: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => AdminHabitosPage(admin: usuario)),
              ),
            ),
            BotonPrincipal(
              texto: 'Gestionar estadísticas',
              alPulsar: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AdminEstadisticasPage()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
