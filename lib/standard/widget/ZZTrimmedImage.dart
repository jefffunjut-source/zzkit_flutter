// ignore_for_file: public_member_api_docs, sort_constructors_first, file_names
// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';

class ZZTrimmedImage extends StatelessWidget {
  final String imagePath;
  final double width;
  final double height;
  final double trimmedThick;

  ZZTrimmedImage({
    super.key,
    required this.imagePath,
    required this.width,
    required this.height,
    required this.trimmedThick,
  });

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: ZZTrimClipper(trimmedThick: trimmedThick),
      child: Image.asset(
        imagePath,
        width: width,
        height: height,
        fit: BoxFit.cover,
      ),
    );
  }
}

class ZZTrimClipper extends CustomClipper<Path> {
  double trimmedThick;
  ZZTrimClipper({
    required this.trimmedThick,
  });

  @override
  Path getClip(Size size) {
    Path path = Path()
      ..addOval(Rect.fromLTWH(
        trimmedThick, // 左边裁剪
        trimmedThick, // 上边裁剪
        size.width - trimmedThick * 2, // 宽度减去两侧裁剪
        size.height - trimmedThick * 2, // 高度减去上下裁剪
      ));

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
