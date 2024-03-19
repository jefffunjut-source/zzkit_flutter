// ignore_for_file: must_be_immutable, file_names

import 'package:flutter/material.dart';

class ZZCircleIndicator extends StatefulWidget {
  double width;
  int timeFor1Circle;
  Color circleColor;
  double circleWidth;
  int milliseconds;

  ZZCircleIndicator(
      {this.width = 36,
      this.timeFor1Circle = 1,
      this.circleColor = Colors.grey,
      this.circleWidth = 4.0,
      this.milliseconds = 400,
      super.key});

  @override
  ZZCircleIndicatorState createState() => ZZCircleIndicatorState();
}

class ZZCircleIndicatorState extends State<ZZCircleIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

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
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(widget.width),
        ),
        height: widget.width,
        width: widget.width,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(widget.circleColor),
          strokeWidth: widget.circleWidth,
        ),
      ),
    );
  }
}
