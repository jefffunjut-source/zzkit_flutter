// ignore_for_file: must_be_immutable, file_names, unnecessary_overrides
library zzkit;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:zzkit_flutter/standard/list/ZZBaseListPage.dart';
import 'package:zzkit_flutter/standard/brick/common/ZZBaseBrickWidget.dart';
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
      super.margin,
      super.padding,
      super.colorHex})
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
    (widget.controller as ZZBaseWaterfallController).fetchData(nextPage);
  }

  Widget homeBody() {
    return SmartRefresher(
      controller:
          (widget.controller as ZZBaseWaterfallController).refreshController,
      enablePullUp: true,
      header: const ClassicHeader(
        idleText: "下拉可以刷新哦",
        releaseText: "释放刷新",
        refreshingText: "正在加载",
        completeText: "完成",
      ),
      footer: const ClassicFooter(
        loadingText: "正在加载中...",
        noDataText: "已经到底咯",
      ),
      onRefresh: () async {
        getData(false);
      },
      onLoading: () async {
        getData(true);
      },
      child: CustomScrollView(slivers: <Widget>[
        SliverMasonryGrid.count(
          crossAxisCount:
              (widget.controller as ZZBaseWaterfallController).crossAxisCount,
          mainAxisSpacing: (widget.controller as ZZBaseWaterfallController)
                  .mainAxisSpacing ??
              0,
          crossAxisSpacing: (widget.controller as ZZBaseWaterfallController)
                  .crossAxisSpacing ??
              0,
          childCount: (widget.controller as ZZBaseWaterfallController)
              .dataSource
              .length,
          itemBuilder: (context, index) {
            ZZBaseBrickObject object =
                (widget.controller as ZZBaseWaterfallController)
                    .dataSource[index];
            if (object.margin != null || object.padding != null) {
              return Container(
                  color: object.padding != null
                      ? Color(object.colorHex ?? 0xFFFFFFFF)
                      : null,
                  margin: object.margin,
                  padding: object.padding,
                  child: object.widget);
            } else {
              return object.widget;
            }
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
          : APP.appbar(title: widget.title, leftIcon: ZZAppBarIcon.backblack),
      body: Obx(() => (controller as ZZBaseWaterfallController).nodata.value
          ? Center(
              child: ZZNoDataWidget(nodata: true),
            )
          : controller.margin != null || controller.padding != null
              ? Container(
                  margin: controller.margin,
                  padding: controller.padding,
                  color: Color(controller.colorHex ?? 0xFFFFFFFF),
                  child: homeBody(),
                )
              : homeBody()),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
