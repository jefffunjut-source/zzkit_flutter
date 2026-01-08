// ignore_for_file: file_names, depend_on_referenced_packages, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:zzkit_flutter/standard/page/ZZKeepAliveWidget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:easy_refresh/easy_refresh.dart';

class NestedScrollTabPage2 extends StatefulWidget {
  const NestedScrollTabPage2({super.key});

  @override
  NestedScrollTabPage2State createState() => NestedScrollTabPage2State();
}

class NestedScrollTabPage2State extends State<NestedScrollTabPage2>
    with SingleTickerProviderStateMixin {
  RefreshController refreshController = RefreshController();
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
                expandedHeight: 600.0,
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.pin,
                  background: Column(
                    children: [
                      Container(height: 200.0, color: Colors.red),
                      Container(height: 200.0, color: Colors.black),
                      Container(height: 200.0, color: Colors.purple),
                    ],
                  ),
                ),
                bottom: const TabBar(
                  tabs: [Tab(text: 'Page 1'), Tab(text: 'Page 2')],
                ),
              ),
            ];
          },
          body: const TabBarView(
            children: [
              ZZKeepAliveWidget(child: Page1()),
              ZZKeepAliveWidget(child: Page2()),
            ],
          ),
        ),
      ),
    );
  }
}

class Page1 extends StatelessWidget {
  const Page1({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        // SliverAppBar(
        //   title: Text('SliverAppBar'),
        //   floating: true,
        //   pinned: true,
        //   expandedHeight: 200,
        //   flexibleSpace: FlexibleSpaceBar(
        //     background: Image.network(
        //       'https://via.placeholder.com/500',
        //       fit: BoxFit.cover,
        //     ),
        //   ),
        // ),
        SliverList(
          delegate: SliverChildBuilderDelegate((
            BuildContext context,
            int index,
          ) {
            return ListTile(title: Text('Item $index'));
          }, childCount: 100),
        ),
      ],
    );
  }
}

class Page2 extends StatelessWidget {
  const Page2({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        // SliverAppBar(
        //   title: Text('SliverAppBar'),
        //   floating: true,
        //   pinned: true,
        //   expandedHeight: 200,
        //   flexibleSpace: FlexibleSpaceBar(
        //     background: Image.network(
        //       'https://via.placeholder.com/500',
        //       fit: BoxFit.cover,
        //     ),
        //   ),
        // ),
        SliverList(
          delegate: SliverChildBuilderDelegate((
            BuildContext context,
            int index,
          ) {
            return ListTile(title: Text('Item $index'));
          }, childCount: 120),
        ),
      ],
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return EasyRefresh(
      onRefresh: () async {
        // Your refresh logic here
      },
      child: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              const SliverAppBar(
                title: Text('TabBar Example'),
                pinned: true,
                floating: true,
                bottom: TabBar(tabs: [Tab(text: 'Tab 1'), Tab(text: 'Tab 2')]),
              ),
            ];
          },
          body: TabBarView(
            children: [
              // Your tab content for Tab 1
              ListView.builder(
                itemCount: 50,
                itemBuilder: (context, index) {
                  return ListTile(title: Text('Item $index'));
                },
              ),
              // Your tab content for Tab 2
              ListView.builder(
                itemCount: 50,
                itemBuilder: (context, index) {
                  return ListTile(title: Text('Item $index'));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
