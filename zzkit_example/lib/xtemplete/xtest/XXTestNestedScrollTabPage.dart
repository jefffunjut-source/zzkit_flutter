// ignore_for_file: file_names, depend_on_referenced_packages, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:zzkit_example/xtemplete/xlist/XXSampleListPage.dart';

double TabHeight = 48.0;

class XXTestNestedScrollTabPage extends StatefulWidget {
  const XXTestNestedScrollTabPage({super.key});

  @override
  XXTestNestedScrollTabPageState createState() =>
      XXTestNestedScrollTabPageState();
}

class XXTestNestedScrollTabPageState extends State<XXTestNestedScrollTabPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                floating: true,
                pinned: true, // 设置为true，头部会固定在顶部
                expandedHeight: 1200.0,
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.pin,
                  background: Column(
                    children: [
                      Container(
                        height: 200.0,
                        color: Colors.red,
                      ),
                      Container(
                        height: 200.0,
                        color: Colors.black,
                      ),
                      Container(
                        height: 200.0,
                        color: Colors.purple,
                      ),
                      Container(
                        height: 600.0,
                        color: Colors.pink,
                      ),
                    ],
                  ),
                ),
                bottom: const TabBar(
                  tabs: [
                    Tab(text: 'Page 1'),
                    Tab(text: 'Page 2'),
                  ],
                ),
              ),
            ];
          },
          body: TabBarView(
            children: [
              XXSampleListPage(
                controller: XXSampleListController()
                  ..refreshingText = "loading now"
                  ..shimmer = true
                  ..shimmerBrickHeight = 320
                  ..shimmerCustomWidget = widget
                  ..brickMargin =
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              ),
              XXSampleListPage(
                controller: XXSampleListController()
                  ..refreshingText = "loading now"
                  ..shimmer = true
                  ..shimmerBrickHeight = 320
                  ..shimmerCustomWidget = widget
                  ..brickMargin =
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              )
            ],
          ),
        ),
      ),
    );
  }
}
