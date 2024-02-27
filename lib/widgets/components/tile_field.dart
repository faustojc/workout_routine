import 'package:flutter/material.dart';
import 'package:workout_routine/themes/colors.dart';

class TileField extends StatelessWidget {
  final String leading;
  final String title;

  const TileField({
    required this.leading,
    required this.title,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text(
        leading,
        style: const TextStyle(
          color: ThemeColor.secondary,
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
      ),
      title: Text(
        title,
        overflow: TextOverflow.ellipsis,
        softWrap: false,
        style: const TextStyle(color: ThemeColor.tertiary, fontSize: 14),
      ),
    );
  }
}
