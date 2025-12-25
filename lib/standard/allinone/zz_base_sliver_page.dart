import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

import 'zz_base_list_controller.dart';
import 'zz_list_delegate.dart';

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
