import 'package:flutter/material.dart';
import 'package:workout_routine/themes/colors.dart';

class TileField extends StatelessWidget {
  final String leading;
  final String title;

  const TileField({
    super.key,
    required this.leading,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: ThemeColor.tertiary),
        borderRadius: BorderRadius.circular(15),
      ),
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
        style: const TextStyle(color: ThemeColor.tertiary, fontSize: 14),
      ),
    );
  }
}
