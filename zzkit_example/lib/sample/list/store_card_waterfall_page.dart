// ignore_for_file: file_names, use_key_in_widget_constructors, must_be_immutable, depend_on_referenced_packages

import 'package:get/get.dart';
import 'package:zzkit_example/sample/list/store_card_list_page.dart';
import 'package:zzkit_flutter/allinone/zz_allinone_list.dart';

// 示例页面 - 列表模式
class StoreCardWaterfallPage extends ZZListPage<StoreCardListPageController> {
  StoreCardWaterfallPage({super.key});

  @override
  StoreCardListPageController get controller =>
      Get.put(StoreCardListPageController());

  @override
  int get crossAxisCount => 2; // 列表模式
}
