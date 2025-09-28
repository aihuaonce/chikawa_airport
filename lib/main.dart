import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/models/patient_data.dart';
import 'data/models/accident_data.dart';
import 'data/models/flightlog_data.dart';
import 'data/db/app_database.dart';
import 'home.dart';

void main() {
  final db = AppDatabase();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PatientData()),
        ChangeNotifierProvider(create: (_) => FlightLogData()),
        ChangeNotifierProvider(create: (_) => AccidentData()),
        Provider(create: (_) => db),
        Provider(create: (_) => db.visitsDao),
        Provider(create: (_) => db.patientProfilesDao),
        Provider(create: (_) => db.flightLogsDao),
        Provider(create: (_) => db.accidentRecordsDao),
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
      home: const HomePage(),
    );
  }
}
