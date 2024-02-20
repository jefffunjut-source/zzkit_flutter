// ignore_for_file: must_be_immutable, file_names, unnecessary_overrides
library zzkit;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
  // 数据
  RefreshController refreshController = RefreshController(initialRefresh: true);
  int page = 1;
  int pageSize = 5;
  RxBool nodata = false.obs;
  RxList<dynamic> dataSource = <dynamic>[].obs;

  // UI描述
  EdgeInsetsGeometry? margin;
  EdgeInsetsGeometry? padding;
  int? colorHex;

  ZZBaseListController({this.margin, this.padding, this.colorHex});

  Future<ZZAPIResponse> beginTransaction(
      bool nextPage, ZZAppApiRequestCallback apiRequest) async {
    if (nextPage == false) {
      page = 1;
      nodata.value = false;
      if (dataSource.isEmpty) {
        APP.show();
      }
    } else {
      page = page + 1;
    }
    ZZAPIResponse response = await apiRequest();
    return response;
  }

  void endTransaction(ZZAPIResponse response, List? rows) {
    response.rows = rows;
    nodata.value = false;
    if (page == 1) {
      APP.dismiss();
    }
    ZZAPIError? error = response.error;
    if (error != null) {
      APP.toast(error.errorMessage);
      refreshController.loadComplete();
      refreshController.refreshCompleted();
    } else {
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
    (widget.controller as ZZBaseListController).fetchData(nextPage);
  }

  Widget homeBody() {
    return SmartRefresher(
      controller: (widget.controller as ZZBaseListController).refreshController,
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
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              ZZBaseBrickObject object =
                  (widget.controller as ZZBaseListController).dataSource[index];
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
            childCount:
                (widget.controller as ZZBaseListController).dataSource.length,
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
          : APP.appbar(title: widget.title, leftIcon: ZZAppBarIcon.backblack),
      body: Obx(() => (controller as ZZBaseListController).nodata.value
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
