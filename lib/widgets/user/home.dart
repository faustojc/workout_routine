import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_routine/models/athletes.dart';
import 'package:workout_routine/routes.dart';
import 'package:workout_routine/services/connectivity_service.dart';
import 'package:workout_routine/themes/colors.dart';
import 'package:workout_routine/widgets/components/notification_listview.dart';
import 'package:workout_routine/widgets/components/personal_records_grid.dart';
import 'package:workout_routine/widgets/components/recent_workout.dart';
import 'package:workout_routine/widgets/components/toast.dart';
import 'package:workout_routine/widgets/user/personal_records/pr_home.dart';
import 'package:workout_routine/widgets/user/profile/profile_menu.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  late TabController _tabController;
  late ConnectivityService _connectionStatus;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();

    _connectionStatus = Provider.of<ConnectivityService>(context, listen: false);
    _connectionStatus.addListener(() {
      if (_connectionStatus.status == InternetStatus.offline) {
        showToast(context: context, message: "No connection", type: ToastType.info, vsync: this);
      }
    });

    _tabController = TabController(length: 5, vsync: this);
    _tabController.addListener(() {
      _currentIndex = _tabController.index;

      if (_tabController.index == 2) {
        _tabController.index = _tabController.previousIndex;
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();

    super.dispose();
  }

  void _setPage(int value, double itemWidth) {
    setState(() {
      _currentIndex = value;
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
        bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          elevation: 2,
          height: 60,
          color: ThemeColor.secondary,
          surfaceTintColor: ThemeColor.black,
          child: TabBar(
            controller: _tabController,
            dividerColor: Colors.transparent,
            indicatorColor: ThemeColor.accent,
            onTap: (value) => _setPage(value, itemWidth),
            splashFactory: NoSplash.splashFactory,
            tabs: [
              Tab(icon: Icon(Icons.home, color: _currentIndex == 0 ? ThemeColor.accent : ThemeColor.black)),
              Tab(icon: Icon(Icons.history, color: _currentIndex == 1 ? ThemeColor.accent : ThemeColor.black)),
              const Tab(icon: SizedBox.shrink()),
              Tab(icon: Icon(Icons.notifications, color: _currentIndex == 3 ? ThemeColor.accent : ThemeColor.black)),
              Tab(icon: Icon(Icons.person, color: _currentIndex == 4 ? ThemeColor.accent : ThemeColor.black)),
            ],
          ),
        ),
        body: Container(
            height: MediaQuery.of(context).size.height,
            color: ThemeColor.primary,
            child: TabBarView(
              controller: _tabController,
              children: [
                SingleChildScrollView(
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
                        const Text(
                          'RECENT WORKOUT',
                          style: TextStyle(
                            color: ThemeColor.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 15),
                        const RecentWorkout(),
                        const SizedBox(height: 30),
                        const Text(
                          'RECENT PERSONAL RECORDS',
                          style: TextStyle(
                            color: ThemeColor.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 20),
                        const PersonalRecordsGrid(),
                      ],
                    )),
                const PRHome(),
                const SizedBox.shrink(),
                const NotificationListView(),
                const ProfileMenu(),
              ],
            )),
      ),
    );
  }
}
