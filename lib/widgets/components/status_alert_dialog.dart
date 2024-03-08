import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:workout_routine/themes/colors.dart';

class StatusAlertDialog extends StatefulWidget {
  final Widget? title;
  final Widget? statusIndicator;
  final String statusMessage;
  final List<Widget>? actions;

  const StatusAlertDialog({
    required this.statusMessage,
    this.title,
    this.statusIndicator,
    this.actions,
    super.key,
  });

  @override
  State<StatusAlertDialog> createState() => _StatusAlertDialogState();
}

class _StatusAlertDialogState extends State<StatusAlertDialog> {
  @override
  Widget build(BuildContext context) => Stack(
        children: [
          AbsorbPointer(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
              child: Container(
                color: Colors.black.withOpacity(0.5),
              ),
            ),
          ),
          AlertDialog(
              title: widget.title,
              alignment: Alignment.center,
              backgroundColor: ThemeColor.grey,
              content: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 30),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    transitionBuilder: (child, animation) => ScaleTransition(scale: animation, child: child),
                    switchOutCurve: Curves.easeOut,
                    child: widget.statusIndicator,
                  ),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    transitionBuilder: (child, animation) => ScaleTransition(scale: animation, child: child),
                    switchOutCurve: Curves.easeOut,
                    child: Text(widget.statusMessage, textAlign: TextAlign.center, style: const TextStyle(color: ThemeColor.white, fontSize: 14)),
                  ),
                ],
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: widget.actions ?? [const SizedBox.shrink()],
                ),
              ]),
        ],
      );
}
