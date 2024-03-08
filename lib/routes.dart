import 'package:flutter/material.dart';
import 'package:workout_routine/widgets/admin/dashboard.dart';
import 'package:workout_routine/widgets/auth/login.dart';
import 'package:workout_routine/widgets/auth/register.dart';
import 'package:workout_routine/widgets/user/home.dart';
import 'package:workout_routine/widgets/user/personal_records/pr_home.dart';
import 'package:workout_routine/widgets/user/profile/measure_units.dart';
import 'package:workout_routine/widgets/user/profile/personal_details.dart';
import 'package:workout_routine/widgets/workouts/periodization_page.dart';
import 'package:workout_routine/widgets/workouts/start_workout_page.dart';
import 'package:workout_routine/widgets/workouts/workout_page.dart';
import 'package:workout_routine/widgets/workouts/workout_type_page.dart';

enum RouteList {
  home,
  login,
  register,
  personalDetails,
  editPersonalDetails,
  startWorkout,
  workout_type,
  periodization,
  workouts,
  personalRecord,
  measureUnits,
  dashboard,
}

extension RouteListExtension on RouteList {
  String get name {
    switch (this) {
      case RouteList.home:
        return '/home';
      case RouteList.login:
        return '/login';
      case RouteList.register:
        return '/register';
      case RouteList.personalDetails:
        return '/personal_details';
      case RouteList.editPersonalDetails:
        return '/edit_personal_details';
      case RouteList.startWorkout:
        return '/start_workout';
      case RouteList.periodization:
        return '/periodization';
      case RouteList.workouts:
        return '/workouts';
      case RouteList.workout_type:
        return 'workout_type';
      case RouteList.personalRecord:
        return '/personal_record';
      case RouteList.measureUnits:
        return '/measure_units';
      case RouteList.dashboard:
        return '/dashboard';
    }
  }
}

class Routes {
  // List of routes
  static final Map<RouteList, WidgetBuilder> _routes = {
    RouteList.home: (_) => const Home(),
    RouteList.login: (_) => const Login(),
    RouteList.register: (_) => const Register(),
    RouteList.startWorkout: (_) => const StartWorkoutPage(),
    RouteList.periodization: (_) => const PeriodizationPage(),
    RouteList.workouts: (_) => const WorkoutPage(),
    RouteList.workout_type: (_) => const WorkoutTypePage(),
    RouteList.personalRecord: (_) => const PRHome(),
    RouteList.measureUnits: (_) => const MeasureUnits(),
    RouteList.personalDetails: (_) => const PersonalDetails(),
    RouteList.dashboard: (_) => const Dashboard(),
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

  static void to(BuildContext context, RouteList routeName, {String? direction}) {
    Route route = PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => _routes[routeName]!(context),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = const Offset(0.0, 1.0);
        var end = Offset.zero;
        var curve = Curves.easeInOut;

        if (direction == 'right') {
          begin = const Offset(1.0, 0.0);
          end = Offset.zero;
        } else if (direction == 'left') {
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
    Navigator.of(context).pushNamedAndRemoveUntil(routeName.name, (route) => route.isCurrent && (route.settings.name == routeName.name));
  }

  static void back(BuildContext context) {
    Navigator.of(context).pop();
  }

  static void popAndTo(BuildContext context, RouteList routeName) {
    Navigator.of(context).popAndPushNamed(routeName.name);
  }
}
