import 'package:flutter/material.dart';
import 'package:workout_routine/models/athletes.dart';
import 'package:workout_routine/models/subscriptions.dart';
import 'package:workout_routine/models/users.dart';
import 'package:workout_routine/routes.dart';
import 'package:workout_routine/themes/colors.dart';
import 'package:workout_routine/widgets/components/tile_field.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  String _dateFormatter(DateTime date) {
    final String month = date.month.toString().padLeft(2, '0');
    final String day = date.day.toString().padLeft(2, '0');
    final String year = date.year.toString();

    return '$month/$day/$year';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile', style: TextStyle(color: ThemeColor.white)),
        backgroundColor: ThemeColor.primary,
        leading: IconButton(
          color: ThemeColor.secondary,
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            color: ThemeColor.secondary,
            icon: const Icon(Icons.edit_rounded),
            onPressed: () => Routes.to(context, RouteList.editProfile, 'right'),
          ),
        ],
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [ThemeColor.primary, ThemeColor.secondary],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
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
                    style: const TextStyle(color: ThemeColor.white, fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(26),
                        topRight: Radius.circular(26),
                      ),
                      color: ThemeColor.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(Radius.circular(26)),
                              boxShadow: [
                                BoxShadow(
                                  color: ThemeColor.primary.withOpacity(0.2),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                              color: SubscriptionModel.current!.isSubscribed ? Colors.green : Colors.grey.shade500,
                            ),
                            child: Text(
                              SubscriptionModel.current!.isSubscribed ? 'Subscribed' : 'Unsubscribed',
                              style: const TextStyle(color: ThemeColor.white, fontSize: 16),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Note: Payments every month thru GCash',
                            style: TextStyle(
                              color: ThemeColor.secondary,
                              fontSize: 10,
                            ),
                          ),
                          const SizedBox(height: 20),
                          TileField(leading: 'First Name', title: AthleteModel.current!.firstName),
                          TileField(leading: 'Last Name', title: AthleteModel.current!.lastName),
                          TileField(leading: 'Gender', title: AthleteModel.current!.gender),
                          TileField(leading: 'Birthdate', title: _dateFormatter(AthleteModel.current!.birthday)),
                          TileField(leading: 'Age', title: AthleteModel.current!.age.toString()),
                          TileField(leading: 'Height', title: AthleteModel.current!.weight.toString()),
                          TileField(leading: 'Weight', title: AthleteModel.current!.height.toString()),
                          TileField(leading: 'City', title: AthleteModel.current!.city),
                          TileField(leading: 'Address', title: AthleteModel.current!.address),
                          TileField(leading: 'Email', title: UserModel.current!.email),
                          const SizedBox(height: 30),
                          Text('Joined ${_dateFormatter(UserModel.current!.createdAt)}',
                              style: const TextStyle(
                                color: ThemeColor.tertiary,
                                fontSize: 10,
                              )),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
