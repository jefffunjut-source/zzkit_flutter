// ignore_for_file: file_names, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:zzkit_example/sample/list/store_card_waterfall_page.dart';
import 'package:zzkit_flutter/standard/scaffold/ZZBaseScaffold.dart';
import 'package:zzkit_flutter/util/core/ZZConst.dart';
import 'package:zzkit_flutter/util/core/ZZManager.dart';

class TabWaterfallPage extends StatefulWidget {
  const TabWaterfallPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return TabWaterfallPageState();
  }
}

class TabWaterfallPageState extends State<TabWaterfallPage>
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
        bottom: ZZ.tabbarRoundedRectangle(
          tabs: const [
            'Tab11111',
            'Tab2',
            'Tab33333',
            'Tab44444',
            'Tab55555',
            'Tab66666',
            'Tab77777',
          ],
          controller: tabController,
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          StoreCardWaterfallPage(),
          StoreCardWaterfallPage(),
          StoreCardWaterfallPage(),
          StoreCardWaterfallPage(),
          StoreCardWaterfallPage(),
          StoreCardWaterfallPage(),
          StoreCardWaterfallPage(),
        ],
      ),
    );
  }
}
