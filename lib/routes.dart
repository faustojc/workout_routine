import 'package:flutter/material.dart';
import 'package:workout_routine/widgets/auth/main_auth.dart';
import 'package:workout_routine/widgets/user/edit_profile.dart';
import 'package:workout_routine/widgets/user/home.dart';
import 'package:workout_routine/widgets/user/profile.dart';

enum RouteList {
  home,
  auth,
  profile,
  editProfile,
}

extension RouteListExtension on RouteList {
  String get name {
    switch (this) {
      case RouteList.home:
        return '/home';
      case RouteList.auth:
        return '/auth';
      case RouteList.profile:
        return '/profile';
      case RouteList.editProfile:
        return '/edit_profile';
    }
  }
}

class Routes {
  // List of routes
  static final Map<RouteList, WidgetBuilder> _routes = {
    RouteList.home: (_) => const Home(),
    RouteList.auth: (_) => const MainAuth(),
    RouteList.profile: (_) => const Profile(),
    RouteList.editProfile: (_) => const EditProfile(),
  };

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final routeName = settings.name;
    final routeBuilder = _routes[RouteList.values.firstWhere((e) => e.name == routeName)];

    if (routeBuilder != null) {
      return MaterialPageRoute<dynamic>(builder: routeBuilder, settings: settings);
    }

    return MaterialPageRoute<dynamic>(
      builder: (_) => Scaffold(
        body: Center(
          child: Text('No route defined for $routeName'),
        ),
      ),
    );
  }

  static void to(BuildContext context, RouteList routeName, String direction) {
    Route route = PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => _routes[routeName]!(context),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = const Offset(0.0, 1.0);
        var end = Offset.zero;
        var curve = Curves.easeInOut;

        if (direction == 'left') {
          begin = const Offset(1.0, 0.0);
          end = Offset.zero;
        } else if (direction == 'right') {
          begin = const Offset(-1.0, 0.0);
          end = Offset.zero;
        }

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(position: animation.drive(tween), child: child);
      },
    );

    Navigator.of(context).push(route);
  }

  static void redirectTo(BuildContext context, RouteList routeName) {
    Route route = PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => _routes[routeName]!(context),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = const Offset(0.0, 1.0);
        var end = Offset.zero;
        var curve = Curves.easeInOut;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(position: animation.drive(tween), child: child);
      },
    );

    Navigator.of(context).pushAndRemoveUntil(route, (route) => route.isCurrent && (route.settings.name == routeName.name));
  }

  static void back(BuildContext context) {
    Navigator.of(context).pop();
  }
}
