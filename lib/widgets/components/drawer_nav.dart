import 'package:flutter/material.dart';
import 'package:workout_routine/data/user.dart';
import 'package:workout_routine/models/athlete.dart';
import 'package:workout_routine/models/subscription.dart';
import 'package:workout_routine/routes.dart';
import 'package:workout_routine/themes/colors.dart';

class DrawerNav extends StatelessWidget {
  const DrawerNav({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
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
    );
  }
}
