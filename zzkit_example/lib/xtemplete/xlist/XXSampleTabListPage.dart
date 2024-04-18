// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:zzkit_example/xtemplete/xlist/XXSampleListPage.dart';
import 'package:zzkit_flutter/standard/scaffold/ZZBaseScaffold.dart';
import 'package:zzkit_flutter/util/core/ZZAppConsts.dart';
import 'package:zzkit_flutter/util/core/ZZAppManager.dart';

class XXSampleTabListPage extends StatefulWidget {
  const XXSampleTabListPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return XXSampleTabListPageState();
  }
}

class XXSampleTabListPageState extends State<XXSampleTabListPage>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 7, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return ZZBaseScaffold(
      safeAreaBottom: false,
      appBar: ZZ.appbar(
          title: "Tab List",
          bottom: ZZ.tabbarUnderline(tabs: const [
            'Tab11111',
            'Tab2',
            'Tab33333',
            'Tab44444',
            'Tab55555',
            'Tab66666',
            'Tab77777',
          ], controller: tabController)),
      body: TabBarView(
        controller: tabController,
        children: List.generate(7, (index) {
          return XXSampleListPage(
              controller: XXSampleListController()
                ..refreshingText = "loading now"
                ..shimmer = true
                ..shimmerBrickHeight = 300
                ..brickMargin =
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5));
        }),
      ),
    );
  }
}
