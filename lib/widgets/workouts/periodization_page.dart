import 'package:flutter/material.dart';
import 'package:workout_routine/models/periodizations.dart';
import 'package:workout_routine/models/weeks.dart';
import 'package:workout_routine/themes/colors.dart';
import 'package:workout_routine/widgets/components/empty_content.dart';

class PeriodizationPage extends StatelessWidget {
  const PeriodizationPage({super.key});

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
                  PeriodizationModel.current!.acronym!,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700, letterSpacing: 0.8),
                ),
                const SizedBox(height: 10),
                Text(
                  PeriodizationModel.current!.name,
                  style: const TextStyle(fontSize: 14, color: ThemeColor.white),
                ),
                (WeekModel.list.isEmpty)
                    ? const EmptyContent(title: "No weeks yet", subtitle: "This content is not available yet")
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: WeekModel.list
                            .where((week) => week.periodizationId == PeriodizationModel.current!.id)
                            .map(
                              (week) => ElevatedButton(
                                  onPressed: () {
                                    WeekModel.current = week;
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
              ],
            )));
  }
}
