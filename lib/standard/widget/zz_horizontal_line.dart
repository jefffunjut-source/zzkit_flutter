import 'package:flutter/material.dart';

class ZZHorizontalLine extends StatelessWidget {
  /// Outer margin
  final EdgeInsetsGeometry? margin;

  /// Background color of the container
  final Color? color;

  /// Actual line color
  final Color? lineColor;

  /// Line height
  final double? height;

  const ZZHorizontalLine({
    super.key,
    this.margin,
    this.color,
    this.lineColor,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final double effectiveHeight = height ?? 0.5;

    return Container(
      margin: margin,
      height: effectiveHeight,
      color: color ?? Colors.white,
      child: DecoratedBox(
        decoration: BoxDecoration(color: lineColor ?? const Color(0xFFE6E6E6)),
      ),
    );
  }
}
