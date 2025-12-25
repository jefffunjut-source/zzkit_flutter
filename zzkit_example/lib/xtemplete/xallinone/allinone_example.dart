// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:zzkit_flutter/standard/allinone/zz_base_list_controller.dart';
import 'package:zzkit_flutter/standard/allinone/zz_base_sliver_page.dart';
import 'package:zzkit_flutter/standard/allinone/zz_brick.dart';
import 'package:zzkit_flutter/standard/allinone/zz_list_delegate.dart';
import 'package:get/get.dart';

class Goods {
  final int id;
  final String title;
  final String image;

  Goods(this.id, this.title, this.image);
}

class GoodsBrick extends ZZBrick<Goods> {
  const GoodsBrick(super.data, {super.key});

  @override
  State createState() => _GoodsBrickState();
}

class _GoodsBrickState extends ZZBrickState<Goods, GoodsBrick> {
  @override
  Widget build(BuildContext context) {
    if (data.title.contains("3") ||
        data.title.contains("5") ||
        data.title.contains("9")) {
      return Text(
        "HHHHH " + data.title,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      );
    }
    return Column(children: [Image.network(data.image), Text(data.title)]);
  }
}

class GoodsDelegate extends ZZListDelegate<Goods> {
  @override
  Widget buildItem(Goods item, int index) {
    return GoodsBrick(item, key: ValueKey(item.id));
  }
}

class GoodsController extends ZZBaseListController<Goods> {
  @override
  Future<List<Goods>> loadData(int page) async {
    await Future.delayed(const Duration(seconds: 1));
    return List.generate(
      10,
      (i) => Goods(
        page * 100 + i,
        '商品 ${page * 10 + i}',
        'https://picsum.photos/200/300?random=${page * 10 + i}',
      ),
    );
  }
}

class GoodsPage extends ZZBaseSliverPage<Goods, GoodsController> {
  GoodsPage({super.key});

  @override
  final controller = Get.put(GoodsController());

  @override
  final delegate = GoodsDelegate();

  @override
  int get crossAxisCount => 2; // 1 = List, 2+ = 瀑布流
}
