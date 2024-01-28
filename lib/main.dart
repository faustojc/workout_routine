import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:workout_routine/backend/powersync.dart';
import 'package:workout_routine/data/client.dart';
import 'package:workout_routine/routes.dart';
import 'package:workout_routine/services/connectivity_service.dart';
import 'package:workout_routine/themes/colors.dart';
import 'package:workout_routine/widgets/auth/main_auth.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PowerSyncConnector.instance.openDatabase().then((value) => supabase = Supabase.instance.client);

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ConnectivityService>(
      create: (context) => ConnectivityService(),
      child: MaterialApp(
        title: 'Strength and Conditioning',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: ThemeColor.primary),
          fontFamily: 'SpaceGrotesk',
          useMaterial3: true,
        ),
        onGenerateRoute: Routes.generateRoute,
        debugShowCheckedModeBanner: false,
        home: const MainAuth(),
      ),
    );
  }
}
