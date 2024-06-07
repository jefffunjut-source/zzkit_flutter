// ignore_for_file: file_names

import 'package:flutter/material.dart';

class ZZHorizontalDashLineWidget extends StatelessWidget {
  final double width;
  final double height;
  final Color color;
  final double strokeWidth;
  final double dashLength;
  final double dashGap;

  const ZZHorizontalDashLineWidget({
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
    return CustomPaint(
      size: Size(width, height),
      painter: ZZHorizontalDashLinePainter(
        color: color,
        strokeWidth: strokeWidth,
        dashLength: dashLength,
        dashGap: dashGap,
      ),
      child: Container(
        width: width,
        height: height,
        color: Colors.transparent,
      ),
    );
  }
}

class ZZHorizontalDashLinePainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashLength;
  final double dashGap;

  ZZHorizontalDashLinePainter({
    required this.color,
    this.strokeWidth = 2.0,
    this.dashLength = 10.0,
    this.dashGap = 5.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth;

    double startX = 0;
    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, 0),
        Offset(startX + dashLength, 0),
        paint,
      );
      startX += dashLength + dashGap;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
