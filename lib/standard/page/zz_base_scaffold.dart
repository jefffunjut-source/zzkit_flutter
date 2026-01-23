import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zzkit_flutter/standard/widget/zz_no_data_widget.dart';
import 'package:zzkit_flutter/util/core/zz_const.dart';

class ZZBaseScaffold extends Scaffold {
  // 不需要再重复声明 appBar、body、floatingActionButton 等
  final bool nodata;
  final bool nodataNavigatorHidden;
  final String? nodataHintText;
  final bool safeAreaBottom;
  final bool hiddenBackbtn;
  final bool? isHomePage;
  final VoidCallback? retryCallback;
  final PopInvokedWithResultCallback? popInvokedCallback;

  const ZZBaseScaffold({
    super.key,
    super.appBar,
    super.body,
    super.backgroundColor = Colors.white,
    super.floatingActionButton,
    super.floatingActionButtonLocation,
    this.retryCallback,
    this.popInvokedCallback,
    this.nodata = false,
    this.nodataNavigatorHidden = false,
    this.nodataHintText,
    this.hiddenBackbtn = false,
    this.safeAreaBottom = true,
    this.isHomePage,
    super.resizeToAvoidBottomInset = false,
  });

  @override
  ScaffoldState createState() => _ZZBaseScaffoldState();
}

class _ZZBaseScaffoldState extends ScaffoldState {
  bool? nodata;
  bool? nodataNavigatorHidden;
  String? nodataHintText;
  PopInvokedWithResultCallback? popInvokedCallback;
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
        bottom: safeAreaBottom ?? false,
        child: Stack(
          alignment: Alignment.center,
          children: [
            PopScope(
              canPop: true,
              onPopInvokedWithResult: popInvokedCallback,
              child: super.build(context),
            ),
            nodata ?? false
                ? Positioned(
                  left: 0,
                  top: nodataNavigatorHidden! ? 0 : zzStatusBarHeight + 48.w,
                  right: 0,
                  bottom: 0,
                  child: ZZNoDataWidget(hintText: nodataHintText),
                )
                : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}

class ZZFloatingActionButtonLocation extends FloatingActionButtonLocation {
  final double offsetX;
  final double offsetY;

  const ZZFloatingActionButtonLocation(this.offsetX, this.offsetY);

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    final double x = scaffoldGeometry.scaffoldSize.width - offsetX;
    final double y =
        scaffoldGeometry.scaffoldSize.height -
        scaffoldGeometry.bottomSheetSize.height -
        offsetY;
    return Offset(x, y);
  }

  @override
  String toString() => 'FloatingActionButtonLocation.custom';
}
