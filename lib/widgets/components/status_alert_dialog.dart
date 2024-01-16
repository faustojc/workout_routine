import 'dart:ui';

import 'package:flutter/material.dart';

class StatusAlertDialog extends StatefulWidget {
  final Widget currentStatusIndicator;
  final String currentStatusText;

  const StatusAlertDialog({
    super.key,
    required this.currentStatusIndicator,
    required this.currentStatusText,
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
          alignment: Alignment.center,
          content: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                transitionBuilder: (child, animation) => ScaleTransition(scale: animation, child: child),
                switchOutCurve: Curves.easeOut,
                child: widget.currentStatusIndicator,
              ),
              const SizedBox(width: 20),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                transitionBuilder: (child, animation) => ScaleTransition(scale: animation, child: child),
                switchOutCurve: Curves.easeOut,
                child: Text(widget.currentStatusText),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
