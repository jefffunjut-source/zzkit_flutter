import 'package:flutter/material.dart';

class ZZHorizontalDashLine extends StatelessWidget {
  final double width;
  final double height;
  final Color color;
  final double strokeWidth;
  final double dashLength;
  final double dashGap;

  const ZZHorizontalDashLine({
    super.key,
    required this.width,
    required this.height,
    required this.color,
    this.strokeWidth = 2.0,
    this.dashLength = 10.0,
    this.dashGap = 5.0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(
        painter: ZZHorizontalDashLinePainter(
          color: color,
          strokeWidth: strokeWidth,
          dashLength: dashLength,
          dashGap: dashGap,
        ),
      ),
    );
  }
}

class ZZHorizontalDashLinePainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashLength;
  final double dashGap;

  const ZZHorizontalDashLinePainter({
    required this.color,
    this.strokeWidth = 2.0,
    this.dashLength = 10.0,
    this.dashGap = 5.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint =
        Paint()
          ..color = color
          ..strokeWidth = strokeWidth
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.square;

    final double y = size.height / 2;
    double startX = 0;

    while (startX < size.width) {
      final double endX = (startX + dashLength).clamp(0, size.width);
      canvas.drawLine(Offset(startX, y), Offset(endX, y), paint);
      startX += dashLength + dashGap;
    }
  }

  @override
  bool shouldRepaint(covariant ZZHorizontalDashLinePainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.dashLength != dashLength ||
        oldDelegate.dashGap != dashGap;
  }
}
