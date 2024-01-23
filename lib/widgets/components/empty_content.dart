import 'package:flutter/cupertino.dart';
import 'package:workout_routine/themes/colors.dart';

class EmptyContent extends StatelessWidget {
  final String title;
  final String? subtitle;

  const EmptyContent({super.key, required this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Align(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/icons/empty-content.png', scale: 0.8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: ThemeColor.white,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle!,
              softWrap: true,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w300,
                color: ThemeColor.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
