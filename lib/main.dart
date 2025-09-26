import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/db/app_database.dart';
import 'data/db/daos.dart';
import 'home.dart';
import 'routes_config.dart';
import 'nav2.dart';
import 'data/models/patient_data.dart'; // 導入 PatientData

void main() {
  runApp(
    MultiProvider(
      providers: [
        Provider<AppDatabase>(
          create: (_) => AppDatabase(),
          dispose: (_, db) => db.close(),
        ),
        ProxyProvider<AppDatabase, VisitsDao>(
          update: (_, db, __) => VisitsDao(db),
        ),
        ProxyProvider<AppDatabase, PatientProfilesDao>(
          update: (_, db, __) => PatientProfilesDao(db),
        ),
        // ★ 添加 PatientData Provider
        ChangeNotifierProvider<PatientData>(create: (_) => PatientData()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Map<String, WidgetBuilder> generateRoutes() {
    return {
      for (var route in routeItems)
        route.path: (context) {
          final routeSettings = ModalRoute.of(context)?.settings;
          final visitId = routeSettings?.arguments as int? ?? 1;

          return Nav2Page(
            visitId: visitId,
            initialIndex: routeItems.indexWhere(
              (item) => item.path == route.path,
            ),
          );
        },
    };
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, WidgetBuilder> subRoutes = generateRoutes();
    final Map<String, WidgetBuilder> fullRoutes = {
      '/': (context) => const HomePage(),
    };
    fullRoutes.addAll(subRoutes);

    return MaterialApp(
      title: 'Accident Demo',
      initialRoute: '/',
      routes: fullRoutes,
    );
  }
}
