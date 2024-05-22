// ignore_for_file: must_be_immutable, file_names, unused_local_variable, no_leading_underscores_for_local_identifiers

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:loading_more_list/loading_more_list.dart';
import 'package:pull_to_refresh_notification/pull_to_refresh_notification.dart';
import 'package:zzkit_flutter/r.dart';
import 'package:zzkit_flutter/standard/nestedscrollview/ZZPullToRefreshHeader.dart';
import 'package:zzkit_flutter/standard/nestedscrollview/ZZTabItem.dart';
import 'package:zzkit_flutter/standard/scaffold/ZZBaseScaffold.dart';
import 'package:zzkit_flutter/util/ZZEvent.dart';
import 'package:zzkit_flutter/util/ZZExtension.dart';
import 'package:zzkit_flutter/util/core/ZZConst.dart';
import 'package:zzkit_flutter/util/core/ZZManager.dart';

class ZZNestedScrollViewPage extends StatefulWidget {
  String? name;
  Color? backgroundColor;
  List<Widget>? topWidgets;
  List<ZZTabItem>? tabs;
  List<Widget>? pages;
  int? initialPageIndex;
  ZZCallback1Int? pageSelected;
  // 设置自定义的Tabbar
  List<Widget>? customizedTabs;
  RxInt? customizedTabIndex;
  // 使用通用的Tabbar，自定义一些属性
  Color? tabIndicatorColor;
  double? tabIndicatorRadius;
  Gradient? tabIndicatorGradient;
  EdgeInsetsGeometry? tabIndicatorPadding;
  double? tabIndicatorWeight;
  TextStyle? tabLabelStyle;
  TextStyle? tabUnselectedLabelStyle;
  bool? tabIsScrollable;
  TabAlignment? tabAlignment;
  // Tabbar Body滚动控制器
  ScrollController? scrollController;
  // Tabbar额外顶部高度
  RxDouble? tabBarExtraHeight;
  // NestedScrollView的global key
  GlobalKey<NestedScrollViewState>? globalKey;
  // ScrollTop
  bool? scrollTop;
  // OnRefresh
  VoidCallback? onRefresh;

  ZZNestedScrollViewPage({
    super.key,
    required this.name,
    required this.backgroundColor,
    required this.topWidgets,
    required this.tabs,
    required this.pages,
    this.initialPageIndex,
    this.pageSelected,
    this.customizedTabs,
    this.customizedTabIndex,
    this.tabIndicatorColor,
    this.tabIndicatorRadius,
    this.tabIndicatorGradient,
    this.tabIndicatorPadding,
    this.tabIndicatorWeight,
    this.tabLabelStyle,
    this.tabUnselectedLabelStyle,
    this.tabIsScrollable,
    this.tabAlignment,
    this.scrollController,
    this.tabBarExtraHeight,
    this.globalKey,
    this.scrollTop,
    this.onRefresh,
  });

  @override
  ZZNestedScrollViewPageState createState() => ZZNestedScrollViewPageState();
}

class ZZNestedScrollViewPageState extends State<ZZNestedScrollViewPage>
    with TickerProviderStateMixin {
  TabController? primaryTC;
  Map<int, double>? cachePixels;
  static bool inAnimating = false;
  late GlobalKey<NestedScrollViewState> key;
  bool showScrollTop = false;

  @override
  void initState() {
    super.initState();

    if (widget.globalKey != null) {
      key = widget.globalKey!;
    } else {
      key = GlobalKey<NestedScrollViewState>();
    }

    widget.tabIndicatorColor ??= Colors.orange.shade900;
    widget.tabIndicatorWeight ??= 2.w;
    widget.tabIndicatorRadius ??= 1.w;
    widget.tabAlignment ??= TabAlignment.start;
    widget.tabLabelStyle ??= ZZ.textStyle(
        color: Colors.orange.shade900,
        fontSize: 14.sp,
        fontWeight: FontWeight.bold);
    widget.tabUnselectedLabelStyle ??= ZZ.textStyle(
        color: Colors.black87, fontSize: 12.sp, fontWeight: FontWeight.bold);

    if (widget.scrollTop == true) {
      Future.delayed(const Duration(seconds: 5))
          .then((value) => _checkScrollTop());
    }
  }

  @override
  void dispose() {
    primaryTC?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _check();
    return ZZBaseScaffold(
      safeAreaBottom: false,
      backgroundColor: widget.backgroundColor,
      body: _buildScaffoldBody(),
      floatingActionButtonLocation:
          ZZFloatingActionButtonLocation(48.w, zzScreenHeight / 4.0),
      floatingActionButton: widget.scrollTop == true && showScrollTop
          ? FloatingActionButton(
              onPressed: () {
                setState(() {
                  showScrollTop = false;
                });
                key.currentState?.innerController.animateTo(
                  0.01,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.linear,
                );
              },
              elevation: 0,
              backgroundColor: Colors.transparent,
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.w)),
                child: ZZ.image(R.assetsImgIcScrollToTop,
                    bundleName: zzBundleName, width: 36.w, height: 36.w),
              ))
          : null,
    );
  }

  void _check() {
    if (widget.tabs != null && widget.pages != null) {
      primaryTC ??= TabController(
        length: widget.tabs!.length,
        vsync: this,
        initialIndex: widget.initialPageIndex ?? 0,
      );

      if (cachePixels == null) {
        cachePixels = {};
        int index = 0;
        for (var element in widget.tabs!) {
          cachePixels!.putIfAbsent(index, () => 0.0);
          index++;
        }
      }
    } else {
      if (primaryTC != null) {
        primaryTC?.dispose();
        primaryTC = null;
      }
      if (cachePixels != null) {
        cachePixels = null;
      }
    }
  }

  Widget _buildScaffoldBody() {
    return PullToRefreshNotification(
      color: Colors.white,
      onRefresh: () {
        if (widget.onRefresh != null) {
          widget.onRefresh!();
        }
        zzEventBus.fire(ZZEventNestedScrollViewRefresh(name: widget.name));
        return Future(() => true);
      },
      child: GlowNotificationWidget(
        NestedScrollView(
          controller: widget.scrollController,
          key: key,
          headerSliverBuilder: (BuildContext c, bool f) {
            if (widget.topWidgets != null) {
              return <Widget>[
                PullToRefreshContainer(
                  (PullToRefreshScrollNotificationInfo? info) {
                    return SliverToBoxAdapter(
                      child: ZZPullToRefreshHeader(info),
                    );
                  },
                )
              ].merge(widget.topWidgets!);
            }
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
              Container(color: Colors.white, child: _tabbar()),
              Expanded(
                child: _tabBarView(),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget? _tabbar() {
    Widget? _bar;
    if (widget.tabs != null) {
      if (widget.customizedTabs != null) {
        _bar = _customizedTabBar();
      } else {
        _bar = ZZ.tabbarUnderline(
            indicatorColor: widget.tabIndicatorColor,
            indicatorWeight: widget.tabIndicatorWeight,
            indicatorRadius: widget.tabIndicatorRadius,
            tabAlignment: widget.tabAlignment,
            labelStyle: widget.tabLabelStyle,
            unselectedLabelStyle: widget.tabUnselectedLabelStyle,
            onTap: (value) {
              _dealScroll();
              if (widget.pageSelected != null) {
                widget.pageSelected!(value);
              }
            },
            controller: primaryTC,
            tabs: widget.tabs!.map((e) => e.title ?? "").toList());
      }
    }
    if (widget.tabBarExtraHeight != null && _bar != null) {
      return Column(
        children: [
          SizedBox(
            width: 414.w,
            height: widget.tabBarExtraHeight!.value,
          ),
          _bar
        ],
      );
    }
    return _bar;
  }

  TabBar _customizedTabBar() {
    return TabBar(
      onTap: (value) {
        _dealScroll();
        if (widget.pageSelected != null) {
          widget.pageSelected!(value);
        }
        widget.customizedTabIndex?.value = value;
      },
      labelPadding: EdgeInsets.zero,
      tabAlignment: widget.tabAlignment ?? TabAlignment.start,
      isScrollable: true,
      tabs: widget.customizedTabs!,
      indicator: const BoxDecoration(
        color: Colors.transparent,
      ),
      indicatorWeight: widget.tabIndicatorWeight ?? 0,
      controller: primaryTC,
    );
  }

  Widget _tabBarView() {
    if (widget.pages != null) {
      return TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          controller: primaryTC,
          children: widget.pages!);
    }
    return Container();
  }

  void _dealScroll() {
    if (inAnimating) {
      return;
    }
    inAnimating = true;
    int lastPage = primaryTC!.previousIndex;
    int currentPage = primaryTC!.index;
    int index = 0;
    key.currentState?.innerController.positions.forEach((element) {
      if (lastPage == index) {
        // save
        cachePixels!.update(lastPage, (value) => element.pixels);
      }
      index++;
    });
    double? currentPagePixel = cachePixels![currentPage];
    if (currentPagePixel != null) {
      key.currentState?.innerController.jumpTo(max(currentPagePixel, 0.01));
    }
    debugPrint("currentPagePixel : $currentPagePixel");
    inAnimating = false;
  }

  void _checkScrollTop() {
    if (!inAnimating) {
      inAnimating = true;
      int lastPage = primaryTC!.previousIndex;
      int currentPage = primaryTC!.index;
      int index = 0;
      double currentPagePixel = 0;
      key.currentState?.innerController.positions.forEach((element) {
        if (lastPage == index) {
          currentPagePixel = element.pixels;
        }
        index++;
      });
      if (currentPagePixel > 2000) {
        if (showScrollTop != true) {
          setState(() {
            showScrollTop = true;
          });
        }
      } else {
        if (showScrollTop != false) {
          setState(() {
            showScrollTop = false;
          });
        }
      }
      inAnimating = false;
    }
    Future.delayed(const Duration(seconds: 3))
        .then((value) => _checkScrollTop());
  }
}
