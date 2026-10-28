import '../models/local.dart';

class LocalFilters {
  const LocalFilters._();

  static List<Local> apply(
    List<Local> locais, {
    String texto = '',
    String cidade = 'Todas',
    String categoria = 'Todos',
    bool somenteFavoritos = false,
  }) {
    final termo = _normalizar(texto.trim());

    final resultado = locais.where((local) {
      final correspondeCidade = cidade == 'Todas' || local.cidade == cidade;
      final correspondeCategoria =
          categoria == 'Todos' || local.categoria == categoria;
      final correspondeFavorito = !somenteFavoritos || local.favorito;
      final correspondeTexto =
          termo.isEmpty ||
          _normalizar(local.nome).contains(termo) ||
          _normalizar(local.categoria).contains(termo);

      return correspondeCidade &&
          correspondeCategoria &&
          correspondeFavorito &&
          correspondeTexto;
    }).toList();

    resultado.sort((a, b) {
      if (a.favorito != b.favorito) {
        return a.favorito ? -1 : 1;
      }
      return a.distancia.compareTo(b.distancia);
    });

    return resultado;
  }

  static String _normalizar(String value) {
    const comAcento = 'áàâãäéèêëíìîïóòôõöúùûüç';
    const semAcento = 'aaaaaeeeeiiiiooooouuuuc';
    var normalizado = value.toLowerCase();

    for (var indice = 0; indice < comAcento.length; indice++) {
      normalizado = normalizado.replaceAll(
        comAcento[indice],
        semAcento[indice],
      );
    }

    return normalizado;
  }
}
