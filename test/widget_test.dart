import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:habitosapp/widgets/boton_principal.dart';

void main() {
  testWidgets('BotonPrincipal ejecuta la acción recibida', (tester) async {
    var pulsado = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BotonPrincipal(
            texto: 'Entrar',
            alPulsar: () {
              pulsado = true;
            },
          ),
        ),
      ),
    );

    await tester.tap(find.text('Entrar'));
    expect(pulsado, true);
  });
}
}
