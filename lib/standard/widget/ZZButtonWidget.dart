// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable, file_names

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zzkit_flutter/util/core/ZZConst.dart';
import 'package:zzkit_flutter/util/core/ZZManager.dart';

class ZZButtonWidget extends StatelessWidget {
  String? title;
  double? height;
  EdgeInsetsGeometry? margin;
  TextStyle? style;
  double? radius;
  Color? backgroundColor;
  Color? disableBackgroundColor;
  Gradient? gradient;
  Gradient? disableGradient;
  bool? enable = true;
  VoidCallback? onTap;

  ZZButtonWidget({
    super.key,
    this.title,
    this.height,
    this.margin,
    this.style,
    this.radius,
    this.backgroundColor,
    this.disableBackgroundColor,
    this.gradient,
    this.disableGradient,
    this.enable = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (onTap != null) {
      return GestureDetector(
        onTap: () {
          onTap!();
        },
        child: _button(),
      );
    }
    return _button();
  }

  Container _button() {
    if (backgroundColor == null &&
        disableBackgroundColor == null &&
        gradient == null &&
        disableGradient == null) {
      gradient = ZZColor.gradientOrangeEnabled;
      disableGradient = ZZColor.gradientOrangeDisabled;
    }
    return Container(
      height: height ?? 48.w,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(radius ?? 4.w)),
          color: enable == true ? backgroundColor : disableBackgroundColor,
          gradient: enable == true ? gradient : disableGradient),
      margin: margin,
      child: Center(
        child: Text(
          title ?? "",
          style: style ??
              ZZ.textStyle(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
    );
  }
}
