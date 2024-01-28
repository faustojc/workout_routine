import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:workout_routine/models/personal_records.dart';
import 'package:workout_routine/models/personal_records_history.dart';
import 'package:workout_routine/themes/colors.dart';
import 'package:workout_routine/widgets/components/empty_content.dart';

class PRHome extends StatefulWidget {
  const PRHome({super.key});

  @override
  State<PRHome> createState() => _PRHomeState();
}

class _PRHomeState extends State<PRHome> {
  final List<PersonalRecordModel> _pr = PersonalRecordModel.list;
  final List<PRHistoryModel> _prHistory = PRHistoryModel.list;

  String _dateFormat(DateTime date) {
    return DateFormat.yMMMMd('en_US').format(date);
  }

  String _historiesCount(String prId) {
    final histories = _prHistory.where((history) => (history.prId == prId)).toList();

    return '${histories.length}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Personal Records'),
        centerTitle: true,
        backgroundColor: ThemeColor.primary,
        foregroundColor: ThemeColor.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
      body: Container(
          padding: const EdgeInsets.all(20.0),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [ThemeColor.primary, ThemeColor.secondary],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            children: [
              SearchBar(
                hintText: 'Search personal records',
                leading: const Icon(Icons.search),
                constraints: const BoxConstraints(
                  minHeight: 50,
                  maxHeight: 50,
                ),
                textStyle: MaterialStateProperty.all(const TextStyle(
                  fontSize: 12,
                  color: ThemeColor.black,
                )),
                padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 10)),
                onChanged: (value) {},
              ),
              const SizedBox(height: 20),
              (_pr.isEmpty)
                  ? const EmptyContent(title: 'No personal records', subtitle: 'Add your personal records or no search results found')
                  : Expanded(
                      child: ListView.builder(
                          itemCount: _pr.length,
                          itemBuilder: (context, int index) {
                            return Card(
                                elevation: 2,
                                color: ThemeColor.accent,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                    horizontal: 16,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            _pr[index].title,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                              color: ThemeColor.black,
                                            ),
                                          ),
                                          Text(
                                            'Created ${_dateFormat(_pr[index].createdAt)}',
                                            style: const TextStyle(
                                              fontSize: 11,
                                              color: ThemeColor.black,
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          Text(
                                            'Histories: ${_historiesCount(_pr[index].id)}',
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: ThemeColor.black.withOpacity(0.9),
                                            ),
                                          )
                                        ],
                                      ),
                                      IconButton(
                                        onPressed: () {},
                                        icon: const Icon(Icons.arrow_forward_ios_rounded),
                                      ),
                                    ],
                                  ),
                                ));
                          }),
                    )
            ],
          )),
    );
  }
}
