// ignore_for_file: must_be_immutable, file_names, unnecessary_overrides
library zzkit;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:zzkit_flutter/standard/list/ZZBaseListPage.dart';
import 'package:zzkit_flutter/standard/brick/common/ZZBaseBrick.dart';
import 'package:zzkit_flutter/standard/nestedscrollview/ZZLoadMoreFooter.dart';
import 'package:zzkit_flutter/standard/scaffold/ZZBaseScaffold.dart';
import 'package:zzkit_flutter/standard/widget/ZZNoDataWidget.dart';
import 'package:zzkit_flutter/util/ZZEvent.dart';
import 'package:zzkit_flutter/util/ZZExtension.dart';
import 'package:zzkit_flutter/util/core/ZZAppConsts.dart';
import 'package:zzkit_flutter/util/core/ZZAppManager.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

typedef ZZAppApiRequestCallback<ZZAPIResponse> = Future<ZZAPIResponse>
    Function();

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
  }) : super();
}

class ZZBaseWaterfallPage<T> extends StatefulWidget {
  // 列表页控制器
  T controller;
  // Scaffold 标题
  String? title;
  // Scaffold 背景色
  Color? backgroundColor;
  // Scaffold 是否保留safe区域
  bool? safeAreaBottom;
  ZZBaseWaterfallPage(
      {super.key,
      required this.controller,
      this.title,
      this.backgroundColor,
      this.safeAreaBottom});

  @override
  ZZBaseWaterfallState createState() => ZZBaseWaterfallState<T>();
}

class ZZBaseWaterfallState<T> extends State<ZZBaseWaterfallPage>
    with AutomaticKeepAliveClientMixin {
  bool noMore = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    ZZBaseListController controller = widget.controller;
    if (controller.refreshType == ZZRefreshType.pulltorefresh) {
      zzEventBus.on<ZZEventNestedScrollViewRefresh>().listen((event) {
        if (event.key == (widget.key as PageStorageKey<String>).value) {
          _getData(false);
        }
      });
      _getData(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    ZZBaseListController controller = widget.controller;
    super.build(context);
    return ZZBaseScaffold(
      backgroundColor: widget.backgroundColor,
      safeAreaBottom: widget.safeAreaBottom,
      appBar: widget.title == null || widget.title?.trim() == ""
          ? null
          : ZZ.appbar(title: widget.title, leftIcon: ZZAppBarIcon.backblack),
      body: Obx(() => controller.nodata.value
          ? Center(
              child: ZZNoDataWidget(nodata: true),
            )
          : controller.margin != null || controller.padding != null
              ? Container(
                  margin: controller.margin,
                  padding: controller.padding,
                  child: _homeBody(),
                )
              : _homeBody()),
    );
  }

  void _getData(bool nextPage) async {
    ZZBaseWaterfallController controller = widget.controller;
    controller.fetchData(nextPage: nextPage);
  }

  Widget _homeBody() {
    ZZBaseWaterfallController controller = widget.controller;
    if (controller.refreshType == ZZRefreshType.smartrefresh) {
      return SmartRefresher(
        controller: controller.refreshController,
        enablePullUp: true,
        header: ClassicHeader(
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
          _getData(false);
        },
        onLoading: () async {
          _getData(true);
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
    if (controller.dataSource.safeObjectAtIndex(0) is ZZBrickList) {
      controller.isWaterfallMultipleType = true;
      List<SliverMasonryGrid> slivers = controller.dataSource.map((element) {
        ZZBrickList list = element;
        return SliverMasonryGrid.count(
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
        );
      }).toList();
      if (refreshType == ZZRefreshType.pulltorefresh) {
        slivers.add(SliverMasonryGrid.count(
          crossAxisCount: 1,
          childCount: 1,
          itemBuilder: (context, i) {
            return ZZLoadMoreFooter(
              loadMoreBlock: () async {
                if (noMore) return ZZLoadMoreStatus.noMoreData;
                _getData(true);
                return ZZLoadMoreStatus.finishLoad;
              },
            );
          },
        ));
      }
      return CustomScrollView(slivers: slivers);
    } else {
      controller.isWaterfallMultipleType = false;
      List<SliverMasonryGrid> slivers = <SliverMasonryGrid>[
        SliverMasonryGrid.count(
          crossAxisCount: controller.crossAxisCount,
          mainAxisSpacing: controller.mainAxisSpacing ?? 0,
          crossAxisSpacing: controller.crossAxisSpacing ?? 0,
          childCount: controller.dataSource.length,
          itemBuilder: (context, index) {
            ZZBaseBrickObject object = controller.dataSource[index];
            return object.widget;
          },
        )
      ];
      if (refreshType == ZZRefreshType.pulltorefresh) {
        slivers.add(SliverMasonryGrid.count(
          crossAxisCount: 1,
          childCount: 1,
          itemBuilder: (context, i) {
            return ZZLoadMoreFooter(
              loadMoreBlock: () async {
                if (noMore) return ZZLoadMoreStatus.noMoreData;
                _getData(true);
                return ZZLoadMoreStatus.finishLoad;
              },
            );
          },
        ));
      }
      return CustomScrollView(slivers: slivers);
    }
  }
}
