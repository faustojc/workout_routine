import 'package:flutter/material.dart';
import 'package:workout_routine/models/periodizations.dart';
import 'package:workout_routine/models/weeks.dart';
import 'package:workout_routine/routes.dart';
import 'package:workout_routine/themes/colors.dart';
import 'package:workout_routine/widgets/components/empty_content.dart';

class PeriodizationPage extends StatelessWidget {
  const PeriodizationPage({super.key});

  bool _isDataEmpty() => WeekModel.list.where((week) => week.periodizationId == PeriodizationModel.current!.id).isEmpty;

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
                    PeriodizationModel.current!.acronym ?? PeriodizationModel.current!.name,
                    textScaler: const TextScaler.linear(3.0),
                    style: const TextStyle(color: ThemeColor.tertiary, fontWeight: FontWeight.w700, letterSpacing: 0.8),
                  ),
                ),
                Text(
                  PeriodizationModel.current!.name,
                  style: const TextStyle(fontSize: 14, color: ThemeColor.white),
                ),
                (_isDataEmpty())
                    ? const EmptyContent(title: "No weeks yet", subtitle: "This content is not available yet")
                    : Expanded(
                        child: Align(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: WeekModel.list
                                .where((week) => week.periodizationId == PeriodizationModel.current!.id)
                                .map(
                                  (week) => ElevatedButton(
                                      onPressed: () {
                                        WeekModel.current = week;
                                        Navigator.of(context).pushNamed(RouteList.weeks.name);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: ThemeColor.secondary,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                      ),
                                      child: Text(
                                        week.title,
                                        style: const TextStyle(fontSize: 14, color: ThemeColor.white, fontWeight: FontWeight.w700),
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
