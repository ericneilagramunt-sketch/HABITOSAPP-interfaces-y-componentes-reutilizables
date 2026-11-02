import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habitosapp/widgets/campo_texto_app.dart';
import 'package:habitosapp/widgets/boton_principal.dart';
import 'package:habitosapp/widgets/tarjeta_habito.dart';
import 'package:habitosapp/widgets/dato_estadistica.dart';
void main() {
  testWidgets('CampoTextoApp muestra su etiqueta', (tester) async {
    final controller = TextEditingController();
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: CampoTextoApp(etiqueta: 'Nombre', controller: controller),
      ),
    ));
    expect(find.text('Nombre'), findsOneWidget);
    controller.dispose();
  });
  testWidgets('BotonPrincipal ejecuta su callback', (tester) async {
    var pulsado = false;
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: BotonPrincipal(texto: 'Guardar', onPressed: () => pulsado = true),
      ),
    ));
    await tester.tap(find.text('Guardar'));
    expect(pulsado, isTrue);
  });
  testWidgets('TarjetaHabito muestra el estado recibido', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: TarjetaHabito(
          nombre: 'Beber agua',
          color: Colors.blue,
          completado: true,
          onCompletar: () {},
          onEditar: () {},
          onEliminar: () {},
        ),
      ),
    ));
    expect(find.text('Beber agua'), findsOneWidget);
    expect(find.text('Completado hoy'), findsOneWidget);
  });
  testWidgets('DatoEstadistica muestra etiqueta y valor', (tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(
        body: DatoEstadistica(
          etiqueta: 'Racha actual',
          valor: '4 días',
          icono: Icons.local_fire_department,
        ),
      ),
    ));
    expect(find.text('Racha actual'), findsOneWidget);
    expect(find.text('4 días'), findsOneWidget);
  });
}