import 'dart:async';

import 'package:flutter/material.dart';
import 'package:workout_routine/data/user.dart';
import 'package:workout_routine/models/athletes.dart';
import 'package:workout_routine/models/personal_record.dart';
import 'package:workout_routine/models/subscription.dart';
import 'package:workout_routine/models/users.dart';
import 'package:workout_routine/routes.dart';
import 'package:workout_routine/themes/colors.dart';
import 'package:workout_routine/widgets/components/loading.dart';
import 'package:workout_routine/widgets/components/pr_carousel.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<Map<String, dynamic>?> _fetchUserData;

  @override
  void initState() {
    super.initState();

    user = session.user;

    _fetchUserData = _getUserData();
  }

  Future<Map<String, dynamic>?> _getUserData() async {
    String email = user.email ?? '';
    final data = await supabase.from('users').select('*, athletes(*), personal_records(*), subscriptions(*)').eq('email', email).single();

    if (data.isNotEmpty) {
      return data;
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _fetchUserData,
        builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loading();
          } else {
            UserModel.current = UserModel.fromJson(snapshot.data!);
            AthleteModel.current = AthleteModel.fromJson(snapshot.data!['athletes'][0]);
            PersonalRecordModel.list = PersonalRecordModel.fromJson(snapshot.data!['personal_records']);
            SubscriptionModel.current = SubscriptionModel.fromJson(snapshot.data!['subscriptions'][0]);

            return Scaffold(
              resizeToAvoidBottomInset: true,
              appBar: AppBar(
                backgroundColor: ThemeColor.primary,
                foregroundColor: ThemeColor.white,
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
                                  onTap: () => Routes.to(context, RouteList.home, 'left'),
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
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [ThemeColor.primary, ThemeColor.tertiary],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome! ${AthleteModel.current!.lastName}',
                            style: const TextStyle(
                              color: ThemeColor.tertiary,
                              fontSize: 22,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                              color: ThemeColor.white,
                            ),
                            child: Text(
                              AthleteModel.current!.firstName.characters.first + AthleteModel.current!.lastName.characters.first,
                              style: const TextStyle(
                                color: ThemeColor.secondary,
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Personal Record',
                                  style: TextStyle(color: ThemeColor.white, fontSize: 16, fontWeight: FontWeight.w500),
                                ),
                                OutlinedButton.icon(
                                  onPressed: () {},
                                  icon: const Icon(Icons.add, size: 15),
                                  label: const Text(
                                    'Add',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: ThemeColor.white,
                                    padding: const EdgeInsets.symmetric(horizontal: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    side: const BorderSide(color: ThemeColor.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxHeight: 300),
                        child: const PRCarousel(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ThemeColor.secondary,
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        'Start Workout',
                        style: TextStyle(
                          color: ThemeColor.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        });
  }
}
