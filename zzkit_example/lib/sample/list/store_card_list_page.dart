// ignore_for_file: library_private_types_in_public_api, invalid_use_of_protected_member, must_be_immutable, use_key_in_widget_constructors, file_names, depend_on_referenced_packages

import 'dart:convert';
import 'dart:math';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zzkit_example/sample/list/store_card_response.dart';
import 'package:zzkit_example/sample/list/store_card_feed.dart';
import 'package:zzkit_flutter/allinone/zz_allinone_list.dart';
import 'package:zzkit_flutter/util/api/ZZAPIProvider.dart';

class StoreCardListPageController extends ZZListController {
  @override
  Future<List<ZZFeed>> loadData(int page) async {
    final feeds = <ZZFeed>[];
    await _fakeGetRequest().then((value) {
      ZZAPIResponse<StoreCardResponse>? resp =
          value as ZZAPIResponse<StoreCardResponse>?;
      if (resp?.error == null) {
        StoreCardResponse? response = resp?.resp;
        feeds.addAll(
          response?.data?.rows?.map(
                (e) => StoreCardFeed(
                  id: e.id ?? "",
                  pic: e.pic ?? "",
                  title: e.title ?? "",
                  desc: e.desc ?? "",
                ),
              ) ??
              [],
        );
      }
    });

    return feeds;
  }

  Future<ZZAPIResponse> _fakeGetRequest() async {
    await Future.delayed(const Duration(seconds: 1));
    StoreCardResponse? response;
    ZZAPIError? error;
    response = StoreCardResponse();
    response.code = "0";
    response.msg = "success";
    response.data = Data();
    List<Rows>? rows = await _fakeRandomRows(20);
    response.data?.rows = rows;
    return ZZAPIResponse<StoreCardResponse>(response, error);
  }

  Future<List<Rows>?> _fakeRandomRows(int count) async {
    try {
      String jsonData = await rootBundle.loadString('assets/json/stores.json');
      List<dynamic> jsonList = json.decode(jsonData);
      // 使用Random类生成随机数
      Random random = Random();
      // 获取jsonList的长度
      int listLength = jsonList.length;
      // 生成一个包含5个随机索引的列表
      List<int> randomIndexes = List.generate(
        count,
        (index) => random.nextInt(listLength),
      );
      // 从jsonList中选取随机索引对应的元素
      List<Rows> selectedItems =
          randomIndexes.map((index) {
            Rows row = Rows();
            row.id = jsonList[index]['id'];
            row.title = jsonList[index]['title'];
            row.pic = jsonList[index]['pic'];
            row.desc = jsonList[index]['desc'];
            return row;
          }).toList();
      return selectedItems;
    } catch (e) {
      debugPrint('Error loading JSON data: $e');
    }
    return null;
  }
}

// 示例页面 - 列表模式
class StoreCardListPage extends ZZListPage<StoreCardListPageController> {
  StoreCardListPage({super.key});

  @override
  StoreCardListPageController get controller =>
      Get.put(StoreCardListPageController());

  @override
  int get crossAxisCount => 1; // 列表模式
}
