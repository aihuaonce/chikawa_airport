import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();
  factory FirebaseService() => _instance;
  FirebaseService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  FirebaseFirestore get firestore => _firestore;
  FirebaseAuth get auth => _auth;

  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;

    _firestore.settings = const Settings(persistenceEnabled: true);

    _initialized = true;
    debugPrint('FirebaseService initialized');
  }

  Future<void> signInAnonymously() async {
    try {
      await _auth.signInAnonymously();
      debugPrint('Signed in anonymously');
    } catch (e) {
      debugPrint('Anonymous sign-in failed: $e');
    }
  }

  String? get currentUserId => _auth.currentUser?.uid;

  CollectionReference<Map<String, dynamic>> collection(String path) =>
      _firestore.collection(path);

  /// 取得 Firestore Collection 的 QuerySnapshot
  Future<QuerySnapshot<Map<String, dynamic>>> getCollectionSnapshot(
    String path,
  ) async {
    final snapshot = await _firestore.collection(path).get();
    return snapshot;
  }

  Future<void> setDocument(
    String collectionPath,
    String docId,
    Map<String, dynamic> data,
  ) async {
    await _firestore
        .collection(collectionPath)
        .doc(docId)
        .set(data, SetOptions(merge: true));
  }

  Future<Map<String, dynamic>?> getDocument(
    String collectionPath,
    String docId,
  ) async {
    final doc = await _firestore.collection(collectionPath).doc(docId).get();
    return doc.data();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> watchDocument(
    String collectionPath,
    String docId,
  ) {
    return _firestore.collection(collectionPath).doc(docId).snapshots();
  }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> queryDocuments(
    String collectionPath, {
    String? whereField,
    dynamic whereEqualTo,
    int? limit,
  }) async {
    Query<Map<String, dynamic>> query = _firestore.collection(collectionPath);

    if (whereField != null && whereEqualTo != null) {
      query = query.where(whereField, isEqualTo: whereEqualTo);
    }

    if (limit != null) {
      query = query.limit(limit);
    }

    final snapshot = await query.get();
    return snapshot.docs;
  }

  Future<void> batchWrite(Map<String, Map<String, dynamic>> records) async {
    WriteBatch batch = _firestore.batch();

    for (var entry in records.entries) {
      final parts = entry.key.split('/');
      if (parts.length == 2) {
        batch.set(
          _firestore.collection(parts[0]).doc(parts[1]),
          entry.value,
          SetOptions(merge: true),
        );
      }
    }

    await batch.commit();
  }
}
