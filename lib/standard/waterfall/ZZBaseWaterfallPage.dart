// ignore_for_file: must_be_immutable, file_names, unnecessary_overrides
library zzkit;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:zzkit_flutter/standard/list/ZZBaseListPage.dart';
import 'package:zzkit_flutter/standard/brick/common/ZZBaseBrick.dart';
import 'package:zzkit_flutter/standard/scaffold/ZZBaseScaffold.dart';
import 'package:zzkit_flutter/standard/widget/ZZNoDataWidget.dart';
import 'package:zzkit_flutter/util/core/ZZAppConsts.dart';
import 'package:zzkit_flutter/util/core/ZZAppManager.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

typedef ZZAppApiRequestCallback<ZZAPIResponse> = Future<ZZAPIResponse>
    Function();

class ZZBaseWaterfallController extends ZZBaseListController {
  int crossAxisCount = 2;
  double? mainAxisSpacing = 0;
  double? crossAxisSpacing = 0;

  ZZBaseWaterfallController(
      {required this.crossAxisCount,
      this.mainAxisSpacing,
      this.crossAxisSpacing,
      super.scrollController,
      super.show1stPageLoading,
      // 瀑布流不考虑shimmer动画，加载shimmer前无法预知git 高度
      // super.shimmer,
      // super.shimmerBrickHeight,
      // super.shimmerBrickObject,
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
      super.brickColor})
      : super();
}

class ZZBaseWaterfallPage<T> extends StatefulWidget {
  T controller;
  String? title;
  ZZBaseWaterfallPage({super.key, required this.controller, this.title});

  @override
  ZZBaseWaterfallState createState() => ZZBaseWaterfallState<T>();
}

class ZZBaseWaterfallState<T> extends State<ZZBaseWaterfallPage>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
  }

  void getData(bool nextPage) async {
    ZZBaseWaterfallController controller = widget.controller;
    controller.fetchData(nextPage);
  }

  Widget homeBody() {
    ZZBaseWaterfallController controller = widget.controller;
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
        getData(false);
      },
      onLoading: () async {
        getData(true);
      },
      child: CustomScrollView(slivers: <Widget>[
        SliverMasonryGrid.count(
          crossAxisCount: controller.crossAxisCount,
          mainAxisSpacing: controller.mainAxisSpacing ?? 0,
          crossAxisSpacing: controller.crossAxisSpacing ?? 0,
          childCount: controller.dataSource.length,
          itemBuilder: (context, index) {
            ZZBaseBrickObject object = controller.dataSource[index];
            return Container(
                color: object.padding != null
                    ? Color(object.colorHex ?? 0xFFFFFFFF)
                    : null,
                margin: object.margin,
                padding: object.padding,
                child: object.widget);
          },
        )
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    T controller = widget.controller;
    super.build(context);
    return ZZBaseScaffold(
      appBar: widget.title == null || widget.title?.trim() == ""
          ? null
          : ZZ.appbar(title: widget.title, leftIcon: ZZAppBarIcon.backblack),
      body: Obx(() => (controller as ZZBaseWaterfallController).nodata.value
          ? Center(
              child: ZZNoDataWidget(nodata: true),
            )
          : controller.margin != null || controller.padding != null
              ? Container(
                  margin: controller.margin,
                  padding: controller.padding,
                  color: Color(controller.brickColor ?? 0xFFFFFFFF),
                  child: homeBody(),
                )
              : homeBody()),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
