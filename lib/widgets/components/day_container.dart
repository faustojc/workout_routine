import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workout_routine/models/days.dart';
import 'package:workout_routine/themes/colors.dart';

class DayContainer extends StatefulWidget {
  final DayModel day;

  const DayContainer({required this.day, super.key});

  @override
  State<DayContainer> createState() => _DayContainerState();
}

class _DayContainerState extends State<DayContainer> {
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
              color: ThemeColor.tertiary,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ],
      );
}
