import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:formativa/app.dart';
import 'package:formativa/services/in_memory_local_repository.dart';

void main() {
  testWidgets('navega do mapa para a lista de resultados', (tester) async {
    await tester.pumpWidget(
      MapaLocaisApp(
        repository: InMemoryLocalRepository(),
        firebaseAtivo: false,
      ),
    );

    expect(find.text('São Paulo'), findsOneWidget);
    expect(find.byKey(const Key('campo-pesquisa-mapa')), findsOneWidget);
    expect(find.byKey(const Key('botao-ver-resultados')), findsOneWidget);

    await tester.tap(find.byKey(const Key('botao-ver-resultados')));
    await tester.pumpAndSettle();

    expect(find.text('Resultados'), findsOneWidget);
    expect(find.text('Academia Fitness'), findsOneWidget);
    expect(find.byKey(const Key('botao-cadastrar-local')), findsOneWidget);
  });
}
