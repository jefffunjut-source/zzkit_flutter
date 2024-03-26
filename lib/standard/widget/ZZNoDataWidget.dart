// ignore_for_file: must_be_immutable, file_names
library zzkit;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zzkit_flutter/r.dart';
import 'package:zzkit_flutter/util/core/ZZAppConsts.dart';
import 'package:zzkit_flutter/util/core/ZZAppManager.dart';

class ZZNoDataWidget extends StatelessWidget {
  bool? nodata;
  String? hintText;
  String? img;
  Color? bgColor;
  double paddingTop;
  double paddingBottom;
  double marginLeft;
  double marginRight;

  ZZNoDataWidget({
    super.key,
    this.nodata = false,
    this.bgColor,
    this.hintText,
    this.img,
    this.paddingTop = 144,
    this.paddingBottom = 0,
    this.marginLeft = 0,
    this.marginRight = 0,
  });

  @override
  Widget build(BuildContext context) {
    if (nodata!) {
      return Container(
        width: 414.w,
        margin: EdgeInsets.only(left: marginLeft, right: marginRight),
        child: Container(
          padding: EdgeInsets.only(
              top: paddingTop, left: 24.w, right: 24.w, bottom: paddingBottom),
          width: zzScreenWidth,
          color: bgColor ?? Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ZZ.image(R.assetsImgIcPlaceholderNoData,
                      bundleName: zzBundleName) ??
                  Container(),
              ZZ.space(height: 24.w),
              Text(
                hintText ?? "暂无数据",
                style: ZZ.textStyle(color: zzColorGrey66, fontSize: 16.sp),
                strutStyle: const StrutStyle(height: 1.5),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    } else {
      return ZZ.empty();
    }
  }
}
