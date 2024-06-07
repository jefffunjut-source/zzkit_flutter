// ignore_for_file: must_be_immutable, file_names, unnecessary_overrides
library zzkit;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:zzkit_flutter/standard/list/ZZBaseListPage.dart';
import 'package:zzkit_flutter/standard/brick/common/ZZBaseBrick.dart';
import 'package:zzkit_flutter/standard/nestedscrollview/ZZLoadMoreFooter.dart';
import 'package:zzkit_flutter/standard/scaffold/ZZBaseScaffold.dart';
import 'package:zzkit_flutter/standard/widget/ZZPlaceholderWidget.dart';
import 'package:zzkit_flutter/util/ZZEvent.dart';
import 'package:zzkit_flutter/util/ZZExtension.dart';
import 'package:zzkit_flutter/util/core/ZZConst.dart';
import 'package:zzkit_flutter/util/core/ZZManager.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

typedef ZZApiRequestCallback<ZZAPIResponse> = Future<ZZAPIResponse> Function();

class ZZBaseWaterfallController extends ZZBaseListController {
  int crossAxisCount = 2;
  double? mainAxisSpacing = 0;
  double? crossAxisSpacing = 0;

  ZZBaseWaterfallController({
    required this.crossAxisCount,
    this.mainAxisSpacing,
    this.crossAxisSpacing,
    super.refreshType,
    super.enablePulldown,
    super.enablePullup,
    super.pageSize = 20,
    super.scrollController,
    super.showLoadingFirstPage,
    // 瀑布流不考虑shimmer动画，加载shimmer前无法预知git 高度
    super.refreshingIdleText,
    super.refreshingReleaseText,
    super.refreshingText,
    super.refreshingCompleteText,
    super.refreshingLoadingText,
    super.refreshingNoDataText,
    super.margin,
    super.padding,
    super.brickMargin,
    super.brickPadding,
    super.title,
    super.appBar,
    super.backgroundColor,
    super.secondBackgroundColor,
    super.safeAreaBottom,
    super.bottomWidget,
    super.nodataBgColor,
    super.parentName,
    super.enableTab,
    super.tabLength,
  }) : super();
}

class ZZBaseWaterfallPage<T> extends StatefulWidget {
  // 列表页控制器
  T controller;
  ZZBaseWaterfallPage({
    super.key,
    required this.controller,
  });

  @override
  ZZBaseWaterfallState createState() => ZZBaseWaterfallState<T>();
}

class ZZBaseWaterfallState<T> extends State<ZZBaseWaterfallPage>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  bool noMore = false;
  int lastTime = 0;
  TabController? tabController;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    ZZBaseWaterfallController controller = widget.controller;
    if (controller.enableTab == true && controller.tabController == null) {
      controller.tabController =
          TabController(length: controller.tabLength, vsync: this);
    }
    controller.initialize();
    if (controller.refreshType == ZZRefreshType.pulltorefresh) {
      zzEventBus.on<ZZEventNestedScrollViewRefresh>().listen((event) {
        if (event.name == controller.parentName) {
          _retrieveData(false);
        }
      });
    }
    _retrieveData(false);
  }

  @override
  Widget build(BuildContext context) {
    ZZBaseWaterfallController controller = widget.controller;
    super.build(context);
    return ZZBaseScaffold(
      backgroundColor: controller.backgroundColor,
      safeAreaBottom: controller.safeAreaBottom,
      appBar: controller.appBar ??
          (controller.title != null
              ? ZZ.appbar(
                  title: controller.title, leftIcon: ZZNavBarIcon.backblack)
              : null),
      body: controller.bottomWidget != null
          ? Column(
              children: [
                Expanded(child: _obxBodyWidget()),
                controller.bottomWidget!,
              ],
            )
          : _obxBodyWidget(),
    );
  }

  Widget _obxBodyWidget() {
    ZZBaseWaterfallController controller = widget.controller;
    return Obx(() => controller.nodata.value
        ? Center(
            child: ZZNoDataWidget(
              bgColor: controller.nodataBgColor ?? Colors.white,
              onReloadTap: () {
                ZZ.show();
                _retrieveData(false);
                Future.delayed(const Duration(seconds: 1))
                    .then((value) => ZZ.dismiss());
              },
            ),
          )
        : Container(
            color: controller.secondBackgroundColor,
            margin: controller.margin,
            padding: controller.padding,
            child: _homeBody(),
          ));
  }

  Widget _homeBody() {
    ZZBaseWaterfallController controller = widget.controller;
    if (controller.refreshType == ZZRefreshType.smartrefresh) {
      return SmartRefresher(
        controller: controller.refreshController,
        enablePullUp: controller.enablePullup ?? true,
        enablePullDown: controller.enablePulldown ?? true,
        header: ClassicHeader(
          idleIcon: null,
          refreshingIcon: null,
          completeIcon: null,
          releaseIcon: null,
          idleText: controller.refreshingIdleText,
          releaseText: controller.refreshingReleaseText,
          refreshingText: controller.refreshingText,
          completeText: controller.refreshingCompleteText,
        ),
        footer: ClassicFooter(
          loadingText: controller.refreshingLoadingText,
          noDataText: controller.refreshingNoDataText,
        ),
        onRefresh: () async {
          controller.refreshController.resetNoData();
          _retrieveData(false);
        },
        onLoading: () async {
          _retrieveData(true);
        },
        child: _customScrollView(ZZRefreshType.smartrefresh),
      );
    } else if (controller.refreshType == ZZRefreshType.pulltorefresh) {
      return _customScrollView(ZZRefreshType.pulltorefresh);
    }
    return Container();
  }

  Widget _customScrollView(ZZRefreshType refreshType) {
    ZZBaseWaterfallController controller = widget.controller;
    ScrollPhysics? physics = refreshType == ZZRefreshType.pulltorefresh
        ? const ClampingScrollPhysics()
        : null;
    late List<Widget> slivers = [];
    if (controller.dataSource.safeObjectAtIndex(0) is ZZBrickList) {
      controller.isWaterfallMultipleType = true;
      for (var element in controller.dataSource) {
        ZZBrickList list = element;
        slivers.add(SliverPadding(
          padding: list.padding ?? EdgeInsets.zero,
          sliver: SliverMasonryGrid.count(
            crossAxisCount: list.crossAxisCount ?? controller.crossAxisCount,
            mainAxisSpacing:
                list.mainAxisSpacing ?? controller.mainAxisSpacing ?? 0,
            crossAxisSpacing:
                list.crossAxisSpacing ?? controller.crossAxisSpacing ?? 0,
            childCount: list.dataSource.length,
            itemBuilder: (context, index) {
              ZZBaseBrickObject object = list.dataSource[index];
              return object.widget;
            },
          ),
        ));
      }
      if (refreshType == ZZRefreshType.pulltorefresh) {
        slivers.add(SliverMasonryGrid.count(
          crossAxisCount: 1,
          childCount: 1,
          itemBuilder: (context, i) {
            return ZZLoadMoreFooter(
              controller: controller,
              loadMoreBlock: () async {
                if (noMore) return ZZLoadMoreStatus.noMoreData;
                _retrieveData(true);
                return ZZLoadMoreStatus.finishLoad;
              },
            );
          },
        ));
      }
    } else {
      controller.isWaterfallMultipleType = false;
      slivers.add(SliverMasonryGrid.count(
        crossAxisCount: controller.crossAxisCount,
        mainAxisSpacing: controller.mainAxisSpacing ?? 0,
        crossAxisSpacing: controller.crossAxisSpacing ?? 0,
        childCount: controller.dataSource.length,
        itemBuilder: (context, index) {
          ZZBaseBrickObject object = controller.dataSource[index];
          return object.widget;
        },
      ));
      if (refreshType == ZZRefreshType.pulltorefresh) {
        slivers.add(SliverMasonryGrid.count(
          crossAxisCount: 1,
          childCount: 1,
          itemBuilder: (context, i) {
            return ZZLoadMoreFooter(
              controller: controller,
              loadMoreBlock: () async {
                if (noMore) return ZZLoadMoreStatus.noMoreData;
                _retrieveData(true);
                return ZZLoadMoreStatus.finishLoad;
              },
            );
          },
        ));
      }
    }
    return CustomScrollView(
      slivers: slivers,
      physics: physics,
      controller: controller.scrollController,
    );
  }

  void _retrieveData(bool nextPage) async {
    ZZBaseWaterfallController controller = widget.controller;
    controller.fetchData(nextPage: nextPage);
  }
}
