// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable, file_names
import 'package:flutter/material.dart';

class ZZVerticalLineWidget extends StatelessWidget {
  EdgeInsetsGeometry? margin;
  Color? color;
  Color? lineColor;
  double? width;

  ZZVerticalLineWidget({
    super.key,
    this.margin,
    this.color,
    this.lineColor,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.zero,
      width: width ?? 0.5,
      color: color ?? Colors.white,
      child: Container(
        margin: margin,
        color: lineColor ?? const Color(0xFFE6E6E6),
      ),
    );
  }
}
