// ignore_for_file: file_names, depend_on_referenced_packages, non_constant_identifier_names, unused_local_variable
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:loading_more_list/loading_more_list.dart';
import 'package:pull_to_refresh_notification/pull_to_refresh_notification.dart';
import 'package:zzkit_example/xtemplete/xcomplex/XXLatestSubPage.dart';
import 'package:zzkit_example/xtemplete/xcomplex/XXPullToRefreshHeader.dart';

class XXLatestPage extends StatefulWidget {
  const XXLatestPage({super.key});

  @override
  XXLatestPageState createState() => XXLatestPageState();
}

class XXLatestPageState extends State<XXLatestPage>
    with TickerProviderStateMixin {
  late final TabController primaryTC;
  final GlobalKey<ExtendedNestedScrollViewState> _key =
      GlobalKey<ExtendedNestedScrollViewState>();
  final int length1 = 60;
  final int length2 = 100;
  DateTime lastRefreshTime = DateTime.now();
  Map<int, double> cachePixels = {};
  List<String> tabs = ["Tab0", "Tab1", "Tab2", "Tab3"];
  static bool inAnimating = false;
  late ScrollController scrollController;

  void dealScroll() {
    if (inAnimating) {
      return;
    }
    inAnimating = true;
    int lastPage = primaryTC.previousIndex;
    int currentPage = primaryTC.index;
    debugPrint(
        "outterPositions: ${_key.currentState?.outerController.positions}");
    debugPrint("innerPositions: ${_key.currentState?.innerPositions}");
    int index = 0;
    _key.currentState?.innerPositions.forEach((element) {
      debugPrint("innerPositions: $index = ${element.pixels}");
      if (lastPage == index) {
        // save
        cachePixels.update(lastPage, (value) => element.pixels);
      }
      index++;
    });
    double? currentPagePixel = cachePixels[currentPage];
    if (currentPagePixel != null) {
      _key.currentState?.innerController.jumpTo(max(currentPagePixel, 0.01));
    }
    inAnimating = false;
  }

  @override
  void initState() {
    super.initState();
    primaryTC = TabController(length: tabs.length, vsync: this);
    int index = 0;
    for (var element in tabs) {
      cachePixels.putIfAbsent(index, () => 0.0);
      index++;
    }
    scrollController = ScrollController()
      ..addListener(() {
        debugPrint("scroll:${scrollController.offset}");
      });
  }

  @override
  void dispose() {
    primaryTC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildScaffoldBody(),
    );
  }

  Widget _buildScaffoldBody() {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    final double pinnedHeaderHeight =
        //statusBar height
        statusBarHeight +
            //pinned SliverAppBar height in header
            kToolbarHeight -
            kToolbarHeight;
    return PullToRefreshNotification(
      color: Colors.blue,
      onRefresh: () => Future<bool>.delayed(const Duration(seconds: 1), () {
        setState(() {
          lastRefreshTime = DateTime.now();
        });
        return true;
      }),
      maxDragOffset: maxDragOffset,
      child: GlowNotificationWidget(
        // 这里的ExtendedNestedScrollView完全可以改成NestedScrollView
        ExtendedNestedScrollView(
          controller: scrollController,
          key: _key,
          headerSliverBuilder: (BuildContext c, bool f) {
            return <Widget>[
              PullToRefreshContainer(
                (PullToRefreshScrollNotificationInfo? info) {
                  return SliverToBoxAdapter(
                    child: XXPullToRefreshHeader(info, lastRefreshTime),
                  );
                },
              ),
              SliverToBoxAdapter(
                child: Container(
                  color: Colors.tealAccent,
                  alignment: Alignment.center,
                  height: 60,
                  child: const Text('banner'),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  color: Colors.indigoAccent,
                  alignment: Alignment.center,
                  height: 140,
                  child: const Text('guider'),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  color: Colors.green,
                  alignment: Alignment.center,
                  height: 90,
                  child: const Text('icons'),
                ),
              ),
            ];
          },
          pinnedHeaderSliverHeightBuilder: () {
            return pinnedHeaderHeight;
          },
          body: Column(
            children: <Widget>[
              TabBar(
                onTap: (value) {
                  dealScroll();
                },
                controller: primaryTC,
                labelColor: Colors.blue,
                indicatorColor: Colors.blue,
                indicatorSize: TabBarIndicatorSize.label,
                indicatorWeight: 2.0,
                isScrollable: false,
                unselectedLabelColor: Colors.grey,
                tabs: tabs.map((txt) => Tab(text: txt)).toList(),
              ),
              Expanded(
                child: tabBarView(),
                // child: singleView(name),
              )
            ],
          ),
        ),
      ),
    );
  }

  TabBarView tabBarView() {
    return TabBarView(
      physics: const NeverScrollableScrollPhysics(),
      controller: primaryTC,
      children: tabs
          .map((txt) => XXLatestSubPage(
                key: PageStorageKey<String>(txt),
              ))
          .toList(),
    );
  }
}
