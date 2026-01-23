import 'dart:async';
import 'package:flutter/material.dart';
import 'package:zzkit_flutter/util/zz_extension.dart';

class ZZInfiniteScrollWidget extends StatefulWidget {
  final List<Widget> widgets;
  final double height;
  final double? width;
  final Color? backgroundColor;
  final Axis scrollDirection;
  final bool dragScroll;
  final int visibleItems;
  final int autoScrollMilliseconds;
  final int animationDurationMilliseconds;

  const ZZInfiniteScrollWidget({
    super.key,
    required this.widgets,
    this.height = 100,
    this.width,
    this.backgroundColor,
    this.scrollDirection = Axis.horizontal,
    this.dragScroll = true,
    this.visibleItems = 3,
    this.autoScrollMilliseconds = 3000,
    this.animationDurationMilliseconds = 500,
  });

  @override
  State<ZZInfiniteScrollWidget> createState() => _ZZInfiniteScrollWidgetState();
}

class _ZZInfiniteScrollWidgetState extends State<ZZInfiniteScrollWidget> {
  late PageController _pageController;
  late List<Widget> _data;
  Timer? _timer;
  late int _centerIndex;
  late int _initialOffset;
  late int _reverseOffset;

  @override
  void initState() {
    super.initState();
    _initData();
    _initPageController();
    _initAutoScroll();
  }

  @override
  void didUpdateWidget(covariant ZZInfiniteScrollWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.widgets != widget.widgets ||
        oldWidget.visibleItems != widget.visibleItems) {
      _timer?.cancel();
      _initData();
      _initPageController();
      _initAutoScroll();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_data.isEmpty) return const SizedBox.shrink();

    return Container(
      height: widget.height,
      width: widget.width,
      color: widget.backgroundColor,
      child: PageView.builder(
        physics:
            widget.dragScroll ? null : const NeverScrollableScrollPhysics(),
        scrollDirection: widget.scrollDirection,
        controller: _pageController,
        itemCount: _data.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 0,
            color: Colors.white,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
            child: Container(color: Colors.transparent, child: _data[index]),
          );
        },
      ),
    );
  }

  void _initData() {
    _data = widget.widgets.multiple(times: 10, leastTims: 3) ?? [];
    _initialOffset = widget.visibleItems ~/ 2;
    _reverseOffset = widget.widgets.length - _initialOffset;
    _centerIndex =
        widget.widgets.length * (_data.length ~/ widget.widgets.length ~/ 2) +
        _initialOffset;
  }

  void _initPageController() {
    _pageController = PageController(
      viewportFraction: 1 / widget.visibleItems,
      initialPage: _centerIndex,
    )..addListener(_pageListener);
  }

  void _initAutoScroll() {
    if (widget.autoScrollMilliseconds <= 0) return;

    _timer?.cancel();
    _timer = Timer.periodic(
      Duration(milliseconds: widget.autoScrollMilliseconds),
      (_) {
        if (!isStopped()) return;
        int nextPage = _pageController.page!.toInt() + 1;
        _pageController.animateToPage(
          nextPage,
          duration: Duration(
            milliseconds: widget.animationDurationMilliseconds,
          ),
          curve: Curves.easeInOut,
        );
      },
    );
  }

  void _pageListener() {
    final page = _pageController.page!;
    double left = (page - _initialOffset).abs();
    double left2 = (page - (_initialOffset + widget.widgets.length)).abs();
    double right = (page - (_data.length - _reverseOffset)).abs();
    double right2 =
        (page - (_data.length - _reverseOffset - widget.widgets.length)).abs();

    if (left < 0.1 || left2 < 0.1 || right < 0.1 || right2 < 0.1) {
      _pageController.jumpToPage(_centerIndex);
    }
  }

  bool isStopped() {
    double fraction = (_pageController.page ?? 0) % 1.0;
    return fraction < 0.01;
  }
}
