import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class ConnectivityService extends ChangeNotifier {
  late StreamSubscription<ConnectivityResult> _result;
  late StreamSubscription<InternetStatus> _internetListener;

  InternetStatus status = InternetStatus.connected;

  ConnectivityService() {
    _result = Connectivity().onConnectivityChanged.listen(_updateConnectionStatus);
  }

  void _updateConnectionStatus(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.wifi:
      case ConnectivityResult.mobile:
        _internetListener = InternetConnection().onStatusChange.listen(
              (event) => status = (event == InternetStatus.connected) ? InternetStatus.connected : InternetStatus.disconnected,
            );
        break;
      case ConnectivityResult.none:
      default:
        status = InternetStatus.disconnected;
        break;
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _result.cancel();
    _internetListener.cancel();
    super.dispose();
  }
}
