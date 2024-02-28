import 'dart:ui';

import 'package:flutter/material.dart';

class StatusAlertDialog extends StatefulWidget {
  final Widget title;
  final Widget currentStatusIndicator;
  final String currentStatusText;
  final List<Widget>? actions;

  const StatusAlertDialog({
    required this.currentStatusIndicator,
    required this.currentStatusText,
    required this.title,
    this.actions,
    super.key,
  });

  @override
  State<StatusAlertDialog> createState() => _StatusAlertDialogState();
}

class _StatusAlertDialogState extends State<StatusAlertDialog> {
  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: AlertDialog(
          title: widget.title,
          alignment: Alignment.center,
          content: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 30),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                transitionBuilder: (child, animation) => ScaleTransition(scale: animation, child: child),
                switchOutCurve: Curves.easeOut,
                child: widget.currentStatusIndicator,
              ),
              const SizedBox(height: 30),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                transitionBuilder: (child, animation) => ScaleTransition(scale: animation, child: child),
                switchOutCurve: Curves.easeOut,
                child: Text(widget.currentStatusText, style: const TextStyle(fontSize: 17)),
              ),
            ],
          ),
          actions: widget.actions,
        ),
      ),
    );
  }
}
