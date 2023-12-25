import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    Text('Home'),
    Text('Workouts'),
    Text('Profile'),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: const Icon(CupertinoIcons.house),
          activeIcon: const Icon(CupertinoIcons.house_fill),
          label: 'Home',
          backgroundColor: _selectedIndex == 0 ? Colors.deepPurple : Colors.white,
        ),
        BottomNavigationBarItem(
          icon: const Icon(CupertinoIcons.square_list),
          activeIcon: const Icon(CupertinoIcons.square_list_fill),
          label: 'Workouts',
          backgroundColor: _selectedIndex == 0 ? Colors.deepPurple : Colors.white,
        ),
        BottomNavigationBarItem(
          icon: const Icon(CupertinoIcons.person),
          activeIcon: const Icon(CupertinoIcons.person_fill),
          label: 'Profile',
          backgroundColor: _selectedIndex == 0 ? Colors.deepPurple : Colors.white,
        ),
      ],
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
    );
  }

  Widget _buildBody() {
    return Center(
      child: _widgetOptions.elementAt(_selectedIndex),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }
}
