// ignore_for_file: file_names, must_be_immutable, no_logic_in_create_state
library zzkit;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zzkit_flutter/r.dart';
import 'package:zzkit_flutter/util/core/ZZConst.dart';
import 'package:zzkit_flutter/util/core/ZZManager.dart';

class ZZNoticeController extends GetxController {
  RxString noticeNumber = "".obs;
  RxBool highlighted = false.obs;
}

class ZZNoticeWidget extends StatefulWidget {
  double? width;
  double? height;
  Image? noticeImage;
  Image? highlightedNoticeImage;
  double? noticeXFromCenter;
  double? noticeYFromCenter;
  Color? backgroundColor;
  Color? pointBackgroundColor;
  Color? highlightedPointBackgroundColor;
  TextStyle? textStyle;
  TextStyle? highlightedTextStyle;
  Color? borderColor;
  Color? highlightedBorderColor;
  ZZNoticeWidget({
    this.width,
    this.height,
    this.noticeImage,
    this.highlightedNoticeImage,
    this.noticeXFromCenter,
    this.noticeYFromCenter,
    this.backgroundColor,
    this.pointBackgroundColor,
    this.highlightedPointBackgroundColor,
    this.textStyle,
    this.highlightedTextStyle,
    this.borderColor,
    this.highlightedBorderColor,
    super.key,
  });

  @override
  State<StatefulWidget> createState() {
    return ZZNoticeWidgetState();
  }
}

class ZZNoticeWidgetState extends State<ZZNoticeWidget> {
  late double width;
  late double height;

  @override
  void initState() {
    super.initState();
    width = widget.width ?? 64.w;
    height = widget.height ?? 44.w;
  }

  @override
  Widget build(BuildContext context) {
    ZZNoticeController controller = Get.find();
    return Obx(() => Container(
          color: widget.backgroundColor,
          width: width,
          height: height,
          child: Stack(
            alignment: Alignment.center,
            children: [
              (widget.highlightedNoticeImage != null &&
                      widget.noticeImage != null)
                  ? controller.highlighted.value
                      ? widget.highlightedNoticeImage!
                      : widget.noticeImage!
                  : widget.noticeImage ??
                      ZZ.image(R.assetsImgIcNavNotice,
                          bundleName: zzBundleName)!,
              controller.noticeNumber.value.isNotEmpty
                  ? Positioned(
                      left: width / 2 + (widget.noticeXFromCenter ?? 2),
                      top: height / 2 - (widget.noticeYFromCenter ?? 16),
                      child: Container(
                        width: 12.w,
                        height: 12.w,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(88.w),
                            color: controller.highlighted.value
                                ? widget.highlightedPointBackgroundColor
                                : (widget.pointBackgroundColor ?? Colors.red),
                            border: Border.all(
                                color: controller.highlighted.value
                                    ? (widget.highlightedBorderColor ??
                                        Colors.red)
                                    : (widget.borderColor ?? Colors.red),
                                width: 1.w)),
                        padding: EdgeInsets.symmetric(horizontal: 2.w),
                        alignment: Alignment.center,
                        child: Text(
                          controller.noticeNumber.value.isNumericOnly &&
                                  controller.noticeNumber.value.length > 2
                              ? "···"
                              : controller.noticeNumber.value,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: controller.highlighted.value
                              ? widget.highlightedTextStyle
                              : (widget.textStyle ??
                                  ZZ.textStyle(
                                      color: Colors.white, fontSize: 10.sp)),
                        ),
                      ),
                    )
                  : Container()
            ],
          ),
        ));
  }
}
