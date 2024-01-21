import 'package:flutter/material.dart';
import 'package:workout_routine/models/days.dart';
import 'package:workout_routine/models/workouts.dart';
import 'package:workout_routine/themes/colors.dart';
import 'package:workout_routine/widgets/components/empty_content.dart';

class DaysPage extends StatelessWidget {
  const DaysPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Periodization'),
          centerTitle: true,
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
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  DayModel.current!.title,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                ),
                (DayModel.list.isEmpty)
                    ? const EmptyContent(title: "No days yet", subtitle: "This content is not available yet")
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
              ],
            )));
  }
}
