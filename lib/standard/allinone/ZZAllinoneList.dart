import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

enum PageState { loading, success, empty, error, loadingMore, noMore }

abstract class ZZBrick<T> extends StatefulWidget {
  final T data;
  const ZZBrick(this.data, {super.key});
}

abstract class ZZBrickState<T, B extends ZZBrick<T>> extends State<B> {
  T get data => widget.data;
}

abstract class ZZBaseListController<T> extends GetxController {
  final data = <T>[].obs;
  final state = PageState.loading.obs;

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

  /// 子类实现
  Future<List<T>> loadData(int page);
}

abstract class ZZBaseSliverPage<T, C extends ZZBaseListController<T>>
    extends StatelessWidget {
  const ZZBaseSliverPage({super.key});

  C get controller;
  ZZListDelegate<T> get delegate;

  /// 1 = List, >1 = 瀑布流
  int get crossAxisCount => 1;

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
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
    );
  }

  Widget _buildContent() {
    final state = controller.state.value;

    if (state == PageState.loading) {
      return delegate.buildShimmerSliver();
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

abstract class ZZListDelegate<T> {
  Widget buildItem(T item, int index);

  /// Shimmer
  Widget buildShimmerSliver() {
    return const SliverToBoxAdapter(
      child: SizedBox(height: 200, child: Text("Shimmering...")),
    );
  }

  /// 空态
  Widget buildEmptySliver() {
    return const SliverToBoxAdapter(child: Center(child: Text('暂无数据')));
  }

  /// 错误态
  Widget buildErrorSliver(VoidCallback onRetry) {
    return SliverToBoxAdapter(
      child: Center(
        child: GestureDetector(onTap: onRetry, child: const Text('加载失败，点击重试')),
      ),
    );
  }

  static const _footerMap = {
    PageState.loadingMore: SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Center(child: Text('加载中...')),
      ),
    ),
    PageState.noMore: SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Center(child: Text('没有更多了')),
      ),
    ),
  };

  /// 底部加载态
  Widget buildFooter(PageState state) {
    return _footerMap[state] ??
        const SliverToBoxAdapter(child: SizedBox.shrink());
  }
}
