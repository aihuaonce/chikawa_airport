import 'package:chikawa_airport/data/db/daos.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'providers/locale_provider.dart';
import 'l10n/app_translations.dart';

// Providers
import 'providers/app_navigation_provider.dart';
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
import 'data/models/referral_data.dart';

// Database & UI
import 'data/db/app_database.dart';
import 'main_page.dart';
import '../data/db/sync_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final db = AppDatabase();

  // ✅ 確保資料庫開啟
  await db.customSelect('SELECT 1').get();

  // ✅ 啟動同步排程
  final syncService = SyncService(db);
  syncService.start();

  final localeProvider = LocaleProvider();
  await localeProvider.loadLocale();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: localeProvider),
        ChangeNotifierProvider(create: (_) => AppNavigationProvider()),
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
        ChangeNotifierProvider(create: (_) => ReferralData()),

        Provider<AppDatabase>.value(value: db),
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
        Provider<ReferralFormsDao>(create: (_) => db.referralFormsDao),
        Provider<AmbulanceRecordsDao>(create: (_) => db.ambulanceRecordsDao),
        Provider<MedicationRecordsDao>(create: (_) => db.medicationRecordsDao),
        Provider<VitalSignsRecordsDao>(create: (_) => db.vitalSignsRecordsDao),
        Provider<ParamedicRecordsDao>(create: (_) => db.paramedicRecordsDao),
        Provider<EmergencyRecordsDao>(create: (_) => db.emergencyRecordsDao),
      ],
      child: const MyApp(),
    ),
  );
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final localeProvider = context.watch<LocaleProvider>();
    return MaterialApp(
      onGenerateTitle: (context) => AppTranslations.of(context).appTitle,

      locale: localeProvider.locale,
      localizationsDelegates: const [
        AppTranslations.delegate, // 你的自定義翻譯
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('zh', 'TW'), // 繁體中文
        Locale('en', 'US'), // 英文
      ],

      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MainPage(),
      debugShowCheckedModeBanner: false, // 建議加入此行以移除右上角的 Debug 標籤
    );
  }
}
