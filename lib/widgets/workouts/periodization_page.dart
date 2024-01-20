import 'package:flutter/material.dart';
import 'package:workout_routine/models/periodizations.dart';
import 'package:workout_routine/themes/colors.dart';

class PeriodizationPage extends StatelessWidget {
  const PeriodizationPage({super.key});

  Widget _emptyPeriodization() {
    return Align(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/icons/empty-content.png', scale: 0.8),
          const Text(
            'No workouts yet',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: ThemeColor.white,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            "Workouts will be shown here as soon as it's added",
            softWrap: true,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w300,
              color: ThemeColor.white,
            ),
          ),
        ],
      ),
    );
  }

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
        child: (PeriodizationModel.list.isEmpty)
            ? _emptyPeriodization()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Start Workout',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: PeriodizationModel.list
                          .map(
                            (periodization) => ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: ThemeColor.secondary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                child: Text(
                                  periodization.acronym ?? periodization.name,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: ThemeColor.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                )),
                          )
                          .toList(),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
