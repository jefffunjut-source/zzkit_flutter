// ignore_for_file: file_names, duplicate_import
// ignore_for_file: depend_on_referenced_packages, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:loading_more_list/loading_more_list.dart';
import 'package:pull_to_refresh_notification/pull_to_refresh_notification.dart';
import 'package:zzkit_example/xtemplete/xcomplex/XXPullToRefreshHeader.dart';
import 'package:zzkit_example/xtemplete/xcomplex/XXSpecialSubPage.dart';
import 'package:zzkit_flutter/util/core/ZZAppConsts.dart';

class XXScrollToTopEvent {}

class XXSpecialPage extends StatefulWidget {
  const XXSpecialPage({super.key});

  @override
  XXSpecialPageState createState() => XXSpecialPageState();
}

class XXSpecialPageState extends State<XXSpecialPage>
    with TickerProviderStateMixin {
  late final TabController primaryTC;
  final GlobalKey<ExtendedNestedScrollViewState> _key =
      GlobalKey<ExtendedNestedScrollViewState>();
  DateTime lastRefreshTime = DateTime.now();
  List<String> tabs = ["Tab0", "Tab1", "Tab2", "Tab3"];
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    primaryTC = TabController(length: tabs.length, vsync: this);
    // Enable When Useing XXLatestSub1Page.dart
    zzEventBus.on<XXScrollToTopEvent>().listen((event) {
      _key.currentState?.innerController.jumpTo(1);
    });
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
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.account_balance_outlined),
        onPressed: () {
          // _key.currentState?.outerController.animateTo(
          //   0.0,
          //   duration: const Duration(seconds: 0),
          //   curve: Curves.easeIn,
          // );
          _key.currentState?.innerController.jumpTo(0.01);
        },
      ),
    );
  }

  Widget _buildScaffoldBody() {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    final double pinnedHeaderHeight =
        //statusBar height
        statusBarHeight +
            //pinned SliverAppBar height in header
            kToolbarHeight -
            kToolbarHeight;
    return PullToRefreshNotification(
      color: Colors.blue,
      onRefresh: () => Future<bool>.delayed(const Duration(seconds: 1), () {
        setState(() {
          lastRefreshTime = DateTime.now();
        });
        return true;
      }),
      maxDragOffset: maxDragOffset,
      child: GlowNotificationWidget(
        ExtendedNestedScrollView(
          key: _key,
          headerSliverBuilder: (BuildContext c, bool f) {
            return <Widget>[
              // const SliverAppBar(
              //   pinned: true,
              //   title: Text('pull to refresh in header'),
              // ),
              PullToRefreshContainer(
                (PullToRefreshScrollNotificationInfo? info) {
                  return SliverToBoxAdapter(
                    child: XXPullToRefreshHeader(info, lastRefreshTime),
                  );
                },
              ),
              SliverToBoxAdapter(
                child: Container(
                  color: Colors.cyan,
                  alignment: Alignment.center,
                  height: 100,
                  child: const Text('banner'),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  color: Colors.deepPurple,
                  alignment: Alignment.center,
                  height: 140,
                  child: const Text('guider'),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  color: Colors.orange,
                  alignment: Alignment.center,
                  height: 100,
                  child: const Text('icons'),
                ),
              ),
            ];
          },
          //1.[pinned sliver header issue](https://github.com/flutter/flutter/issues/22393)
          pinnedHeaderSliverHeightBuilder: () {
            return pinnedHeaderHeight;
          },
          body: Column(
            children: <Widget>[
              TabBar(
                onTap: (value) {},
                controller: primaryTC
                  ..addListener(() {
                    if (!primaryTC.indexIsChanging) {
                      _key.currentState?.innerController.jumpTo(0.01);
                      setState(() {
                        currentPage = primaryTC.index;
                      });
                    }
                  }),
                labelColor: Colors.blue,
                indicatorColor: Colors.blue,
                indicatorSize: TabBarIndicatorSize.label,
                indicatorWeight: 2.0,
                isScrollable: false,
                unselectedLabelColor: Colors.grey,
                tabs: tabs.map((txt) => Tab(text: txt)).toList(),
              ),
              Expanded(
                child: singleView(tabs[currentPage]),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget singleView(String name) {
    return XXSpecialSubPage(name: name);
  }
}
