import 'package:flutter/material.dart';
import 'package:workout_routine/data/user.dart';
import 'package:workout_routine/models/athlete.dart';
import 'package:workout_routine/models/personal_record.dart';
import 'package:workout_routine/models/personal_record_history.dart';
import 'package:workout_routine/models/subscription.dart';
import 'package:workout_routine/models/user_workouts.dart';
import 'package:workout_routine/models/users.dart';
import 'package:workout_routine/routes.dart';
import 'package:workout_routine/themes/colors.dart';
import 'package:workout_routine/widgets/components/drawer_nav.dart';
import 'package:workout_routine/widgets/components/loading.dart';
import 'package:workout_routine/widgets/components/personal_records_grid.dart';
import 'package:workout_routine/widgets/components/recent_workout.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Future<Map<String, dynamic>?> _fetchData;

  @override
  void initState() {
    super.initState();

    _fetchData = _getUserData();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  Future<Map<String, dynamic>?> _getUserData() async {
    final email = supabase.auth.currentUser!.email;

    final userData = await supabase
        .from('users') //
        .select('*, athletes(*), personal_records(*), subscriptions(*), personal_records_history(*), user_workouts(*)')
        .eq('email', email!)
        .single();

    if (userData.isNotEmpty) {
      return userData;
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _fetchData,
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            final data = snapshot.data!;

            UserModel.current = UserModel.fromJson(data);
            AthleteModel.current = AthleteModel.fromJson(data['athletes'][0]);
            SubscriptionModel.current = SubscriptionModel.fromJson(data['subscriptions'][0]);

            PersonalRecordModel.list = PersonalRecordModel.fromList(data['personal_records']);
            PRHistoryModel.list = PRHistoryModel.fromList(data['personal_records_history']);
            UserWorkoutModel.list = UserWorkoutModel.fromList(data['user_workouts']);

            return Scaffold(
              resizeToAvoidBottomInset: true,
              appBar: AppBar(
                backgroundColor: ThemeColor.primary,
                foregroundColor: ThemeColor.white,
                elevation: 0,
              ),
              drawer: const DrawerNav(),
              body: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [ThemeColor.primary, ThemeColor.secondary],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: SingleChildScrollView(
                      padding: const EdgeInsets.only(right: 15, left: 15, bottom: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ListTile(
                            title: const Text(
                              'WELCOME,',
                              style: TextStyle(color: ThemeColor.tertiary, fontSize: 12),
                            ),
                            subtitle: Text(
                              AthleteModel.current!.firstName.toUpperCase(),
                              style: const TextStyle(
                                color: ThemeColor.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.8,
                              ),
                            ),
                            trailing: CircleAvatar(
                              backgroundColor: ThemeColor.white,
                              child: Text(
                                AthleteModel.current!.firstName.characters.first + AthleteModel.current!.lastName.characters.first,
                                style: const TextStyle(
                                  color: ThemeColor.secondary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          const RecentWorkout(),
                          const SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'PERSONAL RECORDS',
                                style: TextStyle(
                                  color: ThemeColor.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              IconButton(
                                onPressed: () => Routes.to(context, RouteList.personal_record, 'right'),
                                icon: const Icon(Icons.more_horiz, color: ThemeColor.white),
                              )
                            ],
                          ),
                          const SizedBox(height: 5),
                          const PersonalRecordsGrid(),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () => Routes.to(context, RouteList.startWorkout, 'right'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ThemeColor.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 15),
                            ),
                            child: const Text(
                              'Start Workout',
                              textScaler: TextScaler.linear(1.2),
                              style: TextStyle(color: ThemeColor.white),
                            ),
                          ),
                        ],
                      ))),
            );
          }
        }

        return const Loading();
      },
    );
  }
}
