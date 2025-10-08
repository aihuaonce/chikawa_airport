import '../db/app_database.dart';

class DetailedAmbulanceViewData {
  final AmbulanceRecord record;
  final Visit visit;
  final Treatment? treatment;

  DetailedAmbulanceViewData({
    required this.record,
    required this.visit,
    this.treatment,
  });
}
