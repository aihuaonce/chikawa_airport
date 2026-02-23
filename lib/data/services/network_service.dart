import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';

class NetworkService extends ChangeNotifier {
  bool _isOnline = true;
  final _connectivityController = StreamController<bool>.broadcast();
  Timer? _periodicCheckTimer;

  bool get isOnline => _isOnline;
  Stream<bool> get onConnectivityChanged => _connectivityController.stream;

  Future<void> initialize() async {
    await checkConnectivity();
    _startPeriodicCheck();
  }

  void _startPeriodicCheck() {
    _periodicCheckTimer?.cancel();
    _periodicCheckTimer = Timer.periodic(
      const Duration(seconds: 30),
      (_) => checkConnectivity(),
    );
  }

  Future<bool> checkConnectivity() async {
    try {
      final result = await InternetAddress.lookup('google.com')
          .timeout(const Duration(seconds: 5));
      final wasOnline = _isOnline;
      _isOnline = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
      
      if (wasOnline != _isOnline) {
        notifyListeners();
        _connectivityController.add(_isOnline);
      }
      return _isOnline;
    } catch (e) {
      final wasOnline = _isOnline;
      _isOnline = false;
      if (wasOnline != _isOnline) {
        notifyListeners();
        _connectivityController.add(_isOnline);
      }
      return false;
    }
  }

  void setOnlineStatus(bool status) {
    if (_isOnline != status) {
      _isOnline = status;
      notifyListeners();
      _connectivityController.add(_isOnline);
    }
  }

  @override
  void dispose() {
    _periodicCheckTimer?.cancel();
    _connectivityController.close();
    super.dispose();
  }
}
