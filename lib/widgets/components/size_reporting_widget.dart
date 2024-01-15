import 'package:flutter/material.dart';

class SizeReportingWidget extends StatefulWidget {
  final Widget child;
  final ValueChanged<Size> onSizeChange;

  const SizeReportingWidget({
    super.key,
    required this.child,
    required this.onSizeChange,
  });

  @override
  State<SizeReportingWidget> createState() => _SizeReportingWidgetState();
}

class _SizeReportingWidgetState extends State<SizeReportingWidget> {
  Size? oldSize;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final newSize = Size(constraints.maxWidth, constraints.maxHeight);
        if (oldSize != newSize) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            widget.onSizeChange(newSize);
          });
        }
        oldSize = newSize;
        return widget.child;
      },
    );
  }
}
