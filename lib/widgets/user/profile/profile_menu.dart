import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:workout_routine/backend/powersync.dart';
import 'package:workout_routine/data/client.dart';
import 'package:workout_routine/models/athletes.dart';
import 'package:workout_routine/routes.dart';
import 'package:workout_routine/themes/colors.dart';

class ProfileMenu extends StatefulWidget {
  const ProfileMenu({super.key});

  @override
  State<ProfileMenu> createState() => _ProfileMenuState();
}

class _ProfileMenuState extends State<ProfileMenu> {
  bool isLoading = false;

  void _logout(BuildContext context) async {
    isLoading = true;

    await supabase.auth.signOut();
    await database.disconnectAndClear().then((value) => isLoading = false);

    if (!context.mounted) return;

    Routes.redirectTo(context, RouteList.login);
  }

  @override
  Widget build(BuildContext context) => Container(
        color: ThemeColor.primary,
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text("PROFILE MENU", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white)),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.white,
                          child: Text(
                            AthleteModel.current!.firstName.characters.first + AthleteModel.current!.lastName.characters.first,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const VerticalDivider(color: ThemeColor.tertiary, thickness: 2),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Joined", style: TextStyle(color: ThemeColor.tertiary)),
                            const SizedBox(height: 5),
                            Text(DateFormat.yMMMMd().format(AthleteModel.current!.createdAt), style: const TextStyle(color: ThemeColor.white)),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      AthleteModel.current!.firstName,
                      style: const TextStyle(
                        color: ThemeColor.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      AthleteModel.current!.lastName,
                      style: const TextStyle(
                        color: ThemeColor.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                "Account Settings",
                style: TextStyle(color: ThemeColor.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: ThemeColor.secondary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.person, color: ThemeColor.white),
                      title: Text("Personal Details", style: TextStyle(color: ThemeColor.white)),
                      trailing: Icon(Icons.arrow_forward_ios, color: ThemeColor.white),
                    ),
                    ListTile(
                      leading: Icon(Icons.lock, color: ThemeColor.white),
                      title: Text("Email and Password", style: TextStyle(color: ThemeColor.white)),
                      trailing: Icon(Icons.arrow_forward_ios, color: ThemeColor.white),
                    ),
                    ListTile(
                      leading: Icon(Icons.settings, color: ThemeColor.white),
                      title: Text("Settings", style: TextStyle(color: ThemeColor.white)),
                      trailing: Icon(Icons.arrow_forward_ios, color: ThemeColor.white),
                    ),
                    ListTile(
                      leading: Icon(Icons.straighten, color: ThemeColor.white),
                      title: Text("Units of Measure", style: TextStyle(color: ThemeColor.white)),
                      trailing: Icon(Icons.arrow_forward_ios, color: ThemeColor.white),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: ThemeColor.secondary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.privacy_tip, color: ThemeColor.white),
                      title: Text("Privacy Policy", style: TextStyle(color: ThemeColor.white)),
                      trailing: Icon(Icons.arrow_forward_ios, color: ThemeColor.white),
                    ),
                    ListTile(
                      leading: Icon(Icons.gavel, color: ThemeColor.white),
                      title: Text("Terms & Conditions", style: TextStyle(color: ThemeColor.white)),
                      trailing: Icon(Icons.arrow_forward_ios, color: ThemeColor.white),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 35),
              ElevatedButton(
                  onPressed: () => _logout(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ThemeColor.secondary,
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(color: ThemeColor.white)
                      : const Text(
                          "Logout",
                          style: TextStyle(color: ThemeColor.white, fontSize: 16, fontWeight: FontWeight.bold),
                        )),
            ],
          ),
        ),
      );
}
