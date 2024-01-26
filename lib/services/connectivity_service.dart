import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

enum InternetStatus { online, offline }

class ConnectivityService extends ChangeNotifier {
  late StreamSubscription<ConnectivityResult> _result;
  InternetStatus status = InternetStatus.offline;

  ConnectivityService() {
    _result = Connectivity().onConnectivityChanged.listen(_updateConnectionStatus);
  }

  void _updateConnectionStatus(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.wifi:
      case ConnectivityResult.mobile:
        status = await InternetConnection().hasInternetAccess ? InternetStatus.online : InternetStatus.offline;
        break;
      case ConnectivityResult.none:
      default:
        status = InternetStatus.offline;
        break;
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _result.cancel();
    super.dispose();
  }
}
