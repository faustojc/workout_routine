import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_routine/backend/powersync.dart';
import 'package:workout_routine/routes.dart';
import 'package:workout_routine/services/auth_state_provider.dart';
import 'package:workout_routine/services/connectivity_service.dart';
import 'package:workout_routine/themes/colors.dart';
import 'package:workout_routine/widgets/components/splash_screen_loading.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await openDatabase();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => ConnectivityService()),
      ChangeNotifierProvider(create: (_) => AuthStateProvider()),
    ],
    child: const MainApp(),
  ));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  // Root of the application
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Strength and Conditioning',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: ThemeColor.primary),
          checkboxTheme: CheckboxThemeData(
            side: const BorderSide(color: ThemeColor.white, width: 2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
              side: const BorderSide(color: ThemeColor.white, width: 2),
            ),
          ),
          useMaterial3: true,
        ),
        onGenerateRoute: Routes.generateRoute,
        debugShowCheckedModeBanner: false,
        home: const SplashScreenLoading(),
      );
}
