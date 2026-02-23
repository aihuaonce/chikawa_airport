import 'dart:convert';
import 'package:flutter/services.dart';
import '../sync/models/sync_models.dart';

class ApiClient {
  final String baseUrl;
  String? _accessToken;
  bool _useMock = true;

  ApiClient({this.baseUrl = 'https://api.airport-medical.example.com/v1'});

  void setAccessToken(String token) {
    _accessToken = token;
  }

  void setMockMode(bool mock) {
    _useMock = mock;
  }

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    if (_accessToken != null) 'Authorization': 'Bearer $_accessToken',
  };

  Future<PullResponse> pullChanges(PullRequest request) async {
    if (_useMock) {
      return _mockPullChanges(request);
    }
    // TODO: Implement real API call
    throw UnimplementedError('Real API not implemented yet');
  }

  Future<PushResponse> pushChanges(PushRequest request) async {
    if (_useMock) {
      return _mockPushChanges(request);
    }
    // TODO: Implement real API call
    throw UnimplementedError('Real API not implemented yet');
  }

  Future<PullResponse> _mockPullChanges(PullRequest request) async {
    await Future.delayed(const Duration(milliseconds: 500));
     
    try {
      final jsonString = await rootBundle.loadString('assets/mock_api/pull_response.json');
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return PullResponse.fromJson(json);
    } catch (e) {
      return PullResponse(
        serverTimestamp: DateTime.now().toUtc(),
        changes: [],
        deletedRecords: [],
      );
    }
  }

  Future<PushResponse> _mockPushChanges(PushRequest request) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    final results = request.changes.map((change) => PushResult(
      localId: change.localId,
      remoteId: '${change.table}-remote-${change.localId}',
      status: 'success',
    )).toList();

    return PushResponse(
      serverTimestamp: DateTime.now().toUtc(),
      results: results,
      conflicts: [],
    );
  }

  Future<Map<String, dynamic>> login(String username, String password, String stationCode) async {
    if (_useMock) {
      return _mockLogin(username, password, stationCode);
    }
    throw UnimplementedError('Real API not implemented yet');
  }

  Future<Map<String, dynamic>> _mockLogin(String username, String password, String stationCode) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    return {
      'accessToken': 'mock_access_token_${DateTime.now().millisecondsSinceEpoch}',
      'refreshToken': 'mock_refresh_token_${DateTime.now().millisecondsSinceEpoch}',
      'expiresIn': 3600,
      'user': {
        'id': 1,
        'username': username,
        'name': 'Mock User',
        'role': 'doctor',
        'stationCode': stationCode,
        'permissions': ['medical_record:read', 'medical_record:write'],
      },
    };
  }

  Future<void> logout() async {
    if (_useMock) {
      await Future.delayed(const Duration(milliseconds: 200));
      _accessToken = null;
      return;
    }
    throw UnimplementedError('Real API not implemented yet');
  }

  Future<Map<String, dynamic>> refreshToken(String refreshToken) async {
    if (_useMock) {
      await Future.delayed(const Duration(milliseconds: 200));
      return {
        'accessToken': 'mock_access_token_${DateTime.now().millisecondsSinceEpoch}',
        'expiresIn': 3600,
      };
    }
    throw UnimplementedError('Real API not implemented yet');
  }

  Future<List<Map<String, dynamic>>> getReferences() async {
    if (_useMock) {
      return _mockGetReferences();
    }
    throw UnimplementedError('Real API not implemented yet');
  }

  Future<List<Map<String, dynamic>>> _mockGetReferences() async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    return [
      {'id': 1, 'code': 'M', 'name': '男'},
      {'id': 2, 'code': 'F', 'name': '女'},
    ];
  }
}
