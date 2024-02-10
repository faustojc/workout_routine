import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:workout_routine/themes/colors.dart';

class EmptyContent extends StatelessWidget {
  final String title;
  final IconData? icon;
  final String? subtitle;

  const EmptyContent({required this.title, super.key, this.subtitle, this.icon});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Align(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            (icon != null) //
                ? Icon(icon, size: 50, color: ThemeColor.white)
                : Image.asset('assets/images/icons/empty-content.png', scale: 0.8),
            AutoSizeText(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: ThemeColor.white,
              ),
            ),
            const SizedBox(height: 6),
            (subtitle != null)
                ? AutoSizeText(
                    subtitle!,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: ThemeColor.white,
                    ),
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
