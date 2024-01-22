import 'package:flutter/material.dart';
import 'package:workout_routine/themes/colors.dart';

class PRHome extends StatefulWidget {
  const PRHome({super.key});

  @override
  State<PRHome> createState() => _PRHomeState();
}

class _PRHomeState extends State<PRHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Personal Record'),
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
            icon: const Icon(Icons.menu),
          ),
        ],
      ),
    );
  }
}
