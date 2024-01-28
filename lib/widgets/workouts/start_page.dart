import 'package:flutter/material.dart';
import 'package:workout_routine/data/client.dart';
import 'package:workout_routine/models/days.dart';
import 'package:workout_routine/models/periodizations.dart';
import 'package:workout_routine/models/weeks.dart';
import 'package:workout_routine/models/workout_parameters.dart';
import 'package:workout_routine/models/workouts.dart';
import 'package:workout_routine/routes.dart';
import 'package:workout_routine/themes/colors.dart';
import 'package:workout_routine/widgets/components/empty_content.dart';
import 'package:workout_routine/widgets/components/loading.dart';

class StartWorkout extends StatefulWidget {
  const StartWorkout({super.key});

  @override
  State<StartWorkout> createState() => _StartWorkoutState();
}

class _StartWorkoutState extends State<StartWorkout> {
  late Future<Map<String, List<Map<String, dynamic>>>?> _fetchWorkoutData;

  @override
  void initState() {
    _fetchWorkoutData = _getWorkoutData();

    super.initState();
  }

  Future<Map<String, List<Map<String, dynamic>>>?> _getWorkoutData() async {
    final Map<String, List<Map<String, dynamic>>> data = {};

    final periodizations = await supabase.from('periodizations').select();
    final weeks = await supabase.from('weeks').select();
    final days = await supabase.from('days').select();
    final workouts = await supabase.from('workouts').select('*, workout_parameters(*)');

    data.addAll({
      'periodizations': periodizations,
      'weeks': weeks,
      'days': days,
      'workouts': workouts,
    });

    if (data.map((key, value) => MapEntry(key, value)).isNotEmpty) {
      return data;
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _fetchWorkoutData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loading();
          } else {
            if (snapshot.hasData) {
              PeriodizationModel.list = snapshot.data!['periodizations']!.map((periodization) => PeriodizationModel.fromJson(periodization)).toList();
              WeekModel.list = snapshot.data!['weeks']!.map((week) => WeekModel.fromJson(week)).toList();
              DayModel.list = snapshot.data!['days']!.map((day) => DayModel.fromJson(day)).toList();
              WorkoutModel.list = snapshot.data!['workouts']!.map((workout) => WorkoutModel.fromJson(workout)).toList();
              WorkoutParameterModel.list = snapshot.data!['workouts']!.map((workout) => WorkoutParameterModel.fromJson(workout['workout_parameters'])).toList();
            }

            return Scaffold(
              appBar: AppBar(
                backgroundColor: ThemeColor.primary,
                foregroundColor: ThemeColor.white,
                elevation: 0,
                leading: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back_ios),
                ),
                actions: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.menu),
                  ),
                ],
              ),
              body: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(20.0),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      ThemeColor.primary,
                      ThemeColor.secondary,
                    ],
                  ),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Start Workout',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 22, color: ThemeColor.white, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 30),
                    (PeriodizationModel.list.isEmpty)
                        ? const EmptyContent(title: "No periodization yet", subtitle: "This content is not available yet")
                        : Align(
                            heightFactor: 1.5,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: PeriodizationModel.list
                                  .map(
                                    (periodization) => ElevatedButton(
                                      onPressed: () {
                                        PeriodizationModel.current = periodization;
                                        Navigator.pushNamed(context, RouteList.periodization.name);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: ThemeColor.secondary,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                      ),
                                      child: Text(
                                        periodization.acronym ?? periodization.name,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(fontSize: 14, color: ThemeColor.white, fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          )
                  ],
                ),
              ),
            );
          }
        });
  }
}
