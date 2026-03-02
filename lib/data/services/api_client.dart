import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import '../sync/models/sync_models.dart';

class ApiClient {
  final String baseUrl;
  String? _accessToken;
  late final Dio _dio;
  bool _useMock = false; // Set to false for production

  ApiClient({
    this.baseUrl =
        'https://da90-2001-b400-e2c2-9519-a047-5561-8fc2-3bba.ngrok-free.app',
  }) {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {'Content-Type': 'application/json'},
      ),
    );
  }

  void setBaseUrl(String url) {
    _dio.options.baseUrl = url;
  }

  void setAccessToken(String token) {
    _accessToken = token;
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  void setMockMode(bool mock) {
    _useMock = mock;
  }

  // ============ Compare-first sync ============

  Future<CompareResponse> compareSnapshot(CompareRequest request) async {
    if (_useMock) {
      return _mockCompareSnapshot(request);
    }

    try {
      final response = await _dio.post(
        '/api/sync/compare',
        data: request.toJson(),
      );

      return CompareResponse.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw Exception('Failed to compare snapshot: ${e.message}');
    }
  }

  Future<CompareResponse> _mockCompareSnapshot(CompareRequest request) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return CompareResponse(
      serverTimestamp: DateTime.now().toUtc(),
      toDownload: [],
      toUpload: [],
      conflicts: [],
    );
  }

  Future<PullResponse> pullChanges(PullRequest request) async {
    if (_useMock) {
      return _mockPullChanges(request);
    }

    try {
      final response = await _dio.post(
        '/api/sync/pull',
        data: {
          'since': request.since?.toUtc().toIso8601String(),
          'tables': request.tables,
          'deviceId': request.deviceId,
        },
      );

      return PullResponse.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw Exception('Failed to pull changes: ${e.message}');
    }
  }

  Future<PushResponse> pushChanges(PushRequest request) async {
    if (_useMock) {
      return _mockPushChanges(request);
    }

    try {
      final response = await _dio.post(
        '/api/sync/push',
        data: {
          'clientTimestamp': request.clientTimestamp.toIso8601String(),
          'deviceId': request.deviceId,
          'changes': request.changes
              .map(
                (c) => {
                  'table': c.table,
                  'localId': c.localId,
                  'operation': c.operation,
                  'data': c.data,
                  if (c.remoteId != null) 'remoteId': c.remoteId,
                },
              )
              .toList(),
        },
      );

      return PushResponse.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw Exception('Failed to push changes: ${e.message}');
    }
  }

  Future<PullResponse> _mockPullChanges(PullRequest request) async {
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      final jsonString = await rootBundle.loadString(
        'assets/mock_api/pull_response.json',
      );
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

    final results = request.changes
        .map(
          (change) => PushResult(
            table: change.table,
            localId: change.localId,
            remoteId: '${change.table}-remote-${change.localId}',
            status: 'success',
          ),
        )
        .toList();

    return PushResponse(
      serverTimestamp: DateTime.now().toUtc(),
      results: results,
      conflicts: [],
    );
  }

  Future<Map<String, dynamic>> login(
    String username,
    String password,
    String stationCode,
  ) async {
    if (_useMock) {
      return _mockLogin(username, password, stationCode);
    }

    try {
      final response = await _dio.post(
        '/api/auth/login',
        data: {
          'username': username,
          'password': password,
          'stationCode': stationCode,
        },
      );

      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw Exception('Login failed: ${e.message}');
    }
  }

  Future<Map<String, dynamic>> _mockLogin(
    String username,
    String password,
    String stationCode,
  ) async {
    await Future.delayed(const Duration(milliseconds: 300));

    return {
      'accessToken':
          'mock_access_token_${DateTime.now().millisecondsSinceEpoch}',
      'refreshToken':
          'mock_refresh_token_${DateTime.now().millisecondsSinceEpoch}',
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

    try {
      await _dio.post('/api/auth/logout');
      _accessToken = null;
    } on DioException catch (e) {
      throw Exception('Logout failed: ${e.message}');
    }
  }

  Future<Map<String, dynamic>> refreshToken(String refreshToken) async {
    if (_useMock) {
      await Future.delayed(const Duration(milliseconds: 200));
      return {
        'accessToken':
            'mock_access_token_${DateTime.now().millisecondsSinceEpoch}',
        'expiresIn': 3600,
      };
    }

    try {
      final response = await _dio.post(
        '/api/auth/refresh',
        data: {'refreshToken': refreshToken},
      );

      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw Exception('Token refresh failed: ${e.message}');
    }
  }

  Future<List<Map<String, dynamic>>> getReferences() async {
    if (_useMock) {
      return _mockGetReferences();
    }

    try {
      final response = await _dio.get('/api/references');
      return (response.data as List).cast<Map<String, dynamic>>();
    } on DioException catch (e) {
      throw Exception('Failed to get references: ${e.message}');
    }
  }

  Future<List<Map<String, dynamic>>> _mockGetReferences() async {
    await Future.delayed(const Duration(milliseconds: 300));

    return [
      {'id': 1, 'code': 'M', 'name': '男'},
      {'id': 2, 'code': 'F', 'name': '女'},
    ];
  }
}
