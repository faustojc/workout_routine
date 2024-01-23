import 'package:flutter/material.dart';
import 'package:workout_routine/models/days.dart';
import 'package:workout_routine/models/workouts.dart';
import 'package:workout_routine/themes/colors.dart';
import 'package:workout_routine/widgets/components/empty_content.dart';

class DaysPage extends StatelessWidget {
  const DaysPage({super.key});

  bool _isDataEmpty() => WorkoutModel.list.where((workout) => workout.daysId == DayModel.current!.id).isEmpty;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: ThemeColor.primary,
          foregroundColor: ThemeColor.white,
          elevation: 0,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios),
          ),
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
                FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text(
                    DayModel.current!.title,
                    textScaler: const TextScaler.linear(3.0),
                    style: const TextStyle(color: ThemeColor.tertiary, fontWeight: FontWeight.w700, letterSpacing: 0.8),
                  ),
                ),
                (_isDataEmpty())
                    ? const EmptyContent(title: "No workouts yet", subtitle: "This content is not available yet")
                    : Expanded(
                        child: Align(
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: WorkoutModel.list
                                .where((workout) => workout.daysId == DayModel.current!.id)
                                .map(
                                  (workout) => ElevatedButton(
                                      onPressed: () {
                                        WorkoutModel.current = workout;
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: ThemeColor.secondary,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                      ),
                                      child: Text(
                                        workout.title,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(fontSize: 18, color: ThemeColor.white, fontWeight: FontWeight.w700),
                                      )),
                                )
                                .toList(),
                          ),
                        ),
                      )
              ],
            )));
  }
}
