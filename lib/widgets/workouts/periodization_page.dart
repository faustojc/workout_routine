import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:workout_routine/models/periodizations.dart';
import 'package:workout_routine/models/weeks.dart';
import 'package:workout_routine/themes/colors.dart';
import 'package:workout_routine/widgets/components/empty_content.dart';
import 'package:workout_routine/widgets/components/week_card.dart';

class PeriodizationPage extends StatelessWidget {
  const PeriodizationPage({super.key});

  bool get _isDataEmpty => WeekModel.list.where((week) => week.periodizationId == PeriodizationModel.current!.id).isEmpty;

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: ThemeColor.primary,
        appBar: AppBar(
          backgroundColor: ThemeColor.primary,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const CircleAvatar(
              backgroundColor: ThemeColor.tertiary,
              child: Icon(Icons.arrow_back, color: ThemeColor.primary),
            ),
          ),
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Column(
                  children: [
                    AutoSizeText(
                      PeriodizationModel.current!.acronym ?? PeriodizationModel.current!.name,
                      style: const TextStyle(fontSize: 50, color: ThemeColor.white, fontWeight: FontWeight.w600),
                    ),
                    AutoSizeText(
                      PeriodizationModel.current!.name,
                      style: const TextStyle(color: ThemeColor.tertiary, fontSize: 16, fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: ThemeColor.tertiary, width: 2),
                      ),
                      child: AutoSizeText(
                        PeriodizationModel.current!.description,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: ThemeColor.white, fontSize: 14),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 20),
                _isDataEmpty
                    ? const EmptyContent(icon: Icons.not_interested, title: "No week yet", subtitle: "This content is not available yet")
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: WeekModel.list //
                            .where((week) => week.periodizationId == PeriodizationModel.current!.id)
                            .map((week) => Container(
                                  margin: const EdgeInsets.only(bottom: 10),
                                  child: WeekCard(week: week),
                                ))
                            .toList(),
                      ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      );
}
