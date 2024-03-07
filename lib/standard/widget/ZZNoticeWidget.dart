// ignore_for_file: file_names, must_be_immutable, no_logic_in_create_state
library zzkit;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zzkit_flutter/r.dart';
import 'package:zzkit_flutter/util/ZZExtension.dart';
import 'package:zzkit_flutter/util/core/ZZAppConsts.dart';
import 'package:zzkit_flutter/util/core/ZZAppManager.dart';

class ZZNoticeController extends GetxController {
  RxString noticeNumber = "".obs;
}

class ZZNoticeWidget extends StatefulWidget {
  double? width;
  double? height;
  Image? noticeImage;
  double? noticeXFromCenter;
  double? noticeYFromCenter;
  Color? backgroundColor;
  ZZNoticeWidget({
    this.width,
    this.height,
    this.noticeImage,
    this.noticeXFromCenter,
    this.noticeYFromCenter,
    this.backgroundColor,
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
    Get.lazyPut(() => ZZNoticeController());
    width = widget.width ?? 64.w;
    height = widget.height ?? 44.w;
  }

  @override
  Widget build(BuildContext context) {
    ZZNoticeController controller = Get.find();
    return Container(
      color: widget.backgroundColor,
      width: width,
      height: height,
      child: Stack(
        alignment: Alignment.center,
        children: [
          widget.noticeImage ??
              Image.asset(
                  R.assetsImgIcNavNotice.addPrefix(zzPackagePrefix) ?? ""),
          Obx(() => controller.noticeNumber.value.isNotEmpty
              ? Positioned(
                  left: width / 2 + (widget.noticeXFromCenter ?? 2),
                  top: height / 2 - (widget.noticeYFromCenter ?? 16),
                  child: Container(
                    height: 12.w,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(88.w),
                        color: zzColorRed,
                        border: Border.all(color: Colors.red, width: 1.w)),
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
                      style: ZZ.textStyle(color: Colors.white, fontSize: 10.sp),
                    ),
                  ),
                )
              : Container())
        ],
      ),
    );
  }
}
