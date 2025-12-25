import 'package:flutter/widgets.dart';
import 'zz_base_list_controller.dart';

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
