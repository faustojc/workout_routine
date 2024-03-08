import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:workout_routine/routes.dart';
import 'package:workout_routine/themes/colors.dart';
import 'package:workout_routine/widgets/components/athlete_form.dart';
import 'package:workout_routine/widgets/components/diagonal_container.dart';
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

  void _onSuccess() => Routes.redirectTo(context, RouteList.login);

  @override
  Widget build(BuildContext context) => Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.8,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: const AssetImage('assets/images/backgrounds/register_bg.jpg'),
                colorFilter: ColorFilter.mode(ThemeColor.black.withOpacity(0.65), BlendMode.darken),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: Colors.transparent,
            body: Container(
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  Column(
                    children: [
                      Flexible(
                        flex: 5,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
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
                                        bottom: BorderSide(width: 2, color: ThemeColor.primary),
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
                              const Column(
                                children: [
                                  Row(
                                    children: [
                                      AutoSizeText(
                                        "WELCOME",
                                        style: TextStyle(
                                          color: ThemeColor.primary,
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                      AutoSizeText(
                                        "ATHLETES",
                                        style: TextStyle(
                                          color: ThemeColor.white,
                                          fontSize: 24,
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 5),
                                  AutoSizeText(
                                    "CREATE AN ACCOUNT TO START YOUR WORKOUT JOURNEY",
                                    style: TextStyle(
                                      color: ThemeColor.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox.shrink()
                            ],
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: DiagonalContainer(
                          color: ThemeColor.black,
                          child: UserForm(onSuccess: _nextPage),
                        ),
                      )
                    ],
                  ),
                  AthleteForm(onBack: _previousPage, onSuccess: _onSuccess),
                ],
              ),
            ),
          ),
        ],
      );
}
