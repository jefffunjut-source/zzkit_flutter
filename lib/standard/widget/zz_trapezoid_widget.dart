import 'package:flutter/material.dart';

class ZZTrapezoidWidget extends StatelessWidget {
  final double width;
  final double height;
  final List<ZZPoint> points;
  final Color color;
  final Color? borderColor;
  final double borderWidth;

  const ZZTrapezoidWidget({
    super.key,
    required this.width,
    required this.height,
    required this.points,
    required this.color,
    this.borderColor,
    this.borderWidth = 1.0,
  }) : assert(points.length == 4, "points length must be 4");

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(width, height),
      painter: ZZTrapezoidPainter(
        color: color,
        points: points,
        borderColor: borderColor,
        borderWidth: borderWidth,
      ),
    );
  }
}

class ZZTrapezoidPainter extends CustomPainter {
  final Color color;
  final List<ZZPoint> points;
  final Color? borderColor;
  final double borderWidth;

  ZZTrapezoidPainter({
    required this.color,
    required this.points,
    this.borderColor,
    this.borderWidth = 1.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path =
        Path()
          ..moveTo(points[0].x!, points[0].y!)
          ..lineTo(points[1].x!, points[1].y!)
          ..lineTo(points[2].x!, points[2].y!)
          ..lineTo(points[3].x!, points[3].y!)
          ..close();

    canvas.drawPath(path, paint);

    // 如果有边框，绘制描边
    if (borderColor != null) {
      final borderPaint =
          Paint()
            ..color = borderColor!
            ..style = PaintingStyle.stroke
            ..strokeWidth = borderWidth;
      canvas.drawPath(path, borderPaint);
    }
  }

  @override
  bool shouldRepaint(covariant ZZTrapezoidPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.borderColor != borderColor ||
        oldDelegate.borderWidth != borderWidth ||
        !_comparePoints(oldDelegate.points, points);
  }

  bool _comparePoints(List<ZZPoint> a, List<ZZPoint> b) {
    for (int i = 0; i < 4; i++) {
      if (a[i].x != b[i].x || a[i].y != b[i].y) return false;
    }
    return true;
  }
}

class ZZPoint {
  double? x;
  double? y;
  ZZPoint({this.x, this.y});
}
