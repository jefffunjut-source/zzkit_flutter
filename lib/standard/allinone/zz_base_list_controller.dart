import 'package:get/get.dart';

enum PageState { loading, success, empty, error, loadingMore, noMore }

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
