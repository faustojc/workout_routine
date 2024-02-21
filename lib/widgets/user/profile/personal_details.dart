import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:workout_routine/models/athletes.dart';
import 'package:workout_routine/themes/colors.dart';

class PersonalDetails extends StatelessWidget {
  const PersonalDetails({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text(
            "Personal Details",
            style: TextStyle(
              color: ThemeColor.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          backgroundColor: ThemeColor.primary,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const CircleAvatar(
              backgroundColor: ThemeColor.tertiary,
              child: Icon(Icons.arrow_back, color: ThemeColor.white),
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const CircleAvatar(
                backgroundColor: ThemeColor.tertiary,
                child: Icon(Icons.edit, color: ThemeColor.white),
              ),
            ),
          ],
        ),
        body: Container(
            height: MediaQuery.of(context).size.height,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            color: ThemeColor.primary,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),
                  const AutoSizeText(
                    'Profile Picture',
                    style: TextStyle(
                        color: ThemeColor.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 10),
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: ThemeColor.tertiary,
                    child: AutoSizeText(
                      AthleteModel.current!.firstName.characters.first +
                          AthleteModel.current!.lastName.characters.first,
                      style: const TextStyle(
                        color: ThemeColor.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const AutoSizeText(
                    "Profile Details",
                    style: TextStyle(
                        color: ThemeColor.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(7.0),
                    decoration: BoxDecoration(
                      color: ThemeColor.secondary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          title: AutoSizeText(
                            AthleteModel.current!.firstName,
                            style: const TextStyle(
                                color: ThemeColor.white, fontSize: 16),
                          ),
                          subtitle: const AutoSizeText(
                            'First Name',
                            style: TextStyle(
                                color: ThemeColor.tertiary, fontSize: 13),
                          ),
                        ),
                        ListTile(
                          title: AutoSizeText(
                            AthleteModel.current!.lastName,
                            style: const TextStyle(
                                color: ThemeColor.white, fontSize: 16),
                          ),
                          subtitle: const AutoSizeText(
                            'Last Name',
                            style: TextStyle(
                                color: ThemeColor.tertiary, fontSize: 13),
                          ),
                        ),
                        ListTile(
                          title: AutoSizeText(
                            AthleteModel.current!.sex,
                            style: const TextStyle(
                                color: ThemeColor.white, fontSize: 16),
                          ),
                          subtitle: const AutoSizeText(
                            'Sex',
                            style: TextStyle(
                                color: ThemeColor.tertiary, fontSize: 13),
                          ),
                        ),
                        ListTile(
                          title: AutoSizeText(
                            DateFormat.yMMMMd()
                                .format(AthleteModel.current!.birthday),
                            style: const TextStyle(
                                color: ThemeColor.white, fontSize: 16),
                          ),
                          subtitle: const AutoSizeText(
                            'Birthday',
                            style: TextStyle(
                                color: ThemeColor.tertiary, fontSize: 13),
                          ),
                        ),
                        ListTile(
                          title: AutoSizeText(
                            AthleteModel.current!.address,
                            style: const TextStyle(
                                color: ThemeColor.white, fontSize: 16),
                          ),
                          subtitle: const AutoSizeText(
                            'Address',
                            style: TextStyle(
                                color: ThemeColor.tertiary, fontSize: 13),
                          ),
                        ),
                        ListTile(
                          title: AutoSizeText(
                            AthleteModel.current!.city,
                            style: const TextStyle(
                                color: ThemeColor.white, fontSize: 16),
                          ),
                          subtitle: const AutoSizeText(
                            'City',
                            style: TextStyle(
                                color: ThemeColor.tertiary, fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const AutoSizeText(
                    "Athlete Details",
                    style: TextStyle(
                        color: ThemeColor.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(7.0),
                    decoration: BoxDecoration(
                      color: ThemeColor.secondary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          title: AutoSizeText(
                            "${AthleteModel.current!.height} lbs",
                            style: const TextStyle(
                                color: ThemeColor.white, fontSize: 16),
                          ),
                          subtitle: const AutoSizeText(
                            'Height',
                            style: TextStyle(
                                color: ThemeColor.tertiary, fontSize: 13),
                          ),
                        ),
                        ListTile(
                          title: AutoSizeText(
                            "${AthleteModel.current!.weight} lbs",
                            style: const TextStyle(
                                color: ThemeColor.white, fontSize: 16),
                          ),
                          subtitle: const AutoSizeText(
                            'Weight',
                            style: TextStyle(
                                color: ThemeColor.tertiary, fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            )),
      );
}
