// ignore_for_file: must_be_immutable, file_names

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:zzkit_flutter/util/ZZExtension.dart';

class ZZInfiniteScrollWidget extends StatefulWidget {
  List<Widget>? widgets;
  double? height;
  double? width;
  Color? backgroundColor;
  Axis scrollDirection;
  bool? dragScroll;
  int visibleItems;
  int autoScrolllMilliseconds;
  int animationDurationMilliseconds;

  ZZInfiniteScrollWidget(
      {super.key,
      required this.widgets,
      this.height = 100,
      this.width,
      this.backgroundColor,
      this.scrollDirection = Axis.horizontal,
      this.dragScroll = true,
      this.visibleItems = 3,
      this.autoScrolllMilliseconds = 3000,
      this.animationDurationMilliseconds = 500});

  @override
  State<StatefulWidget> createState() {
    return ZZInfiniteScrollWidgetState();
  }
}

class ZZInfiniteScrollWidgetState extends State<ZZInfiniteScrollWidget> {
  PageController? _pageController;
  List<Widget>? _data;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _initail();
    return _data != null && _data!.isNotEmpty
        ? Container(
            height: widget.height,
            width: widget.width,
            color: widget.backgroundColor,
            child: PageView.builder(
              physics: widget.dragScroll == true
                  ? null
                  : const NeverScrollableScrollPhysics(),
              reverse: false,
              scrollDirection: widget.scrollDirection,
              controller: _pageController,
              // 卡片总数，设置一个较大的值以实现无限滚动
              itemCount: _data!.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  elevation: 0,
                  color: Colors.white,
                  // 设置透明背景
                  shape: const RoundedRectangleBorder(
                    // 去除圆角
                    borderRadius: BorderRadius.zero,
                  ),
                  child: Container(
                    color: Colors.transparent,
                    child: _data![index],
                  ),
                );
              },
            ),
          )
        : Container();
  }

  void _initail() {
    if (widget.widgets != null && widget.widgets!.isNotEmpty) {
      setState(() {
        _data = widget.widgets!.multiple(
              times: 10,
              leastTims: 3,
            ) ??
            [];
      });
      int centerIndex = widget.widgets!.length *
          (_data!.length ~/ widget.widgets!.length ~/ 2);
      int initialOffset = widget.visibleItems ~/ 2;
      int reverseOffset = widget.widgets!.length - initialOffset;
      centerIndex += initialOffset;

      _pageController?.dispose();
      _pageController = PageController(
          // 显示itemPerGroup张卡片
          viewportFraction: 1 / widget.visibleItems,
          initialPage: centerIndex)
        ..addListener(() {
          double left = (_pageController!.page! - initialOffset).abs();
          double left2 = (_pageController!.page! -
                  (initialOffset + widget.widgets!.length))
              .abs();
          double right =
              (_pageController!.page! - (_data!.length - reverseOffset)).abs();
          double right2 = (_pageController!.page! -
                  (_data!.length - reverseOffset - widget.widgets!.length))
              .abs();
          // debugPrint("page:${_pageController!.page} left: $left  left2: $left2   right: $right  right2: $right2  center:$centerIndex");
          if (left < 0.1 || left2 < 0.1 || right < 0.1 || right2 < 0.1) {
            _pageController?.jumpToPage(centerIndex);
          }
        });
      if (widget.autoScrolllMilliseconds > 0) {
        _timer?.cancel();
        _timer = Timer.periodic(
            Duration(milliseconds: widget.autoScrolllMilliseconds), (timer) {
          if (isStopped()) {
            // print("静止");
          } else {
            // print("滑动中");
            return;
          }
          int nextpage = _pageController!.page!.toInt() + 1;
          _pageController?.animateToPage(
            nextpage,
            duration:
                Duration(milliseconds: widget.animationDurationMilliseconds),
            curve: Curves.easeInOut,
          );
        });
      }
    }
  }

  bool isStopped() {
    double fraction = (_pageController?.page ?? 0) % 1.0;
    if (fraction < 0.01) {
      return true;
    }
    return false;
  }
}
