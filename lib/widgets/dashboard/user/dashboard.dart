import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:workout_routine/models/athletes.dart';
import 'package:workout_routine/models/personal_record.dart';
import 'package:workout_routine/models/subscription.dart';
import 'package:workout_routine/routes.dart';
import 'package:workout_routine/themes/colors.dart';
import 'package:workout_routine/widgets/components/loading.dart';
import 'package:workout_routine/widgets/components/pr_carousel.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late Future<Athlete?> _fetchAthleteData;
  late Future<Subscription?> _fetchSubscription;
  late Future<List<PersonalRecord>?> _fetchPR;

  @override
  void initState() {
    super.initState();
    _fetchAthleteData = _getAthleteData();
    _fetchSubscription = _getSubscriptionData();
    _fetchPR = _getPRData();
  }

  Future<Athlete?> _getAthleteData() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance.collection('athletes').where('userId', isEqualTo: user.uid).get();

      if (querySnapshot.docs.isNotEmpty) {
        return Athlete.fromFirestoreQuery(querySnapshot);
      }
    }
    return null;
  }

  Future<Subscription?> _getSubscriptionData() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance.collection('subscriptions').where('userId', isEqualTo: user.uid).get();

      if (querySnapshot.docs.isNotEmpty) {
        return Subscription.fromFirestoreQuery(querySnapshot);
      }
    }

    return null;
  }

  Future<List<PersonalRecord>?> _getPRData() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance.collection('personal_records').where('userId', isEqualTo: user.uid).get();

      if (querySnapshot.docs.isNotEmpty) {
        return PersonalRecord.fromFirestoreQuery(querySnapshot, null);
      }
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.wait([_fetchAthleteData, _fetchSubscription, _fetchPR]),
        builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loading();
          } else {
            Athlete.current = snapshot.data?.firstWhere((data) => data is Athlete);
            Subscription.current = snapshot.data?.firstWhere((data) => data is Subscription);
            PersonalRecord.current = snapshot.data?.firstWhere((data) => data is List<PersonalRecord>);

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
                              Athlete.current!.firstName.characters.first + Athlete.current!.lastName.characters.first,
                              style: const TextStyle(
                                color: ThemeColor.secondary,
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            '${Athlete.current!.firstName} ${Athlete.current!.lastName}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            Athlete.current!.email,
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
                              color: Athlete.current!.isSubscribed ? Colors.green : Colors.grey.shade600,
                            ),
                            child: Text(
                              Athlete.current!.isSubscribed ? 'Subscribed' : 'Not Subscribed',
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              leading: const Icon(Icons.person),
                              title: const Text(
                                'Profile',
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ),
                              onTap: () {},
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
                            ListTile(
                              leading: const Icon(Icons.logout),
                              title: const Text(
                                'Logout',
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ),
                              onTap: () {},
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
                child: CustomScrollView(
                  slivers: [
                    SliverFillRemaining(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 20, left: 20, bottom: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Welcome! ${Athlete.current!.firstName}',
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
                                Athlete.current!.firstName.characters.first + Athlete.current!.lastName.characters.first,
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
                            const PRCarousel(),
                          ],
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
