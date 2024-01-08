import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:workout_routine/models/athletes.dart';
import 'package:workout_routine/routes.dart';
import 'package:workout_routine/themes/colors.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  void initState() {
    super.initState();

    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        FirebaseFirestore.instance.collection('athletes').where('userId', isEqualTo: user.uid).get().then((QuerySnapshot<Map<String, dynamic>> querySnapshot) {
          if (querySnapshot.docs.isNotEmpty) {
            Athlete.current = Athlete.fromFireStore(querySnapshot);
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      drawer: Drawer(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: ListView(
            children: [
              DrawerHeader(
                padding: const EdgeInsets.all(30),
                decoration: const BoxDecoration(color: ThemeColor.primary),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(onPressed: () => Routes.back(context), icon: const Icon(Icons.close)),
                    const SizedBox(height: 20),
                    Container(
                      decoration: const BoxDecoration(
                        border: Border.fromBorderSide(BorderSide(color: Colors.transparent)),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: Text(
                        Athlete.current!.firstName.characters.first + Athlete.current!.lastName.characters.first,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      Athlete.current!.firstName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      Athlete.current!.email,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
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
              ListTile(leading: const Icon(Icons.logout), title: const Text('Logout'), onTap: () {}),
            ],
          ),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [ThemeColor.primary, ThemeColor.secondary],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: const CustomScrollView(
          slivers: [
            Text('Dashboard'),
          ],
        ),
      ),
    );
  }
}
