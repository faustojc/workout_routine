import 'package:flutter/material.dart';
import 'package:workout_routine/widgets/auth/main_auth.dart';
import 'package:workout_routine/widgets/dashboard/user/dashboard.dart';

class Routes {
  // List of routes
  static final Map<String, WidgetBuilder> _routes = {
    '/': (_) => const Dashboard(),
    '/auth': (_) => const MainAuth(),
  };

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final routeName = settings.name;
    final routeBuilder = _routes[routeName];

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

  static void to(BuildContext context, String routeName) {
    Navigator.of(context).pushNamed(routeName);
  }

  static void redirectTo(BuildContext context, String routeName) {
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

    Navigator.of(context).pushAndRemoveUntil(route, (route) => route.isCurrent && route.settings.name == routeName);
  }

  static void back(BuildContext context) {
    Navigator.of(context).pop();
  }
}
