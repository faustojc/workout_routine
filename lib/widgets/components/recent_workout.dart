import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:workout_routine/models/user_workouts.dart';
import 'package:workout_routine/models/workout_parameters.dart';
import 'package:workout_routine/models/workouts.dart';
import 'package:workout_routine/themes/colors.dart';

class RecentWorkout extends StatefulWidget {
  const RecentWorkout({super.key});

  @override
  State<RecentWorkout> createState() => _RecentWorkoutState();
}

class _RecentWorkoutState extends State<RecentWorkout> {
  late WorkoutModel currWorkout;

  List<WorkoutParameterModel> workoutParams = [];
  double playedDuration = 0.0;

  @override
  void initState() {
    super.initState();

    if (WorkoutModel.list.isNotEmpty && UserWorkoutModel.current != null) {
      currWorkout = WorkoutModel.list.where((workout) => workout.id == UserWorkoutModel.current!.workoutId).first;
      workoutParams = WorkoutParameterModel.list //
          .where((param) => param.workoutId == UserWorkoutModel.current!.workoutId)
          .toList();
      playedDuration = (UserWorkoutModel.current!.playedAt.inSeconds / currWorkout.videoDuration.inSeconds) * 100;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (UserWorkoutModel.current == null) {
      return Container(
          padding: const EdgeInsets.all(20.0),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            border: Border.all(color: ThemeColor.tertiary),
            borderRadius: BorderRadius.circular(16),
            color: Colors.transparent,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/icons/no-workout.png', height: 100),
              const Text(
                'No recent workout',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: ThemeColor.white,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Your recent workout will be shown here',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w300,
                  color: ThemeColor.white,
                ),
              ),
            ],
          ));
    }

    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(16.0),
      constraints: const BoxConstraints(minHeight: 280, maxHeight: 280),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(
          image: NetworkImage(currWorkout.thumbnailUrl!),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.2), BlendMode.darken),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.arrow_forward_ios, color: ThemeColor.white),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AutoSizeText(
                        WorkoutModel.current!.title,
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                          color: ThemeColor.white,
                          fontSize: 52,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Column(
                        children: workoutParams //
                            .take((workoutParams.length > 1) ? 2 : 1)
                            .map((param) => AutoSizeText(param.value, style: const TextStyle(color: ThemeColor.white, fontSize: 14)))
                            .toList(),
                      ),
                    ],
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: playedDuration,
                      backgroundColor: ThemeColor.tertiary,
                      minHeight: 14,
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.greenAccent),
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
