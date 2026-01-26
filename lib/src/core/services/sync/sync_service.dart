import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

class SyncService {
  static final SyncService _instance = SyncService._internal();
  factory SyncService() => _instance;
  SyncService._internal();

  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  void init() {
    _subscription = _connectivity.onConnectivityChanged.listen((results) {
        if (results.any((result) => result != ConnectivityResult.none)) {
             _onOnline();
        }
    });
  }

  void _onOnline() {
    debugPrint("App is online. Triggering sync...");
    // TODO: Implement actual sync logic here
  }

  void dispose() {
    _subscription?.cancel();
  }
}
