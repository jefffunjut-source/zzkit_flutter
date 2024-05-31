// ignore_for_file: must_be_immutable, file_names, unnecessary_overrides, unnecessary_new, prefer_final_fields, unnecessary_import
library zzkit;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:zzkit_flutter/standard/brick/common/ZZShimmerBrick.dart';
import 'package:zzkit_flutter/standard/nestedscrollview/ZZLoadMoreFooter.dart';
import 'package:zzkit_flutter/standard/scaffold/ZZBaseScaffold.dart';
import 'package:zzkit_flutter/standard/brick/common/ZZBaseBrick.dart';
import 'package:zzkit_flutter/standard/widget/ZZPlaceholderWidget.dart';
import 'package:zzkit_flutter/util/ZZEvent.dart';
import 'package:zzkit_flutter/util/api/ZZAPIProvider.dart';
import 'package:zzkit_flutter/util/core/ZZConst.dart';
import 'package:zzkit_flutter/util/core/ZZManager.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

typedef ZZApiRequestCallback<ZZAPIResponse> = Future<ZZAPIResponse> Function();

enum ZZRefreshType {
  smartrefresh,
  pulltorefresh,
}

class ZZBaseListController extends GetxController {
  // 刷新加载类型
  ZZRefreshType refreshType = ZZRefreshType.smartrefresh;

  // 刷新控制器
  final RefreshController _refreshController =
      RefreshController(initialRefresh: true);
  RefreshController get refreshController => _refreshController;
  bool? enablePulldown;
  bool? enablePullup;

  // 数据
  int _page = 1;
  int get page => _page;
  int pageSize = 20;
  final RxBool _nodata = false.obs;
  RxBool get nodata => _nodata;
  final RxList<dynamic> _dataSource = <dynamic>[].obs;
  RxList<dynamic> get dataSource => _dataSource;
  Rx<ZZLoadMoreStatus> _status = ZZLoadMoreStatus.notStart.obs;
  Rx<ZZLoadMoreStatus> get status => _status;

  // 滑动控制器
  ScrollController? scrollController;

  // 是否在第一页加载是loading
  bool? showLoadingFirstPage;

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
  // Scaffold的margin padding
  EdgeInsetsGeometry? margin;
  EdgeInsetsGeometry? padding;
  // Brick的margin padding
  EdgeInsetsGeometry? brickMargin;
  EdgeInsetsGeometry? brickPadding;
  // Scaffold 标题
  String? title;
  // Scaffold 自定义appbar
  AppBar? appBar;
  // Scaffold 背景色
  Color? backgroundColor;
  // Scaffold内第一层容器背景色，用于margin和padding
  Color? secondBackgroundColor;
  // Scaffold 是否保留safe区域
  bool? safeAreaBottom;
  // Bottom Bar
  Widget? bottomWidget;

  // RefreshType == PullToRefresh时候，NestedScrollPage的name
  String? parentName;

  // waterfall multiple types
  bool isWaterfallMultipleType = false;

  // tab controller
  bool? enableTab;
  int tabLength;
  TabController? tabController;

  ZZBaseListController({
    this.refreshType = ZZRefreshType.smartrefresh,
    this.enablePulldown = true,
    this.enablePullup = true,
    this.pageSize = 20,
    this.scrollController,
    this.showLoadingFirstPage = false,
    this.shimmer = false,
    this.shimmerBrickHeight,
    this.shimmerCustomWidget,
    this.refreshingIdleText = zzRefreshingIdleText,
    this.refreshingReleaseText = zzRefreshingReleaseText,
    this.refreshingText = zzRefreshingText,
    this.refreshingCompleteText = zzRefreshingCompleteText,
    this.refreshingLoadingText = zzRefreshingLoadingText,
    this.refreshingNoDataText = zzRefreshingNoDataText,
    this.margin,
    this.padding,
    this.brickMargin,
    this.brickPadding,
    this.title,
    this.appBar,
    this.backgroundColor,
    this.secondBackgroundColor,
    this.safeAreaBottom,
    this.bottomWidget,
    this.parentName,
    this.enableTab,
    this.tabLength = 0,
  });

  void initialize() {}

  void fetchData({required bool nextPage}) async {}

  Future<ZZAPIResponse?> begin({
    required bool nextPage,
    required ZZApiRequestCallback? apiRequest,
  }) async {
    status.value = ZZLoadMoreStatus.loading;
    if (nextPage == false) {
      _page = 1;
      nodata.value = false;
      if (dataSource.isEmpty) {
        if (shimmer == false && showLoadingFirstPage == true) {
          ZZ.show();
        }
      }
    } else {
      _page = _page + 1;
    }
    if (apiRequest != null) {
      ZZAPIResponse response = await apiRequest();
      return response;
    } else {
      return null;
    }
  }

  void end({
    required ZZAPIResponse? response,
    required List? rows,
    int? currentPageSize,
  }) {
    int pageSize = currentPageSize ?? this.pageSize;
    response?.rows = rows;
    nodata.value = false;
    if (page == 1) {
      if (shimmer == false && showLoadingFirstPage == true) {
        ZZ.dismiss();
      }
    }
    ZZAPIError? error = response?.error;
    if (error != null) {
      ZZ.toast(error.errorMessage);
      refreshController.loadComplete();
      refreshController.refreshCompleted();
      status.value = ZZLoadMoreStatus.finishLoad;
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
      if (rows == null || rows.isEmpty || rows.length < pageSize) {
        if (page == 1) {
          refreshController.refreshCompleted();
        }
        if (page == 1) {
        } else {
          refreshController.loadNoData();
        }
        status.value = ZZLoadMoreStatus.noMoreData;
      } else {
        refreshController.loadComplete();
        refreshController.refreshCompleted();
        status.value = ZZLoadMoreStatus.finishLoad;
      }
    }
  }
}

class ZZBaseListPage<T> extends StatefulWidget {
  // 列表页控制器
  T controller;
  ZZBaseListPage({
    super.key,
    required this.controller,
  });

  @override
  ZZBaseListState createState() => ZZBaseListState<T>();
}

class ZZBaseListState<T> extends State<ZZBaseListPage>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  bool noMore = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    ZZBaseListController controller = widget.controller;

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
    ZZBaseListController controller = widget.controller;
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
    ZZBaseListController controller = widget.controller;
    return Obx(() => controller.nodata.value
        ? Center(
            child: ZZNoDataWidget(
              onReloadTap: () {
                ZZ.show();
                _retrieveData(false);
                Future.delayed(const Duration(seconds: 1))
                    .then((value) => ZZ.dismiss());
              },
            ),
          )
        : controller.margin != null ||
                controller.padding != null ||
                controller.secondBackgroundColor != null
            ? Container(
                color: controller.secondBackgroundColor,
                margin: controller.margin,
                padding: controller.padding,
                child: _homeBody(),
              )
            : _homeBody());
  }

  Widget _homeBody() {
    ZZBaseListController controller = widget.controller;
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
        child: _customScrollView(),
      );
    } else if (controller.refreshType == ZZRefreshType.pulltorefresh) {
      return _listView();
    }
    return Container();
  }

  Widget _customScrollView() {
    ZZBaseListController controller = widget.controller;
    return CustomScrollView(
        controller: controller.scrollController,
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                ZZBaseBrickObject object = controller.dataSource[index];
                if (object is ZZShimmerBrickObject) {
                  if (object.customWidget != null) {
                    return object.customWidget;
                  } else if (object.widget != null) {
                    if (controller.brickMargin != null ||
                        controller.brickPadding != null) {
                      return Container(
                        margin: controller.brickMargin,
                        padding: controller.padding,
                        child: object.widget,
                      );
                    } else {
                      return object.widget;
                    }
                  }
                }
                return object.widget;
              },
              childCount: controller.dataSource.length,
            ),
          ),
        ]);
  }

  Widget _listView() {
    ZZBaseListController controller = widget.controller;
    return ListView.builder(
      key: widget.key,
      controller: controller.scrollController,
      physics: const ClampingScrollPhysics(),
      itemBuilder: (BuildContext c, int index) {
        if (index < controller.dataSource.length) {
          ZZBaseBrickObject object = controller.dataSource[index];
          if (object is ZZShimmerBrickObject) {
            if (object.customWidget != null) {
              return object.customWidget;
            } else if (object.widget != null) {
              if (controller.brickMargin != null ||
                  controller.brickPadding != null) {
                return Container(
                  margin: controller.brickMargin,
                  padding: controller.padding,
                  child: object.widget,
                );
              } else {
                return object.widget;
              }
            }
          }
          return object.widget;
        } else if (index == controller.dataSource.length && index != 0) {
          return ZZLoadMoreFooter(
            controller: controller,
            loadMoreBlock: () async {
              if (noMore) return ZZLoadMoreStatus.noMoreData;
              _retrieveData(true);
              return ZZLoadMoreStatus.finishLoad;
            },
          );
        }
        return Container();
      },
      itemCount: controller.dataSource.length + 1,
      padding: const EdgeInsets.all(0.0),
    );
  }

  void _retrieveData(bool nextPage) async {
    ZZBaseListController controller = widget.controller;

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
            ..widget = ZZShimmerBrick();
          arr.add(shimmer);
        }
        controller.dataSource.addAll(arr);
      }
    }

    /// Retrieve data
    controller.fetchData(nextPage: nextPage);
  }
}
