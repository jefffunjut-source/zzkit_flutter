// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:zzkit_example/xtemplete/xcomplex/XXHotSubPage.dart';
import 'package:zzkit_flutter/standard/scaffold/ZZBaseScaffold.dart';
import 'package:zzkit_flutter/util/core/ZZConst.dart';
import 'package:zzkit_flutter/util/core/ZZManager.dart';

class XXHotPage extends StatefulWidget {
  const XXHotPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return XXHotPageState();
  }
}

class XXHotPageState extends State<XXHotPage>
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
      appBar: ZZ.tabbarUnderline(tabs: const [
        'Tab11111',
        'Tab2',
        'Tab33333',
        'Tab44444',
        'Tab55555',
        'Tab66666',
        'Tab77777',
      ], controller: tabController),
      body: TabBarView(
        controller: tabController,
        children: List.generate(7, (index) {
          return XXHotSubPage(
              controller: XXHotSubPageController()
                ..shimmer = true
                ..shimmerBrickHeight = 300
                ..brickMargin =
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5));
        }),
      ),
    );
  }
}
