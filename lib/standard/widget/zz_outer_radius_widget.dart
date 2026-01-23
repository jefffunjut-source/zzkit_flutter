import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:math';

class ZZOuterRadiusWidget extends StatefulWidget {
  final Widget child;
  final double? borderWidth;
  final Color? borderColor;
  final double? radius;
  final double? radiusTopLeft;
  final double? radiusTopRight;
  final double? radiusBottomLeft;
  final double? radiusBottomRight;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final AlignmentGeometry? alignment;
  final bool? enableShadow;
  final Color? shadowColor;
  final Offset? shadowOffset;
  final double? spreadRadius;
  final double? blurRadius;
  final VoidCallback? onTap;
  final bool? debug;

  const ZZOuterRadiusWidget({
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
  State<ZZOuterRadiusWidget> createState() => _ZZOuterRadiusWidgetState();
}

class _ZZOuterRadiusWidgetState extends State<ZZOuterRadiusWidget> {
  @override
  Widget build(BuildContext context) {
    final container = RepaintBoundary(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        alignment: widget.alignment,
        margin: widget.margin,
        padding: widget.padding,
        decoration: BoxDecoration(
          color: widget.color ?? Colors.transparent,
          borderRadius: _getBorderRadius(),
          border:
              (widget.borderColor != null && widget.borderWidth != null)
                  ? Border.all(
                    color: widget.borderColor!,
                    width: widget.borderWidth!,
                  )
                  : null,
          boxShadow:
              widget.enableShadow == true
                  ? [
                    BoxShadow(
                      color: widget.shadowColor ?? Colors.black.withAlpha(10),
                      spreadRadius: widget.spreadRadius ?? 5.0,
                      blurRadius: widget.blurRadius ?? 7.0,
                      offset: widget.shadowOffset ?? const Offset(2, 2),
                    ),
                  ]
                  : null,
        ),
        child: ClipRRect(
          borderRadius: _getClipRadius(),
          child: Container(
            color: widget.debug == true ? Colors.amber : Colors.transparent,
            child: widget.child,
          ),
        ),
      ),
    );

    if (widget.onTap != null) {
      return GestureDetector(onTap: widget.onTap, child: container);
    } else {
      return container;
    }
  }

  BorderRadiusGeometry _getBorderRadius() {
    if (widget.radius != null)
      return BorderRadius.all(Radius.circular(widget.radius!));
    if (widget.radiusTopLeft != null ||
        widget.radiusTopRight != null ||
        widget.radiusBottomLeft != null ||
        widget.radiusBottomRight != null) {
      return BorderRadius.only(
        topLeft: Radius.circular(widget.radiusTopLeft ?? 0),
        topRight: Radius.circular(widget.radiusTopRight ?? 0),
        bottomLeft: Radius.circular(widget.radiusBottomLeft ?? 0),
        bottomRight: Radius.circular(widget.radiusBottomRight ?? 0),
      );
    }
    return BorderRadius.zero;
  }

  BorderRadiusGeometry _getClipRadius() {
    final border = _getBorderRadius();
    if (border is BorderRadius) {
      return BorderRadius.only(
        topLeft: Radius.circular(max(0, border.topLeft.x - 2.w)),
        topRight: Radius.circular(max(0, border.topRight.x - 2.w)),
        bottomLeft: Radius.circular(max(0, border.bottomLeft.x - 2.w)),
        bottomRight: Radius.circular(max(0, border.bottomRight.x - 2.w)),
      );
    }
    return border;
  }
}
