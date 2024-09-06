// ignore_for_file: file_names, must_be_immutable, no_logic_in_create_state
library zzkit;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zzkit_flutter/r.dart';
import 'package:zzkit_flutter/standard/widget/ZZOuterRadiusWidget.dart';
import 'package:zzkit_flutter/util/core/ZZConst.dart';
import 'package:zzkit_flutter/util/core/ZZManager.dart';

class ZZNoticeController extends GetxController {
  RxString noticeNumber = "".obs;
  RxBool highlighted = false.obs;
}

class ZZNoticeWidget extends StatefulWidget {
  Image? noticeImage;
  Image? highlightedNoticeImage;
  Color? pointBackgroundColor;
  Color? highlightedPointBackgroundColor;
  TextStyle? textStyle;
  TextStyle? highlightedTextStyle;
  Color? borderColor;
  Color? highlightedBorderColor;
  double? width;
  double? height;
  Color? backgroundColor;
  double? noticeXFromCenter;
  double? noticeYFromCenter;
  ZZNoticeWidget({
    required this.noticeImage,
    required this.highlightedNoticeImage,
    required this.pointBackgroundColor,
    required this.highlightedPointBackgroundColor,
    required this.textStyle,
    required this.highlightedTextStyle,
    required this.borderColor,
    required this.highlightedBorderColor,
    this.width,
    this.height,
    this.backgroundColor,
    this.noticeXFromCenter,
    this.noticeYFromCenter,
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
              controller.noticeNumber.value.trim().isNotEmpty
                  ? Positioned(
                      left: width / 2 + (widget.noticeXFromCenter ?? 2),
                      top: height / 2 - (widget.noticeYFromCenter ?? 16),
                      child: ZZOuterRadiusWidget(
                          radius: 7.w,
                          color: controller.highlighted.value
                              ? widget.highlightedPointBackgroundColor
                              : (widget.pointBackgroundColor ?? Colors.red),
                          borderColor: controller.highlighted.value
                              ? (widget.highlightedBorderColor ?? Colors.red)
                              : (widget.borderColor ?? Colors.red),
                          child: Container(
                            height: 14.w,
                            width:
                                controller.noticeNumber.value.trim().length <= 1
                                    ? 14.w
                                    : null,
                            padding:
                                controller.noticeNumber.value.trim().length <= 1
                                    ? null
                                    : EdgeInsets.symmetric(horizontal: 4.w),
                            alignment: Alignment.center,
                            child: Text(
                              controller.noticeNumber.value.trim().length > 2
                                  ? "···"
                                  : controller.noticeNumber.value.trim(),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.clip,
                              style: controller.highlighted.value
                                  ? widget.highlightedTextStyle
                                  : (widget.textStyle ??
                                      ZZ.textStyle(
                                          color: Colors.white,
                                          fontSize: 10.sp)),
                            ),
                          )),
                    )
                  : Container()
            ],
          ),
        ));
  }
}
