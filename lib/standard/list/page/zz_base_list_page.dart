// ignore_for_file: must_be_immutable, file_names, unnecessary_overrides, unnecessary_new, prefer_final_fields, unnecessary_import, unnecessary_library_name

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:zzkit_flutter/standard/list/widget/ZZShimmerBrick.dart';
import 'package:zzkit_flutter/standard/list/widget/ZZLoadMoreFooter.dart';
import 'package:zzkit_flutter/standard/page/zz_base_scaffold.dart';
import 'package:zzkit_flutter/standard/list/widget/ZZBaseBrick.dart';
import 'package:zzkit_flutter/standard/widget/zz_no_data_widget.dart';
import 'package:zzkit_flutter/util/zz_event.dart';
import 'package:zzkit_flutter/util/api/zz_api_provider.dart';
import 'package:zzkit_flutter/util/core/zz_const.dart';
import 'package:zzkit_flutter/util/core/zz_manager.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

typedef ZZApiRequestCallback<ZZAPIResponse> = Future<ZZAPIResponse> Function();

enum ZZRefreshType { smartrefresh, pulltorefresh }

class ZZBaseListController extends GetxController {
  // 刷新加载类型
  ZZRefreshType refreshType = ZZRefreshType.smartrefresh;

  // 刷新控制器
  final RefreshController _refreshController = RefreshController(
    initialRefresh: true,
  );
  RefreshController get refreshController => _refreshController;
  bool? enablePulldown;
  bool? enablePullup;

  // No Data
  RxBool nodata = false.obs;
  String? nodataHintText;
  // No Data Relative
  String? nodataButtonText;
  Color? nodataBgColor;

  // 数据
  RxInt page = 1.obs;
  int pageSize = 20;
  RxList<dynamic> dataSource = <dynamic>[].obs;
  Rx<ZZLoadMoreStatus> status = ZZLoadMoreStatus.notStart.obs;

  // 滑动控制器
  ScrollController? scrollController;

  // 是否在第一页加载是loading
  bool? showLoadingFirstPage;

  // 是否启用shimmer
  bool? shimmer;
  double? shimmerBrickHeight;
  Widget? shimmerCustomWidget;

  // Refresh描述
  String? headerIdleText;
  String? headerReleaseText;
  String? headerRefreshingText;
  String? headerCompleteText;
  String? headerCancelRefreshText;
  String? footerLoadingText;
  String? footerNoDataText;
  String? footerCanLoadingText;
  String? reversedHeaderRefreshingText;
  String? reversedFooterLoadingText;
  String? reversedFooterNoDataText;
  String? reversedFooterCanLoadingText;
  String? headerIdleTextKey;
  String? headerReleaseTextKey;
  String? headerRefreshingTextKey;
  String? headerCompleteTextKey;
  String? headerCancelRefreshTextKey;
  String? footerLoadingTextKey;
  String? footerNoDataTextKey;
  String? footerCanLoadingTextKey;
  String? reversedHeaderRefreshingTextKey;
  String? reversedFooterLoadingTextKey;
  String? reversedFooterNoDataTextKey;
  String? reversedFooterCanLoadingTextKey;
  bool? disableFooterNoData;

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

  // reverse
  bool reverse;

  // BuildContext
  late BuildContext context;

  ZZBaseListController({
    this.refreshType = ZZRefreshType.smartrefresh,
    this.enablePulldown = true,
    this.enablePullup = true,
    this.nodataHintText,
    this.nodataButtonText,
    this.nodataBgColor,
    this.pageSize = 20,
    this.scrollController,
    this.showLoadingFirstPage = false,
    this.shimmer = false,
    this.shimmerBrickHeight,
    this.shimmerCustomWidget,
    this.headerIdleText,
    this.headerReleaseText,
    this.headerRefreshingText,
    this.headerCompleteText,
    this.headerCancelRefreshText,
    this.footerLoadingText,
    this.footerNoDataText,
    this.footerCanLoadingText,
    this.reversedHeaderRefreshingText,
    this.reversedFooterLoadingText,
    this.reversedFooterNoDataText,
    this.reversedFooterCanLoadingText,
    this.headerIdleTextKey,
    this.headerReleaseTextKey,
    this.headerRefreshingTextKey,
    this.headerCompleteTextKey,
    this.headerCancelRefreshTextKey,
    this.footerLoadingTextKey,
    this.footerNoDataTextKey,
    this.footerCanLoadingTextKey,
    this.reversedHeaderRefreshingTextKey,
    this.reversedFooterLoadingTextKey,
    this.reversedFooterNoDataTextKey,
    this.reversedFooterCanLoadingTextKey,
    this.disableFooterNoData,
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
    this.reverse = false,
  });

  void initialize() {}

  void deInitialize() {}

  void fetchData({required bool nextPage}) async {}

  Future<ZZAPIResponse?> begin({
    required bool nextPage,
    required ZZApiRequestCallback? apiRequest,
  }) async {
    debugPrint("ZZBaseListPage begin @time: ${DateTime.now()}");
    status.value = ZZLoadMoreStatus.loading;
    if (nextPage == false) {
      page.value = 1;
      nodata.value = false;
      if (dataSource.isEmpty) {
        if (shimmer == false && showLoadingFirstPage == true) {
          ZZ.show();
        }
      }
    } else {
      page.value = page.value + 1;
    }
    if (apiRequest != null) {
      ZZAPIResponse? response = await apiRequest();
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
    // int pageSize = currentPageSize ?? this.pageSize;
    response?.rows = rows;
    nodata.value = false;
    if (page.value == 1) {
      if (rows == null || rows.isEmpty) {
        nodata.value = true;
      }
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
      if (page.value == 1) {
        page.value = 1;
      } else {
        page.value = page.value - 1;
      }
    } else {
      dataSource.removeWhere((element) {
        if (element is ZZShimmerBrickObject) {
          return true;
        }
        return false;
      });
      if (page.value == 1) {
        dataSource.clear();
        if (rows?.isEmpty ?? true) {
          nodata.value = true;
        }
      }
      if (rows == null || rows.isEmpty) {
        if (page.value == 1) {
          page.value = 1;
          refreshController.refreshCompleted();
        } else {
          page.value = page.value - 1;
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
  ZZBaseListPage({super.key, required this.controller});

  @override
  ZZBaseListState createState() => ZZBaseListState<T>();
}

class ZZBaseListState<T> extends State<ZZBaseListPage>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  bool noMore = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    ZZBaseListController controller = widget.controller;
    controller.deInitialize();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    debugPrint("ZZBaseListPage initState @time: ${DateTime.now()}");

    ZZBaseListController controller = widget.controller;
    controller.context = context;

    if (controller.reverse == true) {
      controller.headerIdleText = "";

      controller.headerReleaseText = "";

      controller.headerRefreshingText =
          controller.reversedHeaderRefreshingTextKey?.tr ??
          controller.reversedHeaderRefreshingText ??
          zzReversedHeaderRefreshingText;

      controller.headerCancelRefreshText = "";

      controller.footerLoadingText =
          controller.reversedFooterLoadingTextKey?.tr ??
          controller.reversedFooterLoadingText ??
          zzReversedFooterLoadingText;

      controller.footerNoDataText =
          controller.reversedFooterNoDataTextKey?.tr ??
          controller.reversedFooterNoDataText ??
          zzReversedFooterNoDataText;

      controller.footerCanLoadingText =
          controller.reversedFooterCanLoadingTextKey?.tr ??
          controller.reversedFooterCanLoadingText ??
          zzReversedFooterCanLoadingText;
    } else {
      controller.headerIdleText =
          controller.headerIdleTextKey?.tr ??
          controller.headerIdleText ??
          zzHeaderIdleText;

      controller.headerReleaseText =
          controller.headerReleaseTextKey?.tr ??
          controller.headerReleaseText ??
          zzHeaderReleaseText;

      controller.headerRefreshingText =
          controller.headerRefreshingTextKey?.tr ??
          controller.headerRefreshingText ??
          zzHeaderRefreshingText;

      controller.headerCompleteText =
          controller.headerCompleteTextKey?.tr ??
          controller.headerCompleteText ??
          zzHeaderCompleteText;

      controller.headerCancelRefreshText =
          controller.headerCancelRefreshTextKey?.tr ??
          controller.headerCancelRefreshText ??
          zzHeaderCancelRefreshText;

      controller.footerLoadingText =
          controller.footerLoadingTextKey?.tr ??
          controller.footerLoadingText ??
          zzFooterLoadingText;

      if (controller.disableFooterNoData == true) {
        controller.footerNoDataText = "";
      } else {
        controller.footerNoDataText =
            controller.footerNoDataTextKey?.tr ??
            controller.footerNoDataText ??
            zzFooterNoDataText;
      }

      controller.footerCanLoadingText =
          controller.footerCanLoadingTextKey?.tr ??
          controller.footerCanLoadingText ??
          zzFooterCanLoadingText;
    }

    if (controller.enableTab == true && controller.tabController == null) {
      controller.tabController = TabController(
        length: controller.tabLength,
        vsync: this,
      );
    }
    controller.initialize();
    if (controller.refreshType == ZZRefreshType.pulltorefresh) {
      zzEventBus.on<ZZEventNestedScrollViewRefresh>().listen((event) {
        if (event.name == controller.parentName) {
          debugPrint("ZZBaseListPage retrieve data 1 @time: ${DateTime.now()}");
          _retrieveData(false);
        }
      });
    }
    debugPrint("ZZBaseListPage retrieve data 2 @time: ${DateTime.now()}");
    // _retrieveData(false);
  }

  @override
  Widget build(BuildContext context) {
    ZZBaseListController controller = widget.controller;
    super.build(context);
    return ZZBaseScaffold(
      backgroundColor: controller.backgroundColor,
      safeAreaBottom: controller.safeAreaBottom ?? true,
      appBar:
          controller.appBar ??
          (controller.title != null
              ? ZZ.appbar(
                title: controller.title,
                leftIcon: ZZNavBarIcon.backblack,
              )
              : null),
      body:
          controller.bottomWidget != null
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
    return Obx(
      () =>
          controller.nodata.value
              ? Center(
                child: ZZNoDataWidget(
                  hintText: controller.nodataHintText,
                  buttonText: controller.nodataButtonText,
                  bgColor: controller.nodataBgColor ?? Colors.white,
                  onReloadTap: () {
                    ZZ.show();
                    debugPrint(
                      "ZZBaseListPage retrieve data 3 @time: ${DateTime.now()}",
                    );
                    _retrieveData(false);
                    Future.delayed(
                      const Duration(seconds: 1),
                    ).then((value) => ZZ.dismiss());
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
              : _homeBody(),
    );
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
          idleText: controller.headerIdleText,
          releaseText: controller.headerReleaseText,
          refreshingText: controller.headerRefreshingText,
          completeText: controller.headerCompleteText,
        ),
        footer: ClassicFooter(
          loadingText: controller.footerLoadingText,
          noDataText: controller.footerNoDataText,
          canLoadingText: controller.footerCanLoadingText,
          idleText: "",
          failedText: "",
        ),
        onRefresh: () async {
          controller.refreshController.resetNoData();
          debugPrint("ZZBaseListPage retrieve data 4 @time: ${DateTime.now()}");
          _retrieveData(false);
        },
        onLoading: () async {
          debugPrint("ZZBaseListPage retrieve data 5 @time: ${DateTime.now()}");
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
      reverse: controller.reverse,
      controller: controller.scrollController,
      slivers: <Widget>[
        SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
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
          }, childCount: controller.dataSource.length),
        ),
      ],
    );
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
              debugPrint(
                "ZZBaseListPage retrieve data 6 @time: ${DateTime.now()}",
              );
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
    debugPrint("ZZBaseListPage _retrieveData @time: ${DateTime.now()}");
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
          var shimmer =
              ZZShimmerBrickObject()
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
