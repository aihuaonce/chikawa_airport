import 'package:chikawa_airport/data/models/reference_service.dart';
import 'package:chikawa_airport/data/models/sync_service_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'data/db/database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database = AppDatabase();
  final refService = ReferenceService(database);
  final syncServiceProvider = SyncServiceProvider();

  await refService.init();
  await syncServiceProvider.initialize(database);

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  runApp(
    MultiProvider(
      providers: [
        Provider<AppDatabase>.value(value: database),
        ChangeNotifierProvider<ReferenceService>.value(value: refService),
        ChangeNotifierProvider<SyncServiceProvider>.value(value: syncServiceProvider),
      ],
      child: const MyApp(),
    ),
  );
}
