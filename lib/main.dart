import 'package:chikawa_airport/data/models/reference_service.dart';
import 'package:chikawa_airport/data/models/sync_service_provider.dart';
import 'package:chikawa_airport/data/services/firebase_service.dart';
import 'package:chikawa_airport/ambulance/pages/body_map.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'data/db/database.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final database = AppDatabase();
  final refService = ReferenceService(database);
  final syncServiceProvider = SyncServiceProvider();
  final firebaseService = FirebaseService();

  await refService.init();
  await syncServiceProvider.initialize(database);
  await firebaseService.initialize();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  runApp(
    MultiProvider(
      providers: [
        Provider<AppDatabase>.value(value: database),
        ChangeNotifierProvider<ReferenceService>.value(value: refService),
        ChangeNotifierProvider<SyncServiceProvider>.value(
          value: syncServiceProvider,
        ),
        Provider<FirebaseService>.value(value: firebaseService),
        ChangeNotifierProvider<BodyMapProvider>(
          create: (_) => BodyMapProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}
