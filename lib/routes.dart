import 'package:flutter/material.dart';
import 'package:workout_routine/widgets/auth/login.dart';
import 'package:workout_routine/widgets/auth/register.dart';
import 'package:workout_routine/widgets/dashboard.dart';

class Routes {
  static String get initialRoute => '/login';

  // List of routes
  static final Map<String, WidgetBuilder> _routes = {
    '/login': (_) => const LoginForm(),
    '/register': (_) => const RegisterForm(),
    '/dashboard': (_) => const Dashboard(),
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

  static void back(BuildContext context) {
    Navigator.of(context).pop();
  }
}
