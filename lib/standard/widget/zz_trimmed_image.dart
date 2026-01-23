import 'package:flutter/material.dart';
import 'dart:math';

class ZZTrimmedImage extends StatelessWidget {
  final String imagePath;
  final double width;
  final double height;
  final double trimmedThick;

  const ZZTrimmedImage({
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
  final double trimmedThick;

  ZZTrimClipper({required this.trimmedThick});

  @override
  Path getClip(Size size) {
    double t = trimmedThick.clamp(0, min(size.width / 2, size.height / 2));
    Path path =
        Path()..addOval(
          Rect.fromLTWH(t, t, size.width - 2 * t, size.height - 2 * t),
        );
    return path;
  }

  @override
  bool shouldReclip(covariant ZZTrimClipper oldClipper) {
    return oldClipper.trimmedThick != trimmedThick;
  }
}
