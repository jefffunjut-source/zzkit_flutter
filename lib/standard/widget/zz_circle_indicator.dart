import 'package:flutter/material.dart';

class ZZCircleIndicator extends StatefulWidget {
  /// Diameter of the indicator
  final double width;

  /// Seconds for one full animation cycle
  final int timeFor1Circle;

  /// Color of the progress indicator
  final Color circleColor;

  /// Stroke width of the circle
  final double circleWidth;

  /// AnimatedContainer duration in milliseconds
  final int milliseconds;

  const ZZCircleIndicator({
    super.key,
    this.width = 36,
    this.timeFor1Circle = 1,
    this.circleColor = Colors.grey,
    this.circleWidth = 4.0,
    this.milliseconds = 400,
  });

  @override
  ZZCircleIndicatorState createState() => ZZCircleIndicatorState();
}

class ZZCircleIndicatorState extends State<ZZCircleIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.timeFor1Circle),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedContainer(
        duration: Duration(milliseconds: widget.milliseconds),
        height: widget.width,
        width: widget.width,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(widget.width),
        ),
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(widget.circleColor),
          strokeWidth: widget.circleWidth,
        ),
      ),
    );
  }
}
