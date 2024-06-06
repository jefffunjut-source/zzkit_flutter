// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable, file_names

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ZZOuterRadiusWidget extends StatelessWidget {
  Widget child;
  double? borderWidth;
  Color? borderColor;
  double? radius;
  double? radiusTopLeft;
  double? radiusTopRight;
  double? radiusBottomLeft;
  double? radiusBottomRight;
  EdgeInsetsGeometry? margin;
  EdgeInsetsGeometry? padding;
  Color? color;
  AlignmentGeometry? alignment;
  bool? enableShadow;
  Color? shadowColor;
  Offset? shadowOffset;
  double? spreadRadius;
  double? blurRadius;
  VoidCallback? onTap;
  bool? debug;
  ZZOuterRadiusWidget({
    super.key,
    required this.child,
    this.borderWidth,
    this.borderColor,
    this.radius,
    this.radiusTopLeft,
    this.radiusTopRight,
    this.radiusBottomLeft,
    this.radiusBottomRight,
    this.margin,
    this.padding,
    this.color,
    this.alignment,
    this.enableShadow,
    this.shadowColor,
    this.shadowOffset,
    this.spreadRadius,
    this.blurRadius,
    this.onTap,
    this.debug,
  });

  @override
  Widget build(BuildContext context) {
    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: _outerBorderRadious(),
      );
    } else {
      return _outerBorderRadious();
    }
  }

  Widget _outerBorderRadious() {
    return Container(
      alignment: alignment,
      decoration: BoxDecoration(
          boxShadow: enableShadow == true
              ? [
                  BoxShadow(
                    color: shadowColor ?? Colors.black.withAlpha(10),
                    spreadRadius: spreadRadius ?? 5.0, // 阴影的大小
                    blurRadius: blurRadius ?? 7.0, // 阴影的模糊程度
                    offset: shadowOffset ?? const Offset(2, 2),
                  )
                ]
              : null,
          color: color ?? Colors.transparent,
          borderRadius: radius != null
              ? BorderRadius.all(Radius.circular(radius ?? 0))
              : ((radiusTopLeft != null ||
                      radiusTopRight != null ||
                      radiusBottomLeft != null ||
                      radiusBottomRight != null)
                  ? BorderRadius.only(
                      topLeft: Radius.circular(radiusTopLeft ?? 0),
                      topRight: Radius.circular(radiusTopRight ?? 0),
                      bottomLeft: Radius.circular(radiusBottomLeft ?? 0),
                      bottomRight: Radius.circular(radiusBottomRight ?? 0),
                    )
                  : null),
          border: (borderColor != null && borderWidth != null)
              ? Border.all(
                  color: borderColor ?? Colors.transparent,
                  width: borderWidth ?? 0)
              : null),
      margin: margin,
      padding: padding,
      child: ClipRRect(
        borderRadius: radius != null
            ? BorderRadius.all(Radius.circular(radius! - 2.w))
            : (BorderRadius.only(
                topLeft: Radius.circular(radiusTopLeft ?? 0),
                topRight: Radius.circular(radiusTopRight ?? 0),
                bottomLeft: Radius.circular(radiusBottomLeft ?? 0),
                bottomRight: Radius.circular(radiusBottomRight ?? 0),
              )),
        child: Container(
          color: debug == true ? Colors.amber : Colors.transparent,
          margin: EdgeInsets.zero,
          child: child,
        ),
      ),
    );
  }
}
