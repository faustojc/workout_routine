import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:workout_routine/models/workout_parameters.dart';
import 'package:workout_routine/models/workouts.dart';
import 'package:workout_routine/themes/colors.dart';

class WorkoutTypePage extends StatefulWidget {
  const WorkoutTypePage({super.key});

  @override
  State<WorkoutTypePage> createState() => _WorkoutTypePageState();
}

class _WorkoutTypePageState extends State<WorkoutTypePage> {
  late WorkoutModel _workout;
  late List<WorkoutParameterModel> _parameters;

  bool _failedToLoad = false;

  @override
  void initState() {
    _workout = WorkoutModel.current!;
    _parameters = WorkoutParameterModel.list.where((parameter) => parameter.workoutId == _workout.id).toList();

    super.initState();
  }

  @override
  Widget build(BuildContext context) => Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.7,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: CachedNetworkImageProvider(
                  _workout.thumbnailUrl!,
                  errorListener: (object) => setState(() => _failedToLoad = true),
                ),
                fit: BoxFit.cover,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 22),
                    child: CircleAvatar(
                      backgroundColor: ThemeColor.primary,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: ThemeColor.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ),
                  Expanded(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 500),
                      switchOutCurve: Curves.easeInOut,
                      child: !_failedToLoad
                          ? const SizedBox()
                          : const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.image_not_supported_outlined, color: ThemeColor.secondary, size: 60),
                                SizedBox(width: 10),
                                AutoSizeText(
                                  'Failed to load image',
                                  style: TextStyle(fontSize: 16, color: ThemeColor.white),
                                ),
                              ],
                            ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              child: Material(
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                color: ThemeColor.white,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AutoSizeText(
                            _workout.title,
                            style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w900),
                          ),
                          const Column(
                            children: [
                              Icon(Icons.play_arrow, color: ThemeColor.primary, size: 40),
                              AutoSizeText('Play', style: TextStyle(fontSize: 14, color: ThemeColor.primary)),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                        decoration: BoxDecoration(
                          color: ThemeColor.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: ThemeColor.primary),
                          boxShadow: [
                            BoxShadow(
                              color: ThemeColor.primary.withOpacity(0.2),
                              blurRadius: 4,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: AutoSizeText(
                          _workout.description,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 14, color: ThemeColor.primary),
                        ),
                      ),
                      Column(
                        children: [
                          const Text(
                            "Parameters",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: ThemeColor.secondary),
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              children: _parameters
                                  .map((parameter) => Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              const Icon(Icons.circle_rounded, color: ThemeColor.secondary, size: 20),
                                              const SizedBox(width: 15),
                                              AutoSizeText(parameter.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400)),
                                            ],
                                          ),
                                          AutoSizeText(parameter.value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400)),
                                        ],
                                      ))
                                  .toList(),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      );
}
