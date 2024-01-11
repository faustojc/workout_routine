import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:workout_routine/routes.dart';
import 'package:workout_routine/themes/colors.dart';
import 'package:workout_routine/widgets/auth/main_auth.dart';
import 'package:workout_routine/widgets/components/loading.dart';
import 'package:workout_routine/widgets/dashboard/user/dashboard.dart';

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
    return MaterialApp(
      title: 'Workout Routine',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: ThemeColor.primary),
        fontFamily: 'SpaceGrotesk',
        useMaterial3: true,
      ),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loading();
          } else {
            if (snapshot.hasData) {
              return const Dashboard();
            } else {
              return const MainAuth();
            }
          }
        },
      ),
      onGenerateRoute: Routes.generateRoute,
      debugShowCheckedModeBanner: false,
    );
  }
}
