import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:workout_routine/models/days.dart';
import 'package:workout_routine/models/user_workouts.dart';
import 'package:workout_routine/models/workouts.dart';
import 'package:workout_routine/themes/colors.dart';

class DayContainer extends StatefulWidget {
  final DayModel day;

  const DayContainer({required this.day, super.key});

  @override
  State<DayContainer> createState() => _DayContainerState();
}

class _DayContainerState extends State<DayContainer> {
  UserWorkoutModel? _userWorkout;
  List<WorkoutModel> _workouts = [];

  late Color _color = ThemeColor.tertiary;
  late Icon? _icon;

  @override
  void initState() {
    super.initState();

    _workouts = WorkoutModel.list.where((workout) => workout.daysId == widget.day.id).toList();

    if (WorkoutModel.list.isNotEmpty) {
      _userWorkout = UserWorkoutModel.list.firstWhere((userWorkout) => _workouts.any((workout) => workout.id == userWorkout.workoutId));

      // set the color, icon and border based on the status of the user workout
      if (_userWorkout!.status == "complete") {
        setState(() {
          _color = Colors.greenAccent;
          _icon = const Icon(Icons.check_circle, color: Colors.white);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          AutoSizeText(
            widget.day.title,
            style: const TextStyle(fontSize: 14, color: ThemeColor.white),
          ),
          Container(
            width: 65,
            height: 100,
            margin: const EdgeInsets.only(right: 5),
            decoration: BoxDecoration(
              color: _color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: (_userWorkout != null && _userWorkout!.status == "complete")
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _icon!,
                      const SizedBox(height: 5),
                      AutoSizeText(
                        _userWorkout!.status,
                        style: const TextStyle(fontSize: 12, color: ThemeColor.white),
                      ),
                    ],
                  )
                : const Icon(Icons.play_circle, color: ThemeColor.primary),
          ),
        ],
      );
}
