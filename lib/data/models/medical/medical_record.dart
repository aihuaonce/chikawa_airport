import 'package:flutter/material.dart';

class MedicalRecord {
  final String date;
  final String time;
  final String patient;
  final String meta;
  final String avatar;
  final Color avatarColor;
  final String flight;
  final String location;
  final String complaint;
  final String status;
  final Color statusColor;

  MedicalRecord({
    required this.date,
    required this.time,
    required this.patient,
    required this.meta,
    required this.avatar,
    required this.avatarColor,
    required this.flight,
    required this.location,
    required this.complaint,
    required this.status,
    required this.statusColor,
  });
}

final demoRecords = [
  MedicalRecord(
    date: 'Oct 24, 2023',
    time: '14:20 PM',
    patient: 'Alexander Mitchell',
    meta: 'M / 42y · ID: H29384',
    avatar: 'AM',
    avatarColor: Colors.blue.shade100,
    flight: 'CX 881',
    location: 'Gate A14',
    complaint: 'Acute abdominal pain, nausea, cold sweats',
    status: 'PENDING',
    statusColor: Colors.orange,
  ),
];
