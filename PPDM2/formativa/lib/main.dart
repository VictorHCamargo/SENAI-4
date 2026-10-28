import 'package:flutter/material.dart';

import 'app.dart';
import 'services/app_bootstrap.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final bootstrap = await AppBootstrap.initialize();

  runApp(
    MapaLocaisApp(
      repository: bootstrap.repository,
      firebaseAtivo: bootstrap.firebaseAtivo,
    ),
  );
}
