// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: must_be_immutable, file_names

import 'package:flutter/material.dart';

class ZZTrapezoidWidget extends StatelessWidget {
  double width;
  double height;
  // 4个将四边形闭合的点
  List<ZZPoint> points;
  Color color;
  ZZTrapezoidWidget(
      {super.key,
      required this.width,
      required this.height,
      required this.points,
      required this.color});
  @override
  Widget build(BuildContext context) {
    if (points.length != 4) {
      return Container();
    }
    return CustomPaint(
      size: Size(width, height), // 宽高
      painter: ZZTrapezoidPainter(color: color, points: points),
    );
  }
}

class ZZTrapezoidPainter extends CustomPainter {
  final Color color;
  // 4个将四边形闭合的点
  final List<ZZPoint> points;

  ZZTrapezoidPainter({required this.color, required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = color;
    Path path = Path()
      ..moveTo(points[0].x!, points[0].y!)
      ..lineTo(points[1].x!, points[1].y!)
      ..lineTo(points[2].x!, points[2].y!)
      ..lineTo(points[3].x!, points[3].y!)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class ZZPoint {
  double? x;
  double? y;
  ZZPoint({
    this.x,
    this.y,
  });
}
