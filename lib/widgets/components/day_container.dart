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
  late UserWorkoutModel _userWorkout;
  late Color _color;
  late Icon? _icon;
  late BoxBorder? _border;

  @override
  void initState() {
    super.initState();

    // get the workout from day
    WorkoutModel workout = WorkoutModel.list.firstWhere((workout) => workout.daysId == widget.day.id);
    _userWorkout = UserWorkoutModel.list.firstWhere((userWorkout) => userWorkout.workoutId == workout.id);

    // set the color, icon and border based on the status of the user workout
    switch (_userWorkout.status) {
      case "complete":
        _color = Colors.greenAccent;
        _icon = const Icon(Icons.check_circle, color: Colors.white);
        _border = null;
        break;
      case "incomplete":
        _color = ThemeColor.tertiary;
        _icon = const Icon(Icons.highlight_off, color: Colors.white);
        _border = null;
        break;
      case "inProgress":
        _color = ThemeColor.tertiary;
        _icon = null;
        _border = Border.all(color: ThemeColor.accent, width: 2);
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
          const SizedBox(height: 10),
          // empty rectangle Container with ThemeColor.secondary color and rounded border
          Container(
            width: 65,
            height: 100,
            margin: const EdgeInsets.only(right: 5),
            decoration: BoxDecoration(
              color: _color,
              borderRadius: BorderRadius.circular(12),
              border: _border,
            ),
            child: (_userWorkout.status != "inProgress")
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _icon!,
                      const SizedBox(height: 5),
                      AutoSizeText(
                        _userWorkout.status,
                        style: const TextStyle(fontSize: 12, color: ThemeColor.white),
                      ),
                    ],
                  )
                : null,
          ),
        ],
      );
}
