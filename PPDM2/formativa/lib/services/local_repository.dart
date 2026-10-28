import '../models/local.dart';

abstract interface class LocalRepository {
  Stream<List<Local>> watchLocais();

  Future<void> adicionar(Local local);

  Future<void> atualizar(Local local);

  Future<void> excluir(String id);

  Future<void> alterarFavorito(String id, bool favorito);

  Future<void> garantirDadosIniciais();
}
