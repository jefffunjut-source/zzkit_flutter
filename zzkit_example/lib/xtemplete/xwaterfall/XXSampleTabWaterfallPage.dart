// ignore_for_file: file_names, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:zzkit_example/xtemplete/xwaterfall/XXSampleWaterfallPage.dart';
import 'package:zzkit_flutter/standard/scaffold/ZZBaseScaffold.dart';
import 'package:zzkit_flutter/util/core/ZZAppConsts.dart';
import 'package:zzkit_flutter/util/core/ZZAppManager.dart';

class XXSampleTabWaterfallPage extends StatefulWidget {
  const XXSampleTabWaterfallPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return XXSampleTabWaterfallPageState();
  }
}

class XXSampleTabWaterfallPageState extends State<XXSampleTabWaterfallPage>
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
          title: "Tab Waterfall",
          bottom: ZZ.tabbarRoundedRectangle(tabs: const [
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
        children: [
          XXSampleWaterfallPage(controller: XXSampleWaterfallController()),
          XXSampleWaterfallPage(controller: XXSampleWaterfallController()),
          XXSampleWaterfallPage(controller: XXSampleWaterfallController()),
          XXSampleWaterfallPage(controller: XXSampleWaterfallController()),
          XXSampleWaterfallPage(controller: XXSampleWaterfallController()),
          XXSampleWaterfallPage(controller: XXSampleWaterfallController()),
          XXSampleWaterfallPage(controller: XXSampleWaterfallController())
        ],
      ),
    );
  }
}
