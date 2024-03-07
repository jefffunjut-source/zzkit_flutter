// ignore_for_file: must_be_immutable, file_names, unnecessary_overrides, unnecessary_new
library zzkit;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:zzkit_flutter/standard/brick/common/ZZShimmerBrickWidget.dart';
import 'package:zzkit_flutter/standard/scaffold/ZZBaseScaffold.dart';
import 'package:zzkit_flutter/standard/brick/common/ZZBaseBrickWidget.dart';
import 'package:zzkit_flutter/standard/widget/ZZNoDataWidget.dart';
import 'package:zzkit_flutter/util/api/ZZAPIProvider.dart';
import 'package:zzkit_flutter/util/core/ZZAppConsts.dart';
import 'package:zzkit_flutter/util/core/ZZAppManager.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

typedef ZZAppApiRequestCallback<ZZAPIResponse> = Future<ZZAPIResponse>
    Function();

class ZZBaseListController extends GetxController {
  // 刷新控制器
  RefreshController refreshController = RefreshController(initialRefresh: true);

  // 数据
  int page = 1;
  int pageSize = 5;
  RxBool nodata = false.obs;
  RxList<dynamic> dataSource = <dynamic>[].obs;

  // 滑动控制器
  ScrollController? scrollController;

  // 是否启用shimmer
  bool? shimmer;
  double? shimmerBrickHeight;
  Widget? shimmerCustomWidget;

  // Refresh描述
  String? refreshingIdleText;
  String? refreshingReleaseText;
  String? refreshingText;
  String? refreshingCompleteText;
  String? refreshingLoadingText;
  String? refreshingNoDataText;

  // UI描述
  EdgeInsetsGeometry? margin;
  EdgeInsetsGeometry? padding;
  EdgeInsetsGeometry? brickMargin;
  EdgeInsetsGeometry? brickPadding;
  int? brickColor;

  ZZBaseListController(
      {this.scrollController,
      this.shimmer = false,
      this.shimmerBrickHeight,
      this.shimmerCustomWidget,
      this.refreshingIdleText = "下拉可以刷新哦",
      this.refreshingReleaseText = "释放刷新",
      this.refreshingText = "正在加载",
      this.refreshingCompleteText = "完成",
      this.refreshingLoadingText = "正在加载中...",
      this.refreshingNoDataText = "已经到底咯",
      this.margin,
      this.padding,
      this.brickMargin,
      this.brickPadding,
      this.brickColor});

  Future<ZZAPIResponse?> beginTransaction(
      bool nextPage, ZZAppApiRequestCallback? apiRequest) async {
    if (nextPage == false) {
      page = 1;
      nodata.value = false;
      if (dataSource.isEmpty) {
        shimmer ?? false ? null : App.show();
      }
    } else {
      page = page + 1;
    }
    if (apiRequest != null) {
      ZZAPIResponse response = await apiRequest();
      return response;
    } else {
      return null;
    }
  }

  void endTransaction(ZZAPIResponse? response, List? rows) {
    response?.rows = rows;
    nodata.value = false;
    if (page == 1) {
      shimmer ?? false ? null : App.dismiss();
    }
    ZZAPIError? error = response?.error;
    if (error != null) {
      App.toast(error.errorMessage);
      refreshController.loadComplete();
      refreshController.refreshCompleted();
    } else {
      dataSource.removeWhere((element) {
        if (element is ZZShimmerBrickObject) {
          return true;
        }
        return false;
      });
      if (page == 1) {
        dataSource.clear();
        if (rows?.isEmpty ?? true) {
          nodata.value = true;
        }
      }
      if (rows == null || rows.length < pageSize) {
        refreshController.loadNoData();
      } else {
        refreshController.loadComplete();
        refreshController.refreshCompleted();
      }
    }
  }

  Future<dynamic> fetchData(bool nextPage) async {}
}

class ZZBaseListPage<T> extends StatefulWidget {
  T controller;
  String? title;
  ZZBaseListPage({super.key, required this.controller, this.title});

  @override
  ZZBaseListState createState() => ZZBaseListState<T>();
}

class ZZBaseListState<T> extends State<ZZBaseListPage>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
  }

  void getData(bool nextPage) async {
    ZZBaseListController controller = widget.controller as ZZBaseListController;

    /// Shimmer
    if (controller.shimmer ?? false) {
      bool hasShimmer = false;
      for (var object in controller.dataSource) {
        if (object is ZZShimmerBrickObject) {
          hasShimmer = true;
          break;
        }
      }
      if (!hasShimmer) {
        List arr = List.empty(growable: true);
        for (int i = 0; i < controller.pageSize; i++) {
          var shimmer = ZZShimmerBrickObject()
            ..height = controller.shimmerBrickHeight
            ..customWidget = controller.shimmerCustomWidget
            ..widget = ZZShimmerBrickWidget();
          arr.add(shimmer);
        }
        controller.dataSource.addAll(arr);
        // controller.refreshController.refreshCompleted();
        // controller.refreshController.loadComplete();
      }
    }

    /// Real data
    controller.fetchData(nextPage);
  }

  Widget homeBody() {
    ZZBaseListController controller = widget.controller as ZZBaseListController;
    return SmartRefresher(
      controller: controller.refreshController,
      enablePullUp: true,
      enablePullDown: true,
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
      child: CustomScrollView(
          controller: controller.scrollController,
          slivers: <Widget>[
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  ZZBaseBrickObject object = controller.dataSource[index];
                  object.margin ??= controller.brickMargin;
                  object.padding ??= controller.brickPadding;
                  return Container(
                      color: object.padding != null
                          ? Color(object.colorHex ?? 0xFFFFFFFF)
                          : null,
                      margin: object.margin,
                      padding: object.padding,
                      child: object.widget);
                },
                childCount: controller.dataSource.length,
              ),
            ),
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
          : App.appbar(title: widget.title, leftIcon: ZZAppBarIcon.backblack),
      body: Obx(() => (controller as ZZBaseListController).nodata.value
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
