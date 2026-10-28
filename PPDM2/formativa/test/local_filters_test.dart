import 'package:flutter_test/flutter_test.dart';
import 'package:formativa/models/locais_exemplo.dart';
import 'package:formativa/utils/local_filters.dart';

void main() {
  test('pesquisa por nome ou categoria ignorando maiusculas e acentos', () {
    final porNome = LocalFilters.apply(locaisExemplo, texto: 'cafe');
    final porCategoria = LocalFilters.apply(locaisExemplo, texto: 'ACADEMIA');

    expect(porNome.map((local) => local.nome), contains('Café Cambuí'));
    expect(
      porCategoria.every((local) => local.categoria == 'Academia'),
      isTrue,
    );
  });

  test('combina cidade, categoria e favorito', () {
    final resultado = LocalFilters.apply(
      locaisExemplo,
      cidade: 'São Paulo',
      categoria: 'Academia',
      somenteFavoritos: true,
    );

    expect(resultado, hasLength(1));
    expect(resultado.single.nome, 'Academia Fitness');
  });
}
