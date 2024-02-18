import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:workout_routine/themes/colors.dart';

enum ToastType {
  success,
  error,
  warning,
  info,
}

/// Displays a toast message
///
void showToast({
  required BuildContext context,
  required String message,
  required ToastType type,
  required TickerProvider vsync,
  Duration duration = const Duration(seconds: 2),
  bool dismissible = false,
  bool isTop = false,
}) {
  Icon icon;
  IconButton? dismissButton;
  Timer? timer;

  var animationController = AnimationController(
    duration: const Duration(milliseconds: 700),
    vsync: vsync,
  );

  var offsetAnimation = Tween<Offset>(
    begin: isTop ? const Offset(0.0, -1.0) : const Offset(0.0, 1.0),
    end: Offset.zero,
  ).animate(CurvedAnimation(parent: animationController, curve: Curves.easeInOut));

  switch (type) {
    case ToastType.success:
      icon = const Icon(Icons.check_circle, color: Colors.green);
      break;
    case ToastType.error:
      icon = const Icon(Icons.error_rounded, color: Colors.red);
      break;
    case ToastType.warning:
      icon = const Icon(Icons.warning, color: Colors.orange);
      break;
    case ToastType.info:
      icon = const Icon(Icons.info_rounded, color: ThemeColor.tertiary);
      break;
  }

  OverlayEntry overlayEntry = OverlayEntry(
    builder: (context) => SlideTransition(
      position: offsetAnimation,
      child: Align(
        alignment: isTop ? const Alignment(0.0, -0.85) : const Alignment(0.0, 0.85),
        child: Material(
          color: Colors.transparent,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(22), color: ThemeColor.black),
            child: ListTile(
              leading: icon,
              trailing: dismissButton,
              title: AutoSizeText(message, style: const TextStyle(color: Colors.white, fontSize: 14)),
            ),
          ),
        ),
      ),
    ),
  );

  if (dismissible) {
    dismissButton = IconButton(
      icon: const Icon(Icons.close, color: Colors.white),
      onPressed: () {
        timer?.cancel();
        animationController.reverse();
        animationController.addStatusListener((status) {
          if (status == AnimationStatus.dismissed) {
            overlayEntry.remove();
          }
        });
      },
    );
  }

  Overlay.of(context).insert(overlayEntry);

  animationController.forward();

  timer = Timer(
      duration,
      () => Timer(const Duration(seconds: 2), () {
            animationController.reverse();
            animationController.addStatusListener((status) {
              if (status == AnimationStatus.dismissed) {
                overlayEntry.remove();
              }
            });
          }));
}
