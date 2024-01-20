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
              drawer: Drawer(
                backgroundColor: ThemeColor.primary,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Close button
                    Padding(
                      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top - 10),
                      child: IconButton(
                        onPressed: () => Routes.back(context),
                        icon: const Icon(
                          Icons.close,
                          color: ThemeColor.white,
                        ),
                      ),
                    ),
                    // Drawer Header
                    Padding(
                      padding: const EdgeInsets.only(left: 30, right: 30, bottom: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            backgroundColor: ThemeColor.white,
                            radius: 40,
                            child: Text(
                              AthleteModel.current!.firstName.characters.first + AthleteModel.current!.lastName.characters.first,
                              style: const TextStyle(
                                color: ThemeColor.secondary,
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            '${AthleteModel.current!.firstName} ${AthleteModel.current!.lastName}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            user.email.toString(),
                            style: const TextStyle(
                              color: ThemeColor.tertiary,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(Radius.circular(26)),
                              color: SubscriptionModel.current!.isSubscribed ? Colors.green : Colors.grey.shade600,
                            ),
                            child: Text(
                              SubscriptionModel.current!.isSubscribed ? 'Subscribed' : 'Not Subscribed',
                              style: const TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          )
                        ],
                      ),
                    ),
                    // Body
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        color: ThemeColor.tertiary,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              children: [
                                ListTile(
                                  leading: const Icon(Icons.person),
                                  title: const Text(
                                    'Profile',
                                    style: TextStyle(fontWeight: FontWeight.w700),
                                  ),
                                  onTap: () => Routes.to(context, RouteList.profile, 'right'),
                                ),
                                ListTile(
                                  leading: const Icon(Icons.notifications),
                                  title: const Text(
                                    'Notifications',
                                    style: TextStyle(fontWeight: FontWeight.w700),
                                  ),
                                  onTap: () {},
                                ),
                                ListTile(
                                  leading: const Icon(Icons.info),
                                  title: const Text(
                                    'Terms & Conditions',
                                    style: TextStyle(fontWeight: FontWeight.w700),
                                  ),
                                  onTap: () {},
                                ),
                                ListTile(
                                  leading: const Icon(Icons.settings),
                                  title: const Text(
                                    'Settings',
                                    style: TextStyle(fontWeight: FontWeight.w700),
                                  ),
                                  onTap: () {},
                                ),
                              ],
                            ),
                            ListTile(
                              leading: const Icon(Icons.logout),
                              title: const Text(
                                'Logout',
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ),
                              onTap: () {
                                supabase.auth.signOut().then((value) => Routes.redirectTo(context, RouteList.auth));
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Footer
                    const Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        '© 2024 Fausto John Claire Boko &  Cherry Angela Rodriguez. All Rights Reserved.',
                        textScaler: TextScaler.linear(0.8),
                        style: TextStyle(
                          color: ThemeColor.tertiary,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              body: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [ThemeColor.primary, ThemeColor.secondary],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Padding(
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
                              IconButton(onPressed: () {}, icon: const Icon(Icons.more_horiz, color: ThemeColor.white))
                            ],
                          ),
                          const SizedBox(height: 5),
                          const PersonalRecordsGrid(),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () => Routes.to(context, RouteList.workout, 'right'),
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
                      ),
                    ),
                  )),
            );
          }
        }

        return const Loading();
      },
    );
  }
}
