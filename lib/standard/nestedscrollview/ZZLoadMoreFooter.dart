// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
// ignore_for_file: file_names, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:zzkit_flutter/standard/list/ZZBaseListPage.dart';
import 'package:zzkit_flutter/standard/widget/ZZCircleIndicator.dart';
import 'package:get/get.dart';
import 'package:zzkit_flutter/util/core/ZZConst.dart';
import 'package:zzkit_flutter/util/core/ZZManager.dart';

enum ZZLoadMoreStatus { notStart, loading, finishLoad, noMoreData }

class ZZLoadMoreFooter extends StatefulWidget {
  ZZBaseListController controller;
  final Future<ZZLoadMoreStatus?> Function()? loadMoreBlock; // 定义 moreBlock 属性
  Color? bgColor;
  final String? refreshingLoadingText;
  final String? refreshingNoDataText;
  ZZLoadMoreFooter(
      {required this.controller,
      this.loadMoreBlock,
      this.bgColor,
      this.refreshingLoadingText,
      this.refreshingNoDataText,
      super.key});

  @override
  State<StatefulWidget> createState() {
    return ZZLoadMoreFooterState();
  }
}

class ZZLoadMoreFooterState extends State<ZZLoadMoreFooter> {
  Future<ZZLoadMoreStatus?> Function()? loadMoreBlock;
  int lastTime = 0;

  @override
  void initState() {
    super.initState();
    loadMoreBlock = widget.loadMoreBlock;
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      onVisibilityChanged: (info) {
        if (!mounted) {
          return;
        }
        if (widget.controller.status.value == ZZLoadMoreStatus.loading ||
            widget.controller.status.value == ZZLoadMoreStatus.noMoreData) {
          return;
        }
        int current = DateTime.now().microsecondsSinceEpoch;
        if (current - lastTime > 6000) {
          lastTime = current;
        } else {
          return;
        }
        if (loadMoreBlock != null) {
          loadMoreBlock!().then((value) {
            widget.controller.status.value = value ?? ZZLoadMoreStatus.loading;
          });
        }
      },
      key: const PageStorageKey<String>("loadingmore"),
      child: Obx(() => Container(
            width: 414.w,
            height: 60.w,
            color: widget.bgColor ?? Colors.transparent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                widget.controller.status.value == ZZLoadMoreStatus.noMoreData
                    ? Container()
                    : ZZCircleIndicator(
                        width: 16.w,
                        circleColor: Colors.grey.shade300,
                        circleWidth: 2.w,
                      ),
                Container(
                  padding: const EdgeInsets.all(10.0),
                  margin: EdgeInsets.only(left: 10.w),
                  child: Center(
                    child: Text(
                      widget.controller.status.value ==
                              ZZLoadMoreStatus.noMoreData
                          ? (widget.refreshingNoDataText ?? zzFooterNoDataText)
                          : (widget.refreshingLoadingText ??
                              zzFooterLoadingText),
                      style: ZZ.textStyle(color: Colors.grey, fontSize: 12.sp),
                    ),
                  ),
                )
              ],
            ),
          )),
    );
  }
}
