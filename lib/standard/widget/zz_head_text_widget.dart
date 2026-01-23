import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zzkit_flutter/util/core/zz_const.dart';
import 'package:zzkit_flutter/util/core/zz_manager.dart';

class ZZHeadTextWidget extends StatelessWidget {
  /// Left head text
  final String? head;

  /// Custom head widget (higher priority than [head])
  final Widget? headWidget;

  /// Right content text
  final String? text;

  /// Fixed width for head text (ignored when [headWidget] is provided)
  final double? headWidth;

  /// Spacing between head and content
  final double? spacing;

  /// Bottom spacing for the whole row
  final double? runningSpace;

  /// Text style for head text
  final TextStyle? headStyle;

  /// Text style for content text
  final TextStyle? textStyle;

  const ZZHeadTextWidget({
    super.key,
    this.head,
    this.headWidget,
    this.text,
    this.headWidth,
    this.spacing,
    this.runningSpace,
    this.headStyle,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final double effectiveSpacing = spacing ?? 2.w;
    final double effectiveBottomSpace = runningSpace ?? 10.w;

    return Padding(
      padding: EdgeInsets.only(bottom: effectiveBottomSpace),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(right: effectiveSpacing),
            width: headWidget != null ? null : (headWidth ?? 20.w),
            child: headWidget ?? _buildHeadText(),
          ),
          Expanded(child: _buildContentText()),
        ],
      ),
    );
  }

  Widget _buildHeadText() {
    return Text(
      head ?? '',
      style:
          headStyle ??
          ZZ.textStyle(
            color: Colors.black,
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
            height: 1.6,
          ),
    );
  }

  Widget _buildContentText() {
    return Text(
      text ?? '',
      textAlign: TextAlign.left,
      style:
          textStyle ??
          ZZ.textStyle(
            color: Colors.black,
            fontSize: 14.sp,
            fontWeight: FontWeight.normal,
            height: 1.6,
          ),
    );
  }
}
