import 'package:flutter/material.dart';
import 'package:workout_routine/themes/colors.dart';
import 'package:workout_routine/widgets/auth/register.dart';

import 'login.dart';

class MainAuth extends StatefulWidget {
  const MainAuth({super.key});

  @override
  State<MainAuth> createState() => _MainAuthState();
}

class _MainAuthState extends State<MainAuth> {
  final List<Widget> _pages = const [
    LoginForm(key: ValueKey(1)),
    RegisterForm(key: ValueKey(2)),
  ];

  int _currentIndex = 0;

  void _changePage(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // Prevent keyboard overflow
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [ThemeColor.primary, ThemeColor.secondary],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(25),
                    child: Container(
                      margin: const EdgeInsets.only(top: 45),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: ThemeColor.secondary,
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'Welcome Back',
                            style: TextStyle(
                              fontSize: 28,
                              fontFamily: 'SpaceGrotesk',
                              fontWeight: FontWeight.normal,
                              color: ThemeColor.white,
                            ),
                          ),
                          const SizedBox(height: 20),
                          IntrinsicHeight(
                            child: IntrinsicWidth(
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                                decoration: ShapeDecoration(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                                  color: ThemeColor.primary,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: TextButton(
                                        onPressed: () {
                                          _changePage(0);
                                        },
                                        style: TextButton.styleFrom(
                                          minimumSize: const Size(130, 45),
                                          backgroundColor: _currentIndex == 0 ? ThemeColor.white : ThemeColor.primary,
                                          foregroundColor: _currentIndex == 0 ? ThemeColor.primary : ThemeColor.white,
                                          textStyle: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        child: const Text('Login'),
                                      ),
                                    ),
                                    Expanded(
                                      child: TextButton(
                                        onPressed: () {
                                          _changePage(1);
                                        },
                                        style: TextButton.styleFrom(
                                          minimumSize: const Size(130, 45),
                                          backgroundColor: _currentIndex == 1 ? ThemeColor.white : ThemeColor.primary,
                                          foregroundColor: _currentIndex == 1 ? ThemeColor.primary : ThemeColor.white,
                                          textStyle: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        child: const Text('Register'),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 700),
                    transitionBuilder: (child, animation) => SlideTransition(
                      position: Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero).animate(animation),
                      child: child,
                    ),
                    child: _pages[_currentIndex],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
