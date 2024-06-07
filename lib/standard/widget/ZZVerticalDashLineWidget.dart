// ignore_for_file: file_names

import 'package:flutter/material.dart';

class ZZVerticalDashLineWidget extends StatelessWidget {
  final double height;
  final Color color;
  final double strokeWidth;
  final double dashLength;
  final double dashGap;

  const ZZVerticalDashLineWidget({
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
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    double startY = 0;
    while (startY < size.height) {
      canvas.drawLine(
        Offset(0, startY),
        Offset(0, startY + dashLength),
        paint,
      );
      startY += dashLength + dashGap;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
