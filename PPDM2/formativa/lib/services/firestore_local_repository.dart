import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/local.dart';
import '../models/locais_exemplo.dart';
import 'local_repository.dart';

class FirestoreLocalRepository implements LocalRepository {
  FirestoreLocalRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _locais =>
      _firestore.collection('locais');

  @override
  Stream<List<Local>> watchLocais() {
    return _locais.snapshots().map((snapshot) {
      final locais = snapshot.docs
          .map((documento) => Local.fromMap(documento.id, documento.data()))
          .toList();

      locais.sort((a, b) => a.nome.compareTo(b.nome));
      return locais;
    });
  }

  @override
  Future<void> adicionar(Local local) async {
    await _locais.add(local.toMap());
  }

  @override
  Future<void> atualizar(Local local) async {
    await _locais.doc(local.id).update(local.toMap());
  }

  @override
  Future<void> excluir(String id) async {
    await _locais.doc(id).delete();
  }

  @override
  Future<void> alterarFavorito(String id, bool favorito) async {
    await _locais.doc(id).update({'favorito': favorito});
  }

  @override
  Future<void> garantirDadosIniciais() async {
    final consulta = await _locais.limit(1).get();
    if (consulta.docs.isNotEmpty) {
      return;
    }

    final batch = _firestore.batch();
    for (final local in locaisExemplo) {
      batch.set(_locais.doc(local.id), local.toMap());
    }
    await batch.commit();
  }
}
