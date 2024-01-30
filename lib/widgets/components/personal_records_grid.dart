import 'package:flutter/material.dart';
import 'package:workout_routine/data/client.dart';
import 'package:workout_routine/models/personal_records.dart';
import 'package:workout_routine/models/personal_records_history.dart';
import 'package:workout_routine/themes/colors.dart';

class PersonalRecordsGrid extends StatefulWidget {
  const PersonalRecordsGrid({super.key});

  @override
  State<PersonalRecordsGrid> createState() => _PersonalRecordsGridState();
}

class _PersonalRecordsGridState extends State<PersonalRecordsGrid> {
  int _personalRecordsCount = 0;

  @override
  void initState() {
    _personalRecordsCount = (PersonalRecordModel.list.length > 1) ? 2 : 1;

    super.initState();
  }

  PRHistoryModel _getRecentPRHistory(String prId) {
    if (PRHistoryModel.list.length == 1) {
      return PRHistoryModel.list.first;
    }

    final prHistory = PRHistoryModel.list.where((history) => (history.prId == prId)).toList();

    prHistory.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return prHistory.first;
  }

  String _dateFormatter(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    final year = date.year.toString().padLeft(2, '0');

    return '$month/$day/$year';
  }

  @override
  Widget build(BuildContext context) {
    if (PersonalRecordModel.list.isEmpty) {
      return Container(
          padding: const EdgeInsets.all(20.0),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            border: Border.all(color: ThemeColor.tertiary),
            borderRadius: BorderRadius.circular(16),
            color: Colors.transparent,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/icons/empty-content.png', height: 100),
              const Text(
                'Empty personal records',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: ThemeColor.white,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Start adding personal records to tract it here',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w300,
                  color: ThemeColor.white,
                ),
              ),
            ],
          ));
    }

    return GridView.count(
      crossAxisCount: _personalRecordsCount,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      mainAxisSpacing: 2,
      crossAxisSpacing: 2,
      children: PersonalRecordModel.list.where((record) => record.userId == user.id).map((record) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          constraints: (_personalRecordsCount == 1) ? const BoxConstraints(maxHeight: 350, maxWidth: 350) : const BoxConstraints(maxHeight: 200, maxWidth: 200),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: ThemeColor.accent,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    record.title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  IconButton(onPressed: () {}, icon: const Icon(Icons.arrow_forward_ios_rounded)),
                ],
              ),
              Row(
                children: [
                  Text(
                    _getRecentPRHistory(record.id).weight.toString(),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _dateFormatter(_getRecentPRHistory(record.id).createdAt),
                        style: const TextStyle(fontSize: 10),
                      ),
                      const Text(
                        'lbs',
                        style: TextStyle(fontSize: 10),
                      ),
                    ],
                  )
                ],
              ),
              ActionChip(
                onPressed: () {},
                backgroundColor: ThemeColor.accent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 4),
                label: const Text(
                  'View History',
                  textScaler: TextScaler.linear(0.7),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
