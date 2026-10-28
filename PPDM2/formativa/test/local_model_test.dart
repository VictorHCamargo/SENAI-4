import 'package:flutter_test/flutter_test.dart';
import 'package:formativa/models/local.dart';

void main() {
  test('converte documento do Firestore para Local e de volta', () {
    final local = Local.fromMap('abc', <String, dynamic>{
      'nome': 'Academia Teste',
      'categoria': 'Academia',
      'cidade': 'Campinas',
      'avaliacao': 4,
      'distancia': 1.5,
      'horario': '06:00 - 22:00',
      'descricao': 'Descricao completa do estabelecimento.',
      'favorito': true,
    });

    expect(local.id, 'abc');
    expect(local.avaliacao, 4.0);
    expect(local.favorito, isTrue);
    expect(local.toMap()['cidade'], 'Campinas');
  });

  test('aceita campos numericos inteiros ou decimais', () {
    final local = Local.fromMap('abc', <String, dynamic>{
      'avaliacao': 5,
      'distancia': 2,
    });

    expect(local.avaliacao, isA<double>());
    expect(local.distancia, 2.0);
  });
}
