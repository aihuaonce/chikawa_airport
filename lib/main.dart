// main.dart
import 'package:chikawa_airport/data/db/daos.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/models/patient_data.dart';
import 'data/models/accident_data.dart';
import 'data/models/flightlog_data.dart';
import 'data/models/plan_data.dart';
import 'data/models/medical_costs_data.dart';
import 'data/models/certificate_data.dart';
import 'data/models/undertaking_data.dart';
import 'data/models/electronic_document_data.dart';
import 'data/models/nursing_record_data.dart';
import 'data/models/body_map_data.dart';
import 'data/db/app_database.dart';
import 'home.dart';

void main() {
  final db = AppDatabase();

  runApp(
    MultiProvider(
      providers: [
        // ChangeNotifier
        ChangeNotifierProvider(create: (_) => PatientData()),
        ChangeNotifierProvider(create: (_) => FlightLogData()),
        ChangeNotifierProvider(create: (_) => AccidentData()),
        ChangeNotifierProvider(create: (_) => PlanData()),
        ChangeNotifierProvider(create: (_) => MedicalCostsData()),
        ChangeNotifierProvider(create: (_) => CertificateData()),
        ChangeNotifierProvider(create: (_) => UndertakingData()),
        ChangeNotifierProvider(create: (_) => ElectronicDocumentData()),
        ChangeNotifierProvider(create: (_) => NursingRecordData()),
        ChangeNotifierProvider(create: (_) => BodyMapData()),

        // Database instance
        Provider<AppDatabase>.value(value: db),

        // DAOs 注入，確保使用同一個 db
        Provider<VisitsDao>(create: (_) => db.visitsDao),
        Provider<PatientProfilesDao>(create: (_) => db.patientProfilesDao),
        Provider<FlightLogsDao>(create: (_) => db.flightLogsDao),
        Provider<AccidentRecordsDao>(create: (_) => db.accidentRecordsDao),
        Provider<TreatmentsDao>(create: (_) => db.treatmentsDao),
        Provider<MedicalCostsDao>(create: (_) => db.medicalCostsDao),
        Provider<MedicalCertificatesDao>(
          create: (_) => db.medicalCertificatesDao,
        ),
        Provider<UndertakingsDao>(create: (_) => db.undertakingsDao),
        Provider<ElectronicDocumentsDao>(
          create: (_) => db.electronicDocumentsDao,
        ),
        Provider<NursingRecordsDao>(create: (_) => db.nursingRecordsDao),
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