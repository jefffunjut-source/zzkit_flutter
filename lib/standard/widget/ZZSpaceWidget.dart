// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable, file_names
import 'package:flutter/material.dart';

class ZZSpaceWidget extends StatelessWidget {
  Color? color;
  double? width;
  double? height;
  ZZSpaceWidget({
    super.key,
    this.color,
    this.width,
    this.height,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? 10,
      height: height ?? 10,
      color: color ?? Colors.transparent,
    );
  }
}
