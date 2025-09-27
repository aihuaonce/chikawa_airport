import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/models/patient_data.dart';
import 'data/db/app_database.dart';
import 'data/db/daos.dart';
import 'nav2.dart';

void main() {
  final db = AppDatabase();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PatientData()),
        Provider(create: (_) => db.visitsDao),
        Provider(create: (_) => db.patientProfilesDao),
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
      title: 'Hospital App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const Nav2Page(visitId: 1),
    );
  }
}
