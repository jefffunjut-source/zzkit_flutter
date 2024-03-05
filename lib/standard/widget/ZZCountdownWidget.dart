import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class ZZCountdownWidget extends StatefulWidget {
  @override
  _ZZCountdownWidgetState createState() => _ZZCountdownWidgetState();
}

class _ZZCountdownWidgetState extends State<ZZCountdownWidget> {
  late Timer _timer;
  double _countdown = 5;
  double _progress = 1.0;

  @override
  void initState() {
    super.initState();
    startCountdown();
  }

  void startCountdown() {
    const oneTenthSec = const Duration(milliseconds: 100);
    _timer = Timer.periodic(
      oneTenthSec,
      (Timer timer) {
        if (_countdown <= 0) {
          timer.cancel();
        } else {
          setState(() {
            _countdown -= 0.1;
            _progress = max(0, _countdown / 5);
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 100,
          height: 100,
          child: CustomPaint(
            painter: CountdownPainter(progress: _progress),
          ),
        ),
        Text(
          "跳过\n${_countdown.toStringAsFixed(1)}秒",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white),
        ),
      ],
    );
  }
}

class CountdownPainter extends CustomPainter {
  final double progress;

  CountdownPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.orange
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final Rect rect = Rect.fromCircle(
        center: size.center(Offset.zero), radius: size.width / 2);

    canvas.drawArc(
      rect,
      -pi / 2 + 2 * pi * progress, // start angle at top
      -2 * pi * progress, // sweep angle based on progress
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
