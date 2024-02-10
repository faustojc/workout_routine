import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:workout_routine/models/days.dart';
import 'package:workout_routine/models/weeks.dart';
import 'package:workout_routine/themes/colors.dart';
import 'package:workout_routine/widgets/components/day_container.dart';
import 'package:workout_routine/widgets/components/empty_content.dart';

class WeekCard extends StatelessWidget {
  final WeekModel week;

  const WeekCard({required this.week, super.key});

  bool _isDaysEmpty() => DayModel.list.where((day) => day.weeksId == week.id).isEmpty;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      height: 150,
      width: double.infinity,
      decoration: BoxDecoration(
        color: ThemeColor.secondary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          RotatedBox(
            quarterTurns: 3,
            child: AutoSizeText(
              week.title.toUpperCase(),
              style: const TextStyle(
                fontSize: 20,
                color: ThemeColor.white,
                fontWeight: FontWeight.w600,
                letterSpacing: 3.5,
              ),
            ),
          ),
          const VerticalDivider(
            color: ThemeColor.primary,
            thickness: 4,
            width: 25,
            indent: 20,
            endIndent: 20,
          ),
          _isDaysEmpty()
              ? const EmptyContent(icon: Icons.calendar_month, title: "No days schedule yet")
              : SingleChildScrollView(
                  child: Row(
                    children: DayModel.list //
                        .where((day) => day.weeksId == week.id)
                        .map((day) => DayContainer(day: day))
                        .toList(),
                  ),
                )
        ],
      ),
    );
  }
}
