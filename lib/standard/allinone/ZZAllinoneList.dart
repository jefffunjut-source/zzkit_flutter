// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

enum PageState { loading, success, empty, error, loadingMore, noMore }

/// 基础Feed项接口，所有Feed类型都需要实现此接口
abstract class ZZFeed {
  Widget get widget;
}

abstract class ZZBaseListController extends GetxController {
  final data = <ZZFeed>[].obs;
  final state = PageState.loading.obs;
  final isRefreshing = false.obs;

  int _page = 1;
  bool _isRequesting = false;

  bool get isLoading => state.value == PageState.loading;
  bool get isEmpty => state.value == PageState.empty;
  bool get isError => state.value == PageState.error;
  bool get isNoMore => state.value == PageState.noMore;

  @override
  void onInit() {
    super.onInit();
    refreshData();
  }

  Future<void> refreshData() async {
    if (_isRequesting) return;
    _isRequesting = true;

    isRefreshing.value = true;
    _page = 1;
    state.value = PageState.loading;

    try {
      final list = await loadData(_page);
      data
        ..clear()
        ..addAll(list);

      state.value = data.isEmpty ? PageState.empty : PageState.success;
    } catch (_) {
      state.value = PageState.error;
    } finally {
      _isRequesting = false;
      isRefreshing.value = false;
    }
  }

  Future<void> loadMore() async {
    if (_isRequesting || isNoMore) return;
    _isRequesting = true;

    state.value = PageState.loadingMore;

    try {
      final list = await loadData(_page + 1);
      if (list.isEmpty) {
        state.value = PageState.noMore;
      } else {
        _page++;
        data.addAll(list);
        state.value = PageState.success;
      }
    } catch (_) {
      state.value = PageState.error;
    } finally {
      _isRequesting = false;
    }
  }

  /// 子类实现，返回多类型Feed列表
  Future<List<ZZFeed>> loadData(int page);
}

abstract class ZZBaseSliverPage<C extends ZZBaseListController>
    extends StatelessWidget {
  ZZBaseSliverPage({super.key});

  C get controller;
  late final ZZListDelegate delegate = ZZListDelegate();

  /// 1 = List, >1 = 瀑布流
  int get crossAxisCount => 1;

  Color? get backgroundColor => Colors.white;

  @override
  Widget build(BuildContext context) {
    // 监听刷新状态变化，显示提示
    ever(controller.isRefreshing, (bool refreshing) {
      if (!refreshing && controller.state.value == PageState.success) {
        Future.delayed(const Duration(milliseconds: 300), () {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('刷新完成'),
                duration: Duration(seconds: 1),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        });
      }
    });

    return Container(
      color: backgroundColor,
      child: RefreshIndicator(
        onRefresh: controller.refreshData,
        color: Colors.red,
        backgroundColor: Colors.white,
        strokeWidth: 3.0,
        child: NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            if (notification.metrics.pixels >
                    notification.metrics.maxScrollExtent - 200 &&
                controller.state.value == PageState.success) {
              controller.loadMore();
            }
            return false;
          },
          child: CustomScrollView(
            slivers: [
              Obx(() => _buildContent()),
              Obx(() => delegate.buildFooter(controller.state.value)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    final state = controller.state.value;

    // 初始加载时显示Loading（数据为空且正在加载）
    if (state == PageState.loading && controller.data.isEmpty) {
      return delegate.buildLoadingSliver();
    }

    if (state == PageState.error) {
      return delegate.buildErrorSliver(controller.refreshData);
    }

    if (state == PageState.empty) {
      return delegate.buildEmptySliver();
    }

    return crossAxisCount == 1 ? _buildList() : _buildWaterfall();
  }

  Widget _buildList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        final item = controller.data[index];
        return RepaintBoundary(child: delegate.buildItem(item, index));
      }, childCount: controller.data.length),
    );
  }

  Widget _buildWaterfall() {
    return SliverMasonryGrid.count(
      crossAxisCount: crossAxisCount,
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      itemBuilder: (context, index) {
        final item = controller.data[index];
        return RepaintBoundary(child: delegate.buildItem(item, index));
      },
      childCount: controller.data.length,
    );
  }
}

class ZZListDelegate {
  ZZListDelegate() {
    debugPrint('ZZListDelegate initialized');
  }

  Widget buildItem(ZZFeed item, int index) {
    return item.widget;
  }

  /// Loading
  Widget buildLoadingSliver() {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 空态
  Widget buildEmptySliver() {
    return SliverFillRemaining(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.inbox_outlined,
                size: 60,
                color: Colors.grey[400],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              '暂无数据',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '这里空空如也，快去添加一些内容吧',
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                // 这里可以添加刷新逻辑
              },
              icon: const Icon(Icons.refresh),
              label: const Text('刷新试试'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 错误态
  Widget buildErrorSliver(VoidCallback onRetry) {
    return SliverFillRemaining(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.red[50],
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline,
                size: 60,
                color: Colors.red[400],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              '加载失败',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '网络连接异常，请检查网络后重试',
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('重新加载'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 底部加载态
  Widget buildFooter(PageState state) {
    switch (state) {
      case PageState.loadingMore:
        return SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Get.context != null
                          ? Theme.of(Get.context!).primaryColor
                          : Colors.blue,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  '正在加载更多...',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        );
      case PageState.noMore:
        return SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.check_circle_outline,
                  size: 20,
                  color: Colors.grey[400],
                ),
                const SizedBox(width: 8),
                Text(
                  '没有更多内容了',
                  style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                ),
              ],
            ),
          ),
        );
      default:
        return const SliverToBoxAdapter(child: SizedBox.shrink());
    }
  }
}
