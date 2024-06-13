// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zzkit_flutter/util/core/ZZConst.dart';
import 'package:zzkit_flutter/util/core/ZZManager.dart';

class ZZHeadTextWidget extends StatelessWidget {
  String? head;
  Widget? headWidget;
  String? text;
  double? headWidth;
  double? spacing;
  double? runningSpace;
  TextStyle? headStyle;
  TextStyle? textStyle;
  ZZHeadTextWidget({
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
    return Container(
      padding: EdgeInsets.only(bottom: runningSpace ?? 10.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(right: spacing ?? 2.w),
            color: Colors.transparent,
            width: headWidget != null ? null : (headWidth ?? 20.w),
            child: headWidget ??
                Text(
                  head ?? "",
                  style: headStyle ??
                      ZZ.textStyle(
                        color: Colors.black,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        height: 1.6,
                      ),
                ),
          ),
          Expanded(
            child: Text(
              text ?? "",
              textAlign: TextAlign.left,
              style: textStyle ??
                  ZZ.textStyle(
                    color: Colors.black,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.normal,
                    height: 1.6,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
