import 'package:auto_size_text/auto_size_text.dart';
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

class StartWorkoutPage extends StatefulWidget {
  const StartWorkoutPage({super.key});

  @override
  State<StartWorkoutPage> createState() => _StartWorkoutPageState();
}

class _StartWorkoutPageState extends State<StartWorkoutPage> {
  final List<AssetImage> backgrounds = const [
    AssetImage('assets/images/backgrounds/periodization0.png'),
    AssetImage('assets/images/backgrounds/periodization1.png'),
    AssetImage('assets/images/backgrounds/periodization2.png'),
    AssetImage('assets/images/backgrounds/periodization3.png'),
  ];

  late Future<Map<String, dynamic>?> _fetchWorkoutData;

  @override
  void initState() {
    _fetchWorkoutData = _getWorkoutData();

    super.initState();
  }

  Future<Map<String, dynamic>?> _getWorkoutData() async {
    final List<bool> checkData = [
      PeriodizationModel.list.isNotEmpty,
      WeekModel.list.isNotEmpty,
      DayModel.list.isNotEmpty,
      WorkoutModel.list.isNotEmpty,
      WorkoutParameterModel.list.isNotEmpty,
    ];

    if (checkData.every((hasData) => hasData)) {
      return {
        'periodizations': PeriodizationModel.list,
        'weeks': WeekModel.list,
        'days': DayModel.list,
        'workouts': WorkoutModel.list,
        'workout_parameters': WorkoutParameterModel.list,
      };
    }

    // For physical device
    // final periodizations = PeriodizationModel.getAll();
    // final weeks = WeekModel.getAll();
    // final days = DayModel.getAll();
    // final workouts = WorkoutModel.getAll();
    // final workoutParameters = WorkoutParameterModel.getAll();

    // for virtual device
    final periodizations = PeriodizationModel.fromList(await supabase.from('periodizations').select());
    final weeks = WeekModel.fromList(await supabase.from('weeks').select());
    final days = DayModel.fromList(await supabase.from('days').select());
    final workouts = WorkoutModel.fromList(await supabase.from('workouts').select());
    final workoutParameters = WorkoutParameterModel.fromList(await supabase.from('workout_parameters').select());

    final data = {
      'periodizations': periodizations,
      'weeks': weeks,
      'days': days,
      'workouts': workouts,
      'workout_parameters': workoutParameters,
    };

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
              final data = snapshot.data!;

              PeriodizationModel.list = data['periodizations'];
              WeekModel.list = data['weeks'];
              DayModel.list = data['days'];
              WorkoutModel.list = data['workouts'];
              WorkoutParameterModel.list = data['workout_parameters'];
            }

            return Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(20.0),
              color: ThemeColor.primary,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Start Workout',
                    style: TextStyle(fontSize: 28, color: ThemeColor.white, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 20),
                  (PeriodizationModel.list.isEmpty)
                      ? const Expanded(child: EmptyContent(title: "No periodization yet", subtitle: "This content is not available yet"))
                      : Center(
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: PeriodizationModel.list.map((periodization) {
                                final index = PeriodizationModel.list.indexOf(periodization);

                                return GestureDetector(
                                  onTap: () {
                                    PeriodizationModel.current = periodization;
                                    Routes.to(context, RouteList.periodization, direction: 'right');
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                    constraints: const BoxConstraints(minHeight: 140),
                                    margin: const EdgeInsets.only(bottom: 20),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      image: DecorationImage(
                                        image: backgrounds[index],
                                        fit: BoxFit.cover,
                                        colorFilter: ColorFilter.mode(ThemeColor.black.withOpacity(0.5), BlendMode.darken),
                                      ),
                                    ),
                                    child: Align(
                                      alignment: Alignment.bottomRight,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          AutoSizeText(
                                            periodization.acronym ?? periodization.name,
                                            style: const TextStyle(color: ThemeColor.white, fontSize: 28, fontWeight: FontWeight.bold),
                                          ),
                                          AutoSizeText(
                                            periodization.name,
                                            style: const TextStyle(color: ThemeColor.tertiary, fontSize: 14, fontWeight: FontWeight.w400),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        )
                ],
              ),
            );
          }
        });
  }
}
