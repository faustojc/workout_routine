import 'package:flutter/cupertino.dart';

class _DiagonalPainter extends CustomPainter {
  final Color color;

  _DiagonalPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = color;
    paint.style = PaintingStyle.fill;

    var path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height * 0.75);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class DiagonalContainer extends StatelessWidget {
  final Widget child;
  final Color color;

  const DiagonalContainer({required this.child, required this.color, super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DiagonalPainter(color),
      child: child,
    );
  }
}
