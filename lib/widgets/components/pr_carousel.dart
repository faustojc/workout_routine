import 'package:cloud_firestore/cloud_firestore.dart';
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

  String _dateToString(Timestamp timestamp) {
    final date = timestamp.toDate();
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    final year = date.year.toString().padLeft(4, '0');

    return '$month/$day/$year';
  }

  @override
  Widget build(BuildContext context) {
    if (PersonalRecord.current.isEmpty) {
      return _emptyPR();
    }

    return PageView.builder(
      controller: _pageController,
      itemCount: PersonalRecord.current.length,
      onPageChanged: (int pagePosition) => setState(() => activePage = pagePosition),
      itemBuilder: (BuildContext context, int pagePosition) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          decoration: BoxDecoration(
            color: ThemeColor.white,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                PersonalRecord.current[pagePosition]!.title,
                style: const TextStyle(
                  fontSize: 20,
                  color: ThemeColor.black,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('PR in lbs'),
                  IconButton(onPressed: () {}, icon: const Icon(Icons.edit)),
                ],
              ),
              const SizedBox(height: 15),
              const Text(
                'PR History',
                style: TextStyle(
                  color: ThemeColor.black,
                  fontWeight: FontWeight.w700,
                  fontSize: 24,
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
                        '${PersonalRecord.current[pagePosition]!.oldWeight} lbs',
                        style: const TextStyle(
                          color: ThemeColor.tertiary,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'Date Entered ${_dateToString(PersonalRecord.current[pagePosition]!.createdAt)}',
                        style: const TextStyle(
                          color: ThemeColor.tertiary,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
