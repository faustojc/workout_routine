import 'package:flutter/material.dart';
import 'package:workout_routine/models/personal_record.dart';
import 'package:workout_routine/themes/colors.dart';
import 'package:workout_routine/widgets/components/input_form_field.dart';

class PRCarousel extends StatefulWidget {
  const PRCarousel({super.key});

  @override
  State<PRCarousel> createState() => _PRCarouselState();
}

class _PRCarouselState extends State<PRCarousel> {
  final _formKey = GlobalKey<FormState>();
  final _prTitleController = TextEditingController();
  final _prWeightController = TextEditingController();

  late PageController _pageController;
  int activePage = 0;

  @override
  void initState() {
    super.initState();

    _pageController = PageController(viewportFraction: 0.8);
  }

  @override
  void dispose() {
    super.dispose();
    _prTitleController.dispose();
    _prWeightController.dispose();
    _pageController.dispose();
  }

  Widget _emptyPR() => Card(
      color: ThemeColor.white,
      elevation: 2,
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Enter a new personal record',
                style: TextStyle(fontSize: 20.0, color: ThemeColor.black),
              ),
              InputFormField(
                type: FieldType.text,
                controller: _prTitleController,
                hint: 'Enter record name',
                decoration: FieldDecoration.filled,
              ),
              InputFormField(
                type: FieldType.double,
                controller: _prWeightController,
                hint: 'Enter weight in lbs',
                decoration: FieldDecoration.filled,
              ),
            ],
          ),
        ),
      ));

  String _dateToString(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    final year = date.year.toString().padLeft(4, '0');

    return '$month/$day/$year';
  }

  @override
  Widget build(BuildContext context) {
    if (PersonalRecordModel.list.isEmpty) {
      return _emptyPR();
    }

    return PageView.builder(
      controller: _pageController,
      itemCount: PersonalRecordModel.list.length,
      itemBuilder: (context, int page) {
        return _carousel(page);
      },
    );
  }

  Widget _carousel(int currentPage) {
    final record = PersonalRecordModel.list[currentPage];

    return AnimatedContainer(
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeOutQuint,
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
      decoration: BoxDecoration(
        color: ThemeColor.white,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: const [
          BoxShadow(
            color: ThemeColor.black,
            blurRadius: 10.0,
            spreadRadius: 0.0,
            offset: Offset(0.0, 0.0),
          ),
        ],
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: ThemeColor.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: ThemeColor.black,
              blurRadius: 10,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              record!.title,
              style: const TextStyle(
                fontSize: 16,
                color: ThemeColor.black,
                fontWeight: FontWeight.w700,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'PR in lbs',
                  style: TextStyle(fontSize: 12, color: ThemeColor.tertiary),
                ),
                IconButton(onPressed: () {}, icon: const Icon(Icons.edit)),
              ],
            ),
            const SizedBox(height: 15),
            const Text(
              'PR History',
              style: TextStyle(
                color: ThemeColor.black,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              decoration: const BoxDecoration(
                color: Colors.transparent,
                border: Border.fromBorderSide(BorderSide(color: ThemeColor.tertiary)),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${record.weight} lbs',
                      textScaler: const TextScaler.linear(0.7),
                      style: const TextStyle(
                        color: ThemeColor.tertiary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      'Date Entered ${_dateToString(record.createdAt)}',
                      textScaler: const TextScaler.linear(0.7),
                      style: const TextStyle(
                        color: ThemeColor.tertiary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
