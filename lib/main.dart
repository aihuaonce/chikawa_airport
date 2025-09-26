import 'package:flutter/material.dart';
import 'login.dart';
import 'nav2.dart';
import 'package:provider/provider.dart';
import 'data/db/app_database.dart';   // 你剛剛做好的
import 'data/db/daos.dart';
import 'AccidentRecord.dart'; // 你的 UI


void main() {
  runApp(
    MultiProvider(
      providers: [
        // 提供全域唯一的 AppDatabase
        Provider<AppDatabase>(
          create: (_) => AppDatabase(),
          dispose: (_, db) => db.close(),
        ),
        // 由 AppDatabase 派生出 AccidentRecordDao
        ProxyProvider<AppDatabase, VisitsDao>(
          update: (_, db, __) => VisitsDao(db),
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
    return MaterialApp(
      title: 'Accident Demo',
      home: const LoginPage(),
    );
  }
}