// ignore_for_file: file_names, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zzkit_flutter/util/core/ZZConst.dart';
import 'package:zzkit_flutter/util/core/ZZManager.dart';

class ZZTabNavigationBar extends StatefulWidget {
  final List<BottomNavigationBarItem> items;
  final int currentIndex;

  final ValueChanged<int>? onTap;

  const ZZTabNavigationBar({
    super.key,
    required this.items,
    this.onTap,
    required this.currentIndex,
    required BottomNavigationBarType type,
    required Color backgroundColor,
  });

  @override
  State<StatefulWidget> createState() => ZZTabNavigationBarState();
}

class ZZTabNavigationBarState extends State<ZZTabNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60.w + zzBottomBarHeight,
      child: Row(
        children: widget.items
            .map((e) => Expanded(
                child: ZZTabIconWidget(
                    tabIconData: e,
                    isSelected: e == widget.items[widget.currentIndex],
                    onSelect: () {
                      widget.onTap?.call(widget.items.indexOf(e));
                    })))
            .toList(),
      ),
    );
  }
}

class ZZTabIconWidget extends StatefulWidget {
  const ZZTabIconWidget({
    super.key,
    required this.tabIconData,
    required this.isSelected,
    required this.onSelect,
  });

  final BottomNavigationBarItem tabIconData;
  final Function onSelect;
  final bool isSelected;

  @override
  TabIconsState createState() => TabIconsState();
}

class TabIconsState extends State<ZZTabIconWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!widget.isSelected) {
          widget.onSelect();
        }
      },
      child: Container(
        padding: EdgeInsets.only(bottom: zzBottomBarHeight / 2.0),
        color: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            widget.isSelected
                ? widget.tabIconData.activeIcon
                : widget.tabIconData.icon,
            if (widget.tabIconData.label != null &&
                widget.tabIconData.label!.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(top: 4.w),
                child: Text(
                  widget.tabIconData.label!,
                  style: widget.isSelected
                      ? ZZ.textStyle(
                          color: ZZColor.red,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold)
                      : ZZ.textStyle(color: ZZColor.dark, fontSize: 12.sp),
                ),
              )
          ],
        ),
      ),
    );
  }
}
