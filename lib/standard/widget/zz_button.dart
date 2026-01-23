import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zzkit_flutter/util/zz_const.dart';
import 'package:zzkit_flutter/util/zz_manager.dart';

class ZZButton extends StatelessWidget {
  /// Button text
  final String? title;

  /// Button height
  final double? height;

  /// Outer margin
  final EdgeInsetsGeometry? margin;

  /// Text style
  final TextStyle? style;

  /// Border radius
  final double? radius;

  /// Enabled background color (used when no gradient)
  final Color? backgroundColor;

  /// Disabled background color (used when no gradient)
  final Color? disableBackgroundColor;

  /// Enabled gradient
  final Gradient? gradient;

  /// Disabled gradient
  final Gradient? disableGradient;

  /// Whether button is enabled
  final bool enable;

  /// Tap callback
  final VoidCallback? onTap;

  const ZZButton({
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
    final Widget button = _buildButton();

    // Keep original behavior:
    // If onTap is null, no GestureDetector is applied
    if (onTap == null) {
      return button;
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: enable ? onTap : null,
      child: button,
    );
  }

  Widget _buildButton() {
    final bool useDefaultGradient =
        backgroundColor == null &&
        disableBackgroundColor == null &&
        gradient == null &&
        disableGradient == null;

    final Gradient? effectiveGradient =
        useDefaultGradient
            ? (enable
                ? ZZColor.gradientOrangeEnabled
                : ZZColor.gradientOrangeDisabled)
            : (enable ? gradient : disableGradient);

    final Color? effectiveColor =
        useDefaultGradient
            ? null
            : (enable ? backgroundColor : disableBackgroundColor);

    return Container(
      height: height ?? 48.w,
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius ?? 4.w),
        color: effectiveColor,
        gradient: effectiveGradient,
      ),
      alignment: Alignment.center,
      child: Text(
        title ?? '',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style:
            style ??
            ZZ.textStyle(
              color: Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}
