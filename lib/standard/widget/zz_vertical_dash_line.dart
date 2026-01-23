import 'package:flutter/material.dart';
import 'dart:math';

class ZZVerticalDashLine extends StatelessWidget {
  final double height;
  final Color color;
  final double strokeWidth;
  final double dashLength;
  final double dashGap;

  const ZZVerticalDashLine({
    super.key,
    required this.height,
    required this.color,
    this.strokeWidth = 2.0,
    this.dashLength = 10.0,
    this.dashGap = 5.0,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(strokeWidth, height),
      painter: ZZVerticalDashLinePainter(
        color: color,
        strokeWidth: strokeWidth,
        dashLength: dashLength,
        dashGap: dashGap,
      ),
    );
  }
}

class ZZVerticalDashLinePainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashLength;
  final double dashGap;

  ZZVerticalDashLinePainter({
    required this.color,
    this.strokeWidth = 2.0,
    this.dashLength = 10.0,
    this.dashGap = 5.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color
          ..strokeWidth = strokeWidth
          ..style = PaintingStyle.stroke;

    double startY = 0;
    final x = size.width / 2;

    while (startY < size.height) {
      final endY = min(startY + dashLength, size.height);
      canvas.drawLine(Offset(x, startY), Offset(x, endY), paint);
      startY += dashLength + dashGap;
    }
  }

  @override
  bool shouldRepaint(covariant ZZVerticalDashLinePainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.dashLength != dashLength ||
        oldDelegate.dashGap != dashGap;
  }
}
