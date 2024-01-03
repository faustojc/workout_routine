import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:workout_routine/routes.dart';
import 'package:workout_routine/themes/colors.dart';
import 'package:workout_routine/widgets/auth/main_auth.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    print("Routes: ${Navigator.of(context)}");

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) {
          return;
        }

        final navigator = Navigator.of(context);

        if (navigator.canPop()) {
          navigator.popUntil(ModalRoute.withName("/dashboard"));
        } else {
          SystemNavigator.pop();
        }
      },
      child: MaterialApp(
        title: 'Workout Routine',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: ThemeColor.primary),
          fontFamily: 'SpaceGrotesk',
          useMaterial3: true,
        ),
        home: const MainAuth(),
        initialRoute: FirebaseAuth.instance.currentUser != null ? '/dashboard' : '/auth',
        onGenerateRoute: Routes.generateRoute,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
