import 'package:flutter/material.dart';
import 'package:workout_routine/models/personal_record.dart';
import 'package:workout_routine/models/personal_record_history.dart';
import 'package:workout_routine/models/users.dart';
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
    return GridView.count(
      crossAxisCount: _personalRecordsCount,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      mainAxisSpacing: 2,
      crossAxisSpacing: 2,
      children: PersonalRecordModel.list.where((record) => record.userId == UserModel.current!.id).map((record) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          constraints: (_personalRecordsCount == 1) ? const BoxConstraints(maxHeight: 350, maxWidth: 350) : const BoxConstraints(maxHeight: 200, maxWidth: 200),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: ThemeColor.accent,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    record.title,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
                ],
              ),
              const SizedBox(height: 10),
              ListTile(
                leading: Text(
                  _getRecentPRHistory(record.id).weight.toString(),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                title: Text(_dateFormatter(_getRecentPRHistory(record.id).createdAt)),
                subtitle: const Text(
                  'lbs',
                  style: TextStyle(fontSize: 12),
                ),
              ),
              const SizedBox(height: 10),
              ActionChip(
                onPressed: () {},
                label: const Text(
                  'View History',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
