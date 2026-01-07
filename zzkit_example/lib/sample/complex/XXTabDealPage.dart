// ignore_for_file: file_names, depend_on_referenced_packages, unused_import

import 'package:flutter/material.dart';
import 'package:zzkit_example/sample/complex/XXFollowingPage.dart';
import 'package:zzkit_example/sample/complex/XXHotPage.dart';
import 'package:zzkit_example/sample/complex/XXLatestPage.dart';
import 'package:zzkit_example/sample/complex/XXSpecialPage.dart';
import 'package:get/get.dart';
import 'package:zzkit_flutter/util/core/ZZConst.dart';
import 'package:zzkit_flutter/util/core/ZZManager.dart';

class XXTabDealPage extends StatefulWidget {
  const XXTabDealPage({super.key});

  @override
  XXTabDealPageState createState() => XXTabDealPageState();
}

class XXTabDealPageState extends State<XXTabDealPage>
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
          XXFollowingPage(controller: XXFollowingController()),
          const XXLatestPage(),
          const XXHotPage(),
          const XXSpecialPage(),
        ],
      ),
    );
  }
}
