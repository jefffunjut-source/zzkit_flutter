// ignore_for_file: file_names, use_key_in_widget_constructors, must_be_immutable, depend_on_referenced_packages

import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zzkit_example/xtemplete/xbrick/XXStoreCardBrick.dart';
import 'package:zzkit_example/xtemplete/xlist/store_card_response.dart';
import 'package:zzkit_flutter/standard/brick/common/ZZBaseBrick.dart';
import 'package:zzkit_flutter/standard/waterfall/ZZBaseWaterfallPage.dart';
import 'package:zzkit_flutter/util/api/ZZAPIProvider.dart';
import 'package:zzkit_flutter/util/ZZExtension.dart';

class XXSampleMultiTypesWaterfallPageController
    extends ZZBaseWaterfallController {
  XXSampleMultiTypesWaterfallPageController()
    : super(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        margin: const EdgeInsets.all(10.0),
        padding: const EdgeInsets.all(10),
      );

  @override
  Future fetchData({required bool nextPage}) async {
    await begin(
          nextPage: nextPage,
          apiRequest: () {
            // 标准API Request调用
            debugPrint("page: $page  nextPage: $nextPage");
            return _fakeGetRequest();
          },
        )
        .then((value) {
          // 必须调用endTransaction
          XXSampleListResponse? resp = value?.resp;
          List? a = resp?.data?.rows?.reshape();
          end(response: value, rows: a, currentPageSize: 1);
          return value;
        })
        .then((value) {
          // 处理rows数据，生成Object和Widget对
          value?.rows?.forEach((element) {
            // element is List
            var rows =
                element.map((e) {
                  return XXStoreCardBrickObject()
                    // 自身数据
                    ..title = e.title
                    ..pic = e.pic
                    ..id = e.id
                    ..desc = e.desc
                    // 数据和控件绑定（如果有映射，这部分代码可以自动处理的）
                    ..widget = XXStoreCardBrick();
                }).toList();
            ZZBrickList list = ZZBrickList(
              dataSource: rows,
              crossAxisCount: Random().nextInt(2) + 1,
            );
            dataSource.add(list);
          });
          return value;
        });
  }

  Future<ZZAPIResponse> _fakeGetRequest() async {
    await Future.delayed(const Duration(seconds: 1));
    XXSampleListResponse? response;
    ZZAPIError? error;
    if (page.value <= 3) {
      response = XXSampleListResponse();
      response.code = "0";
      response.msg = "success";
      response.data = Data();
      List<Rows>? rows = await _fakeRandomRows(
        page.value == 1 || page.value == 2 ? 10 : 4,
      );
      response.data?.rows = rows;
    } else {
      response = XXSampleListResponse();
      response.code = "0";
      response.msg = "success";
      response.data = Data();
      response.data?.rows = [];
    }
    return ZZAPIResponse(response, error);
  }

  Future<List<Rows>?> _fakeRandomRows(int count) async {
    try {
      String jsonData = await rootBundle.loadString(
        'assets/json/testrows.json',
      );
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

class XXSampleMultiTypesWaterfallPage
    extends ZZBaseWaterfallPage<XXSampleMultiTypesWaterfallPageController> {
  XXSampleMultiTypesWaterfallPage({required super.controller});

  static XXSampleMultiTypesWaterfallPage newPage() {
    return XXSampleMultiTypesWaterfallPage(
      controller:
          XXSampleMultiTypesWaterfallPageController()
            ..backgroundColor = Colors.white,
    );
  }
}

class XXSampleMultiTypesWaterfallPageState
    extends ZZBaseWaterfallState<XXSampleMultiTypesWaterfallPageController> {}
