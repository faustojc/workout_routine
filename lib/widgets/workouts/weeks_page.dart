import 'package:flutter/material.dart';
import 'package:workout_routine/models/days.dart';
import 'package:workout_routine/models/weeks.dart';
import 'package:workout_routine/routes.dart';
import 'package:workout_routine/themes/colors.dart';
import 'package:workout_routine/widgets/components/empty_content.dart';

class WeeksPage extends StatelessWidget {
  const WeeksPage({super.key});

  bool _isDataEmpty() => DayModel.list.where((day) => day.weeksId == WeekModel.current!.id).isEmpty;

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
              children: [
                FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text(
                    WeekModel.current!.title,
                    textScaler: const TextScaler.linear(3.0),
                    style: const TextStyle(color: ThemeColor.tertiary, fontWeight: FontWeight.w700, letterSpacing: 0.8),
                  ),
                ),
                (_isDataEmpty())
                    ? const EmptyContent(title: "No days yet", subtitle: "This content is not available yet")
                    : Expanded(
                        child: Align(
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: DayModel.list
                                .where((day) => day.weeksId == WeekModel.current!.id)
                                .map(
                                  (day) => ElevatedButton(
                                      onPressed: () {
                                        DayModel.current = day;
                                        Navigator.of(context).pushNamed(RouteList.days.name);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: ThemeColor.secondary,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                      ),
                                      child: Text(
                                        day.title,
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
