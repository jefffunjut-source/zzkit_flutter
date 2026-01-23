// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
// ignore_for_file: file_names, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zzkit_flutter/standard/page/zz_bootup_page.dart';
import 'package:zzkit_flutter/util/core/zz_const.dart';
import 'package:zzkit_flutter/util/core/zz_manager.dart';
import 'package:get/get.dart';

class ZZTabNavigationBar extends StatefulWidget {
  final BottomNavigationBarType type;
  final Color backgroundColor;
  final List<BottomNavigationBarItem> items;
  final int currentIndex;

  final ValueChanged<int>? onTap;

  const ZZTabNavigationBar({
    super.key,
    required this.type,
    required this.backgroundColor,
    required this.items,
    required this.currentIndex,
    this.onTap,
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
        children:
            widget.items
                .map(
                  (e) => Expanded(
                    child: ZZTabIconWidget(
                      tabIconData: e,
                      isSelected: e == widget.items[widget.currentIndex],
                      onSelect: () {
                        widget.onTap?.call(widget.items.indexOf(e));
                      },
                    ),
                  ),
                )
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
  ZZTabIconWidgetState createState() => ZZTabIconWidgetState();
}

class ZZTabIconWidgetState extends State<ZZTabIconWidget> {
  @override
  Widget build(BuildContext context) {
    ZZBootupController bootupController = Get.find();
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
                  style:
                      widget.isSelected
                          ? bootupController.tabbarItemSelectedTextStyle ??
                              ZZ.textStyle(
                                color: ZZColor.red,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.bold,
                              )
                          : bootupController.tabbarItemNormalTextStyle ??
                              ZZ.textStyle(
                                color: ZZColor.dark,
                                fontSize: 12.sp,
                              ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
