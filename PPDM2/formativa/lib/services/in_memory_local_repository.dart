import 'dart:async';

import '../models/local.dart';
import '../models/locais_exemplo.dart';
import 'local_repository.dart';

class InMemoryLocalRepository implements LocalRepository {
  InMemoryLocalRepository({List<Local>? dadosIniciais})
    : _locais = List<Local>.from(dadosIniciais ?? locaisExemplo);

  final List<Local> _locais;
  final StreamController<List<Local>> _controller =
      StreamController<List<Local>>.broadcast();
  int _proximoId = 1;

  @override
  Stream<List<Local>> watchLocais() async* {
    yield _snapshot();
    yield* _controller.stream;
  }

  @override
  Future<void> adicionar(Local local) async {
    _locais.add(local.copyWith(id: 'demo-${_proximoId++}'));
    _emitir();
  }

  @override
  Future<void> atualizar(Local local) async {
    final indice = _locais.indexWhere((item) => item.id == local.id);
    if (indice == -1) {
      throw StateError('Local não encontrado.');
    }
    _locais[indice] = local;
    _emitir();
  }

  @override
  Future<void> excluir(String id) async {
    _locais.removeWhere((local) => local.id == id);
    _emitir();
  }

  @override
  Future<void> alterarFavorito(String id, bool favorito) async {
    final indice = _locais.indexWhere((local) => local.id == id);
    if (indice == -1) {
      throw StateError('Local não encontrado.');
    }
    _locais[indice] = _locais[indice].copyWith(favorito: favorito);
    _emitir();
  }

  @override
  Future<void> garantirDadosIniciais() async {
    if (_locais.isEmpty) {
      _locais.addAll(locaisExemplo);
      _emitir();
    }
  }

  List<Local> _snapshot() => List<Local>.unmodifiable(_locais);

  void _emitir() {
    _controller.add(_snapshot());
  }
}
