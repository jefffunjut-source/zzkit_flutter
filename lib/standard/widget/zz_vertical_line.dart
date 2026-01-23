import 'package:flutter/material.dart';

class ZZVerticalLine extends StatelessWidget {
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor; // 背景色
  final Color? lineColor; // 线条颜色
  final double? width;
  final double? height;

  const ZZVerticalLine({
    super.key,
    this.margin,
    this.backgroundColor,
    this.lineColor,
    this.width = 1.0,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      width: width,
      height: height,
      color: backgroundColor ?? Colors.transparent,
      child: Align(
        alignment: Alignment.center,
        child: Container(
          width: width,
          color: lineColor ?? const Color(0xFFE6E6E6),
        ),
      ),
    );
  }
}
