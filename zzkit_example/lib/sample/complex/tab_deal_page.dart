// ignore_for_file: file_names, depend_on_referenced_packages, unused_import

import 'package:flutter/material.dart';
import 'package:zzkit_example/sample/complex/hot_page.dart';
import 'package:zzkit_example/sample/complex/latest_page.dart';
import 'package:zzkit_example/sample/complex/special_page.dart';
import 'package:get/get.dart';
import 'package:zzkit_example/sample/list/store_card_list_page.dart';
import 'package:zzkit_flutter/util/core/zz_const.dart';
import 'package:zzkit_flutter/util/core/zz_manager.dart';

class TabDealPage extends StatefulWidget {
  const TabDealPage({super.key});

  @override
  TabDealPageState createState() => TabDealPageState();
}

class TabDealPageState extends State<TabDealPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this, initialIndex: 1);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        bottom: ZZ.tabbarUnderline(
          tabAlignment: TabAlignment.fill,
          isScrollable: false,
          labelStyle: ZZ.textStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          unselectedLabelStyle: ZZ.textStyle(
            color: Colors.grey,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          tabs: ['关注', '最新', '热门', '专区'],
          controller: _tabController,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          StoreCardListPage(),
          const LatestPage(),
          const HotPage(),
          const SpecialPage(),
        ],
      ),
    );
  }
}
