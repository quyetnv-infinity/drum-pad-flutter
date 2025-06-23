import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';

class NetworkProvider with ChangeNotifier {
  bool _isConnected = true;
  bool get isConnected => _isConnected;

  StreamSubscription<List<ConnectivityResult>>? _subscription;

  NetworkProvider() {
    _init();
  }

  void _init() async {
    List<ConnectivityResult> results = await Connectivity().checkConnectivity();
    _isConnected = !(results.isEmpty || results.contains(ConnectivityResult.none));
    notifyListeners();
    _subscription = Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> results) {
      bool newStatus = !(results.isEmpty || results.contains(ConnectivityResult.none));
      if (newStatus != _isConnected) {
        _isConnected = newStatus;
        print('change $newStatus');
        notifyListeners();
      }
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}