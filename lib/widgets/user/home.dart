import 'package:flutter/material.dart';
import 'package:workout_routine/models/athletes.dart';
import 'package:workout_routine/routes.dart';
import 'package:workout_routine/themes/colors.dart';
import 'package:workout_routine/widgets/components/personal_records_grid.dart';
import 'package:workout_routine/widgets/components/recent_workout.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  double _indicatorLeft = 0.0;

  void _setIndex(int value, double itemWidth) {
    setState(() {
      _currentIndex = value;
      _indicatorLeft = ((_currentIndex == 2 || _currentIndex == 3) ? (_currentIndex + 1) : _currentIndex) * itemWidth;
    });
  }

  @override
  Widget build(BuildContext context) {
    double itemWidth = MediaQuery.of(context).size.width / 5;

    return SafeArea(
      child: Scaffold(
        backgroundColor: ThemeColor.primary,
        resizeToAvoidBottomInset: true,
        floatingActionButton: FloatingActionButton(
          onPressed: () => Routes.to(context, RouteList.startWorkout, 'right'),
          elevation: 4,
          backgroundColor: ThemeColor.accent,
          shape: const CircleBorder(),
          child: const Icon(Icons.fitness_center, color: ThemeColor.primary),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: Stack(
          children: [
            BottomAppBar(
              shape: const CircularNotchedRectangle(),
              elevation: 2,
              height: 60,
              color: ThemeColor.secondary,
              surfaceTintColor: ThemeColor.black,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => _setIndex(0, itemWidth),
                    icon: Icon(Icons.home, color: _currentIndex == 0 ? ThemeColor.accent : ThemeColor.black),
                  ),
                  IconButton(
                    onPressed: () => _setIndex(1, itemWidth),
                    icon: Icon(Icons.history, color: _currentIndex == 1 ? ThemeColor.accent : ThemeColor.black),
                  ),
                  const SizedBox(width: 42),
                  IconButton(
                    onPressed: () => _setIndex(2, itemWidth),
                    icon: Icon(Icons.notifications, color: _currentIndex == 2 ? ThemeColor.accent : ThemeColor.black),
                  ),
                  IconButton(
                    onPressed: () => _setIndex(3, itemWidth),
                    icon: Icon(Icons.person, color: _currentIndex == 3 ? ThemeColor.accent : ThemeColor.black),
                  ),
                ],
              ),
            ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              bottom: 0,
              left: _indicatorLeft,
              child: Container(
                width: itemWidth,
                height: 4,
                decoration: const BoxDecoration(
                  color: ThemeColor.accent,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                ),
              ),
            ),
          ],
        ),
        body: Container(
            height: MediaQuery.of(context).size.height,
            color: ThemeColor.primary,
            child: SingleChildScrollView(
                padding: const EdgeInsets.only(right: 15, left: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ListTile(
                      title: const Text(
                        'WELCOME,',
                        style: TextStyle(color: ThemeColor.tertiary, fontSize: 12),
                      ),
                      subtitle: Text(
                        AthleteModel.current!.firstName.toUpperCase(),
                        style: const TextStyle(
                          color: ThemeColor.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8,
                        ),
                      ),
                      trailing: CircleAvatar(
                        backgroundColor: ThemeColor.white,
                        child: Text(
                          AthleteModel.current!.firstName.characters.first + AthleteModel.current!.lastName.characters.first,
                          style: const TextStyle(
                            color: ThemeColor.secondary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    const RecentWorkout(),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'PERSONAL RECORDS',
                          style: TextStyle(
                            color: ThemeColor.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        IconButton(
                          onPressed: () => Routes.to(context, RouteList.personal_record, 'right'),
                          icon: const Icon(Icons.more_horiz, color: ThemeColor.white),
                        )
                      ],
                    ),
                    const SizedBox(height: 5),
                    const PersonalRecordsGrid(),
                  ],
                ))),
      ),
    );
  }
}
