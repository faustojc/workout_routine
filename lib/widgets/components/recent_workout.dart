import 'package:flutter/material.dart';
import 'package:workout_routine/models/workout_parameters.dart';
import 'package:workout_routine/models/workouts.dart';

class RecentWorkout extends StatefulWidget {
  const RecentWorkout({super.key});

  @override
  State<RecentWorkout> createState() => _RecentWorkoutState();
}

class _RecentWorkoutState extends State<RecentWorkout> {
  @override
  Widget build(BuildContext context) {
    if (Workouts.current == null) {
      return Container(
          padding: const EdgeInsets.all(20.0),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.grey[300],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/icons/no-workout.png', height: 100),
              const SizedBox(height: 10),
              const Text(
                'No recent workout',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Recent workout will be shown here',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ));
    }

    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(16.0),
      constraints: const BoxConstraints(minHeight: 200, maxHeight: 280),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(
          image: NetworkImage(Workouts.current!.thumbnailUrl),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.darken),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Workouts.current!.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: WorkoutParameterModel.list.where((workoutParam) => workoutParam.workoutId == Workouts.current!.id).map((workoutParam) {
              return Text(
                '${workoutParam.name}: ${workoutParam.value}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              );
            }).toList(),
          )
        ],
      ),
    );
  }
}
