import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zzkit_flutter/r.dart';
import 'package:zzkit_flutter/deprecated/list/widget/zz_base_brick.dart';
import 'package:zzkit_flutter/util/zz_const.dart';
import 'package:zzkit_flutter/util/zz_manager.dart';

enum ZZPlaceholderType { nodata, nocoupon, nonetwork }

class ZZPlaceholderBrick extends ZZBaseBrick<ZZPlaceholderBrickObject> {
  @override
  Widget build(BuildContext context) {
    return _widget();
  }

  Widget _widget() {
    String? text;
    Image? image;
    if (object?.placeholderType != null) {
      if (object?.placeholderType == ZZPlaceholderType.nodata) {
        text = "没有相关数据";
        image = ZZ.image(
          R.assetsImgIcPlaceholderNoData,
          bundleName: zzBundleName,
        );
      } else if (object?.placeholderType == ZZPlaceholderType.nocoupon) {
        text = "没有优惠券";
        image = ZZ.image(
          R.assetsImgIcPlaceholderNoCoupon,
          bundleName: zzBundleName,
        );
      } else if (object?.placeholderType == ZZPlaceholderType.nonetwork) {
        text = "没有网络";
        image = ZZ.image(
          R.assetsImgIcPlaceholderNoNetwork,
          bundleName: zzBundleName,
        );
      }
    }
    return Container(
      color: object?.bgColor ?? Colors.white,
      child: Column(
        children: [
          Container(
            margin:
                object?.imageEdgeInsets ??
                EdgeInsets.only(top: 36.w, left: 36.w, right: 36.w),
            child:
                (object?.image ?? image) ??
                ZZ.image(
                  R.assetsImgIcPlaceholderNoData,
                  bundleName: zzBundleName,
                )!,
          ),
          ZZ.isNullOrEmpty(object?.text) && ZZ.isNullOrEmpty(text)
              ? Container()
              : Container(
                margin:
                    object?.textEdgeInsets ??
                    EdgeInsets.only(top: 36.w, bottom: 36.w),
                child: Text(
                  (object?.text ?? text) ?? "",
                  style:
                      object?.textStyle ??
                      ZZ.textStyle(color: Colors.black54, fontSize: 12.sp),
                ),
              ),
        ],
      ),
    );
  }
}

class ZZPlaceholderBrickObject extends ZZBaseBrickObject<ZZPlaceholderBrick> {
  ZZPlaceholderType? placeholderType;
  Image? image;
  String? text;
  TextStyle? textStyle;
  EdgeInsetsGeometry? imageEdgeInsets;
  EdgeInsetsGeometry? textEdgeInsets;
  Color? bgColor;
}
