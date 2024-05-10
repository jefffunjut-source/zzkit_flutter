// ignore_for_file: file_names, depend_on_referenced_packages

import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:loading_more_list/loading_more_list.dart';
import 'package:zzkit_example/r.dart';
import 'package:zzkit_flutter/util/core/ZZConst.dart';
import 'package:zzkit_flutter/util/core/ZZManager.dart';

class XXLoadMorePage extends StatefulWidget {
  const XXLoadMorePage({super.key});

  @override
  XXLoadMoreState createState() => XXLoadMoreState();
}

class XXLoadMoreState extends State<XXLoadMorePage>
    with TickerProviderStateMixin {
  late final TabController primaryTC;
  final GlobalKey<ExtendedNestedScrollViewState> _key =
      GlobalKey<ExtendedNestedScrollViewState>();

  @override
  void initState() {
    super.initState();
    primaryTC = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    primaryTC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildScaffoldBody(),
    );
  }

  Widget _buildScaffoldBody() {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    final double pinnedHeaderHeight =
        //statusBar height
        statusBarHeight +
            //pinned SliverAppBar height in header
            kToolbarHeight;
    return ExtendedNestedScrollView(
      key: _key,
      headerSliverBuilder: (BuildContext c, bool f) {
        return <Widget>[
          SliverAppBar(
              pinned: true,
              expandedHeight: 200.0,
              title: const Text('load more list'),
              flexibleSpace: FlexibleSpaceBar(
                  //centerTitle: true,
                  collapseMode: CollapseMode.pin,
                  background:
                      ZZ.image(R.assetsImgIcTransparent, fit: BoxFit.fill)))
        ];
      },
      //1.[pinned sliver header issue](https://github.com/flutter/flutter/issues/22393)
      pinnedHeaderSliverHeightBuilder: () {
        return pinnedHeaderHeight;
      },
      //2.[inner scrollables in tabview sync issue](https://github.com/flutter/flutter/issues/21868)
      onlyOneScrollInBody: true,
      body: Column(
        children: <Widget>[
          TabBar(
            controller: primaryTC,
            labelColor: Colors.blue,
            indicatorColor: Colors.blue,
            indicatorSize: TabBarIndicatorSize.label,
            indicatorWeight: 2.0,
            isScrollable: false,
            unselectedLabelColor: Colors.grey,
            tabs: const <Tab>[
              Tab(text: 'Tab0'),
              Tab(text: 'Tab1'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: primaryTC,
              children: const <Widget>[
                XXTabViewItem(Key('Tab0')),
                XXTabViewItem(Key('Tab1')),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class XXLoadMoreListSource extends LoadingMoreBase<int> {
  @override
  Future<bool> loadData([bool isLoadMoreAction = false]) {
    return Future<bool>.delayed(const Duration(seconds: 1), () {
      for (int i = 0; i < 10; i++) {
        add(0);
      }

      return true;
    });
  }
}

class XXTabViewItem extends StatefulWidget {
  const XXTabViewItem(this.uniqueKey, {super.key});
  final Key uniqueKey;
  @override
  XXTabViewItemState createState() => XXTabViewItemState();
}

class XXTabViewItemState extends State<XXTabViewItem>
    with AutomaticKeepAliveClientMixin {
  late final XXLoadMoreListSource source = XXLoadMoreListSource();

  @override
  void dispose() {
    source.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final Widget child = ExtendedVisibilityDetector(
        uniqueKey: widget.uniqueKey,
        child: LoadingMoreList<int>(
          ListConfig<int>(
            sourceList: source,
            itemBuilder: (BuildContext c, int item, int index) {
              return Container(
                alignment: Alignment.center,
                height: 60.0,
                child: Text(': ListView$index'),
              );
            },
          ),
        ));
    return child;
  }
}
