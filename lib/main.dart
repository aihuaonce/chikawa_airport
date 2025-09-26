import 'package:flutter/material.dart';
import 'home.dart';
import 'package:provider/provider.dart';
import 'data/db/app_database.dart';
import 'data/db/daos.dart';
import 'routes_config.dart'; // ← 引入路由設定檔

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
        // ★ 確保 PatientProfilesDao 也被提供，以便 PersonalInformationPage 可以使用
        ProxyProvider<AppDatabase, PatientProfilesDao>(
          update: (_, db, __) => PatientProfilesDao(db),
        ),
        ProxyProvider<AppDatabase, AccidentRecordsDao>(
          update: (_, db, __) => AccidentRecordsDao(db),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 取得所有子頁面的路由地圖
    final Map<String, WidgetBuilder> subRoutes = generateRoutes();

    // 建立包含主頁的完整路由地圖
    final Map<String, WidgetBuilder> fullRoutes = {
      // 根路由：HomePage (包含 Nav1Page)
      '/': (context) => const HomePage(),
    };
    fullRoutes.addAll(subRoutes); // 加入所有子頁面 (Nav2Page 包裹的內容)

    return MaterialApp(
      title: 'Accident Demo',
      // 設定起始路由
      initialRoute: '/',
      routes: fullRoutes,
    );
  }
}
