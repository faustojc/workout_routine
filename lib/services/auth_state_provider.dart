import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uni_links/uni_links.dart';

class AuthStateProvider extends ChangeNotifier {
  late User? authUser;
  late Session? authSession;
  late StreamSubscription<Uri?> _authStateSub;
  late String? errorMessage;
  late Uri? currUri;
  bool hasError = false;

  AuthStateProvider() {
    _authStateSub = uriLinkStream.listen((uri) {
      currUri = uri;

      if (uri != null) {
        _verificationEmailSent(uri);
        hasError = false;
      }
    }, onError: (e) {
      errorMessage = e.toString();
      hasError = true;
      notifyListeners();
    });
  }

  void _verificationEmailSent(Uri uri) {
    final currSession = Session.fromJson(uri.queryParameters);

    authUser = currSession!.user;
    authSession = currSession;

    notifyListeners();
  }

  @override
  void dispose() {
    _authStateSub.cancel();
    super.dispose();
  }
}
