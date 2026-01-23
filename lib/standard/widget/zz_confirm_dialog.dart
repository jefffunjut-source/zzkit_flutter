import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zzkit_flutter/standard/widget/zz_dialog.dart';
import 'package:zzkit_flutter/util/core/zz_const.dart';
import 'package:zzkit_flutter/util/core/zz_manager.dart';

/// 确认对话框
class ZZConfirmDialog extends ZZDialog {
  /// 内容文本
  final String? content;

  /// 内容样式
  final TextStyle? contentStyle;

  /// 是否允许点击外部区域关闭
  final bool? allowDismiss;

  /// 标题样式
  final TextStyle? _titleStyle;

  /// 构造函数
  ZZConfirmDialog(
    super.context, {
    String? title,
    required this.content,
    TextStyle? titleStyle,
    this.contentStyle,
    String? leftText,
    String? rightText,
    this.allowDismiss,
  }) : _titleStyle = titleStyle {
    // 设置父类的标题
    this.title = title;
  }

  @override
  TextStyle get titleTextStyle {
    return _titleStyle ??
        ZZ.textStyle(
          color: ZZColor.dark,
          fontSize: 16.sp,
          fontWeight: FontWeight.bold,
        );
  }

  @override
  List<Widget> get contentWidgets {
    return [
      SizedBox(
        width: 366.w,
        child: IntrinsicHeight(
          child: Column(
            children: [
              if (!ZZ.isNullOrEmpty(super.title))
                Container(
                  height: 30.w,
                  margin: EdgeInsets.only(top: 20.w),
                  child: Text(super.title!, style: titleTextStyle),
                ),
              if (!ZZ.isNullOrEmpty(content))
                Container(
                  margin: EdgeInsets.only(
                    left: 10.w,
                    right: 10.w,
                    bottom: 20.w,
                    top: ZZ.isNullOrEmpty(super.title) ? 24.w : 10.w,
                  ),
                  child: RichText(
                    text: TextSpan(
                      style:
                          contentStyle ??
                          ZZ.textStyle(
                            color: ZZColor.grey33,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            height: 1.6,
                          ),
                      children: [TextSpan(text: content)],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    ];
  }

  @override
  double get contentHeight {
    // 简化的高度计算，实际可以根据内容动态计算
    return 200.0;
  }

  @override
  Color get contentBackgroundColor => Colors.white;

  @override
  double get radius => 8.w;

  @override
  ZZDialogType get dialogType => ZZDialogType.centerDialog;

  @override
  bool get dismissible => allowDismiss ?? false;
}
