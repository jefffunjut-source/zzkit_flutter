// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:zzkit_example/sample/list/store_card_list_page.dart';
import 'package:zzkit_flutter/standard/page/zz_base_scaffold.dart';
import 'package:zzkit_flutter/util/core/zz_const.dart';
import 'package:zzkit_flutter/util/core/zz_manager.dart';

class TabListPage extends StatefulWidget {
  const TabListPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return TabListPageState();
  }
}

class TabListPageState extends State<TabListPage>
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
        bottom: ZZ.tabbarUnderline(
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
        children: List.generate(7, (index) {
          return StoreCardListPage();
        }),
      ),
    );
  }
}
