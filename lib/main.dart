import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:workout_routine/data/user.dart';
import 'package:workout_routine/routes.dart';
import 'package:workout_routine/themes/colors.dart';
import 'package:workout_routine/widgets/auth/main_auth.dart';
import 'package:workout_routine/widgets/components/loading.dart';
import 'package:workout_routine/widgets/dashboard/user/dashboard.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Supabase.initialize(
    url: 'https://fubkrstvdjgoytlbqjax.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ1Ymtyc3R2ZGpnb3l0bGJxamF4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDUxMjk1NzAsImV4cCI6MjAyMDcwNTU3MH0.NbDk02y0NwZoQmYUE2Qna9fDnO-R66aaG9tZviDvAkE',
  );

  supabase = Supabase.instance.client;

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
      home: StreamBuilder<AuthState?>(
        stream: supabase.auth.onAuthStateChange,
        builder: (BuildContext context, AsyncSnapshot<AuthState?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loading();
          } else {
            if (snapshot.data?.session != null) {
              session = snapshot.data!.session!;

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
