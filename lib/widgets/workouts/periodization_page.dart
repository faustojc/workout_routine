import 'package:flutter/material.dart';
import 'package:workout_routine/models/periodizations.dart';
import 'package:workout_routine/themes/colors.dart';

class PeriodizationPage extends StatelessWidget {
  const PeriodizationPage({super.key});

  Widget _emptyPeriodization() {
    return Container(
      height: 200,
      width: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.transparent,
        border: Border.all(color: ThemeColor.accent, width: 2),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/icons/empty-content.png', scale: 0.8),
          const SizedBox(height: 10),
          const Text(
            'No workouts yet',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            "Workouts will be shown here as soon as it's added",
            softWrap: true,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (PeriodizationModel.list.isEmpty) {
      return _emptyPeriodization();
    }

    return Container(
      padding: const EdgeInsets.all(20.0),
      child: Column(
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
    );
  }
}
