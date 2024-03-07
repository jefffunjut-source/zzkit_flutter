// ignore_for_file: overridden_fields, annotate_overrides, unnecessary_overrides, file_names
library zzkit;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zzkit_flutter/standard/widget/ZZNoDataWidget.dart';
import 'package:zzkit_flutter/util/core/ZZAppConsts.dart';
import 'package:zzkit_flutter/util/core/ZZAppManager.dart';

// ignore: must_be_immutable
class ZZBaseScaffold extends Scaffold {
  final PreferredSizeWidget? appBar;

  final Widget? body;

  final Color? backgroundColor;

  final Widget? floatingActionButton;

  VoidCallback? retryCallback;

  // 监听返回键
  PopInvokedCallback? popInvokedCallback;

  // 无数据状态
  bool? nodata;
  bool? nodataNavigatorHidden;
  String? nodataHintText;

  // 是否保留底部SafeArea区域
  bool? resizeToAvoidBottomInset;

  // 是否保留底部SafeArea区域
  bool? safeAreaBottom;

  bool? hiddenBackbtn;
  bool? isHomePage;

  ZZBaseScaffold({
    super.key,
    this.appBar,
    this.body,
    this.backgroundColor = Colors.white,
    this.floatingActionButton,
    this.retryCallback,
    this.popInvokedCallback,
    this.nodata = false,
    this.nodataNavigatorHidden = false,
    this.nodataHintText,
    this.hiddenBackbtn = false,
    this.resizeToAvoidBottomInset = false,
    this.safeAreaBottom = true,
    this.isHomePage,
  }) : super(
          appBar: appBar,
          body: body,
          backgroundColor: backgroundColor,
          resizeToAvoidBottomInset: resizeToAvoidBottomInset,
          floatingActionButton: floatingActionButton,
        );

  @override
  ScaffoldState createState() {
    return ZZBaseScaffoldState();
  }
}

class ZZBaseScaffoldState extends ScaffoldState {
  bool? nodata;
  bool? nodataNavigatorHidden;
  String? nodataHintText;
  PopInvokedCallback? popInvokedCallback;
  VoidCallback? retryCallback;
  bool? safeAreaBottom;
  bool? hiddenBackbtn;
  bool? isHomePage;
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  void syncData() {
    if (widget is ZZBaseScaffold) {
      ZZBaseScaffold thisWidget = widget as ZZBaseScaffold;
      nodata = thisWidget.nodata;
      nodataNavigatorHidden = thisWidget.nodataNavigatorHidden;
      nodataHintText = thisWidget.nodataHintText;
      popInvokedCallback = thisWidget.popInvokedCallback;
      retryCallback = thisWidget.retryCallback;
      safeAreaBottom = thisWidget.safeAreaBottom;
      hiddenBackbtn = thisWidget.hiddenBackbtn;
      isHomePage = thisWidget.isHomePage;
    } else {
      assert(false, "this is not ZZBaseScaffold");
    }
  }

  @override
  Widget build(BuildContext context) {
    syncData();
    return Container(
      color: widget.backgroundColor,
      child: SafeArea(
          top: false,
          bottom: safeAreaBottom!,
          child: Stack(alignment: Alignment.center, children: [
            PopScope(
                canPop: true,
                onPopInvoked: popInvokedCallback,
                child: super.build(context)),
            nodata ?? false
                ? Positioned(
                    left: 0,
                    top: nodataNavigatorHidden! ? 0 : zzStatusBarHeight + 48.w,
                    right: 0,
                    bottom: 0,
                    child: ZZNoDataWidget(
                      nodata: nodata,
                      hintText: nodataHintText,
                    ))
                : ZZ.empty()
          ])),
    );
  }
}
