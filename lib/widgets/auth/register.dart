import 'package:flutter/material.dart';
import 'package:workout_routine/routes.dart';
import 'package:workout_routine/themes/colors.dart';
import 'package:workout_routine/widgets/components/athlete_form.dart';
import 'package:workout_routine/widgets/components/user_form.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final PageController _pageController = PageController();

  void _nextPage() {
    _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.ease);
  }

  void _previousPage() {
    _pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.ease);
  }

  void _onSuccess() {}

  @override
  Widget build(BuildContext context) => Material(
        color: ThemeColor.primary,
        child: Container(
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      color: Colors.transparent,
                      child: TextButton(
                        onPressed: () => Routes.redirectTo(context, RouteList.login),
                        style: TextButton.styleFrom(backgroundColor: Colors.transparent, padding: const EdgeInsets.all(10)),
                        child: const Text(
                          'Login',
                          style: TextStyle(
                            color: ThemeColor.white,
                            fontSize: 17,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.transparent,
                        border: Border(
                          bottom: BorderSide(width: 2, color: ThemeColor.tertiary),
                        ),
                      ),
                      child: TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(backgroundColor: Colors.transparent, padding: const EdgeInsets.all(10)),
                        child: const Text(
                          'Register',
                          style: TextStyle(
                            color: ThemeColor.white,
                            fontSize: 17,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    UserForm(onSuccess: _nextPage),
                    AthleteForm(onBack: _previousPage, onSuccess: _onSuccess),
                  ],
                ),
              )
            ],
          ),
        ),
      );
}
