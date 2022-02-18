import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/services.dart';

typedef updateConnectionStatus<T> = Future<void> Function(T value);

class ConnectivityProvider with ChangeNotifier, DiagnosticableTreeMixin {
  String _connectionStatus = 'Unknown';
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  StreamSubscription<ConnectivityResult> get connectivitySubscription =>
      _connectivitySubscription;
  Connectivity get connectivity => _connectivity;
  String get connectionStatus => _connectionStatus;

  Future<void> initConnectivity(
      bool mounted, updateConnectionStatus update) async {
    ConnectivityResult result = ConnectivityResult.none;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
    }

    if (!mounted) {
      return Future.value(null);
    }

    return update(result);
  }
}
