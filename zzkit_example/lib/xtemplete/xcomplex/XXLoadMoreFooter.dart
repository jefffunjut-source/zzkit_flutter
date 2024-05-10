// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
// ignore_for_file: file_names, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:zzkit_flutter/standard/widget/ZZCircleIndicator.dart';
import 'package:get/get.dart';
import 'package:zzkit_flutter/util/core/ZZConst.dart';
import 'package:zzkit_flutter/util/core/ZZManager.dart';

enum XXLoadMoreStatus { notStart, loading, finishLoad, noMoreData }

class XXLoadMoreFooter extends StatefulWidget {
  final Future<XXLoadMoreStatus?> Function()? loadMoreBlock; // 定义 moreBlock 属性
  Color? bgColor;
  XXLoadMoreFooter({this.loadMoreBlock, this.bgColor, super.key});

  @override
  State<StatefulWidget> createState() {
    return XXLoadMoreFooterState();
  }
}

class XXLoadMoreFooterState extends State<XXLoadMoreFooter> {
  Future<XXLoadMoreStatus?> Function()? loadMoreBlock;
  late Rx<XXLoadMoreStatus> status;
  int lastTime = 0;

  @override
  void initState() {
    super.initState();
    loadMoreBlock = widget.loadMoreBlock;
    status = XXLoadMoreStatus.notStart.obs;
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      onVisibilityChanged: (info) {
        if (!mounted) {
          return;
        }
        if (status.value == XXLoadMoreStatus.loading ||
            status.value == XXLoadMoreStatus.noMoreData) {
          return;
        }
        int current = DateTime.now().microsecondsSinceEpoch;
        if (current - lastTime > 6000) {
          lastTime = current;
        } else {
          return;
        }
        if (loadMoreBlock != null) {
          status.value = XXLoadMoreStatus.loading;
          loadMoreBlock!().then((value) {
            status.value = value ?? XXLoadMoreStatus.loading;
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
                status.value == XXLoadMoreStatus.noMoreData
                    ? Container()
                    : ZZCircleIndicator(
                        width: 16.w,
                        circleColor: Colors.grey,
                        circleWidth: 2.w,
                      ),
                Container(
                  padding: const EdgeInsets.all(10.0),
                  margin: EdgeInsets.only(left: 10.w),
                  child: Center(
                    child: Text(
                      status.value == XXLoadMoreStatus.noMoreData
                          ? "到底了"
                          : "加载中...",
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
