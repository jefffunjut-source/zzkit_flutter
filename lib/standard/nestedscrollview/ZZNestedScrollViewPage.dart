// ignore_for_file: must_be_immutable, file_names

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_more_list/loading_more_list.dart';
import 'package:pull_to_refresh_notification/pull_to_refresh_notification.dart';
import 'package:zzkit_flutter/standard/nestedscrollview/ZZPullToRefreshHeader.dart';
import 'package:zzkit_flutter/standard/nestedscrollview/ZZTabItem.dart';
import 'package:zzkit_flutter/standard/scaffold/ZZBaseScaffold.dart';
import 'package:zzkit_flutter/util/ZZEvent.dart';
import 'package:zzkit_flutter/util/core/ZZAppConsts.dart';
import 'package:zzkit_flutter/util/core/ZZAppManager.dart';

class ZZNestedScrollViewPage extends StatefulWidget {
  String? name;
  Color? backgroundColor;
  List<SliverToBoxAdapter>? topWidgets;
  List<ZZTabItem> tabs;
  List<Widget> pages;
  Color? tabIndicatorColor;
  double? tabIndicatorRadius;
  Gradient? tabIndicatorGradient;
  EdgeInsetsGeometry? tabIndicatorPadding;
  double? tabIndicatorWeight;
  TextStyle? tabLabelStyle;
  TextStyle? tabUnselectedLabelStyle;
  bool? tabIsScrollable;
  TabAlignment? tabAlignment;
  ZZNestedScrollViewPage(
      {super.key,
      required this.name,
      required this.backgroundColor,
      required this.topWidgets,
      required this.tabs,
      required this.pages,
      this.tabIndicatorColor,
      this.tabIndicatorRadius,
      this.tabIndicatorGradient,
      this.tabIndicatorPadding,
      this.tabIndicatorWeight,
      this.tabLabelStyle,
      this.tabUnselectedLabelStyle,
      this.tabIsScrollable,
      this.tabAlignment});

  @override
  ZZNestedScrollViewPageState createState() => ZZNestedScrollViewPageState();
}

class ZZNestedScrollViewPageState extends State<ZZNestedScrollViewPage>
    with TickerProviderStateMixin {
  final GlobalKey<NestedScrollViewState> _key =
      GlobalKey<NestedScrollViewState>();
  TabController? primaryTC;
  Map<int, double>? cachePixels;
  static bool inAnimating = false;

  @override
  void initState() {
    super.initState();
    primaryTC = TabController(length: widget.tabs.length, vsync: this);
    widget.tabIndicatorColor ??= Colors.orange.shade900;
    widget.tabIndicatorWeight ??= 2.w;
    widget.tabIndicatorRadius ??= 1.w;
    widget.tabAlignment ??= TabAlignment.start;
    widget.tabLabelStyle ??= ZZ.textStyle(
        color: Colors.orange.shade900, fontSize: 14.sp, bold: true);
    widget.tabUnselectedLabelStyle ??=
        ZZ.textStyle(color: Colors.black87, fontSize: 12.sp, bold: false);
  }

  @override
  void dispose() {
    primaryTC?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ZZBaseScaffold(
      safeAreaBottom: false,
      backgroundColor: widget.backgroundColor,
      body: _buildScaffoldBody(),
    );
  }

  Widget _buildScaffoldBody() {
    return PullToRefreshNotification(
      color: Colors.white,
      onRefresh: () {
        zzEventBus.fire(ZZEventNestedScrollViewRefresh(key: widget.name));
        return Future(() => true);
      },
      child: GlowNotificationWidget(
        NestedScrollView(
          key: _key,
          headerSliverBuilder: (BuildContext c, bool f) {
            return <Widget>[
              PullToRefreshContainer(
                (PullToRefreshScrollNotificationInfo? info) {
                  return SliverToBoxAdapter(
                    child: ZZPullToRefreshHeader(info),
                  );
                },
              )
            ];
          },
          body: Column(
            children: <Widget>[
              Container(
                  color: Colors.white,
                  child: ZZ.tabbarUnderline(
                      indicatorColor: widget.tabIndicatorColor,
                      indicatorWeight: widget.tabIndicatorWeight,
                      indicatorRadius: widget.tabIndicatorRadius,
                      tabAlignment: widget.tabAlignment,
                      labelStyle: widget.tabLabelStyle,
                      unselectedLabelStyle: widget.tabUnselectedLabelStyle,
                      onTap: (value) {
                        _dealScroll();
                      },
                      controller: primaryTC,
                      tabs: widget.tabs.map((e) => e.title ?? "").toList())),
              Expanded(
                child: _tabBarView(),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _tabBarView() {
    return TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: primaryTC,
        children: widget.pages);
  }

  void _dealScroll() {
    if (inAnimating) {
      return;
    }
    inAnimating = true;
    int lastPage = primaryTC!.previousIndex;
    int currentPage = primaryTC!.index;
    int index = 0;
    _key.currentState?.innerController.positions.forEach((element) {
      if (lastPage == index) {
        // save
        cachePixels!.update(lastPage, (value) => element.pixels);
      }
      index++;
    });
    double? currentPagePixel = cachePixels![currentPage];
    if (currentPagePixel != null) {
      _key.currentState?.innerController.jumpTo(max(currentPagePixel, 0.01));
    }
    inAnimating = false;
  }
}
