import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

import '../firebase_options.dart';
import 'firestore_local_repository.dart';
import 'in_memory_local_repository.dart';
import 'local_repository.dart';

class AppBootstrapResult {
  const AppBootstrapResult({
    required this.repository,
    required this.firebaseAtivo,
  });

  final LocalRepository repository;
  final bool firebaseAtivo;
}

class AppBootstrap {
  const AppBootstrap._();

  static Future<AppBootstrapResult> initialize() async {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      if (FirebaseAuth.instance.currentUser == null) {
        await FirebaseAuth.instance.signInAnonymously();
      }

      final repository = FirestoreLocalRepository();
      await repository.garantirDadosIniciais();

      return AppBootstrapResult(repository: repository, firebaseAtivo: true);
    } on Object catch (error, stackTrace) {
      debugPrint('Firebase indisponível; iniciando modo demonstração: $error');
      debugPrintStack(stackTrace: stackTrace);

      return AppBootstrapResult(
        repository: InMemoryLocalRepository(),
        firebaseAtivo: false,
      );
    }
  }
}
