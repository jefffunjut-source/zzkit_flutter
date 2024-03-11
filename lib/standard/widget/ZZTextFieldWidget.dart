// ignore_for_file: public_member_api_docs, sort_constructors_first, file_names
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zzkit_flutter/r.dart';
import 'package:zzkit_flutter/util/ZZExtension.dart';
import 'package:zzkit_flutter/util/core/ZZAppConsts.dart';

class ZZTextFieldWidget extends StatefulWidget {
  final TextEditingController controller;
  final int maxLength;
  final bool autoFocus;
  final TextInputType keyboardType;
  final String hintText;
  final FocusNode? focusNode;
  final TextInputAction textInputAction;
  final bool enabled;
  final bool enableClearIcon;
  final bool enableEncryption;
  final bool enableEncryptionIcon;
  final double contentPadding;
  final TextStyle? style;
  final TextStyle? hintStyle;
  final TextAlign textAlign;
  final Color? focusedBorderSizeColor;
  final Color? enabledBorderSizeColor;
  final bool? filled;
  final Color? fillColor;
  final OutlineInputBorder? outlineInputBorder;
  final ValueChanged<String>? onSubmitted;
  final GestureTapCallback? onTap;

  const ZZTextFieldWidget({
    super.key,
    required this.controller,
    this.maxLength = 50,
    this.autoFocus = false,
    this.keyboardType = TextInputType.text,
    this.hintText = "",
    this.focusNode,
    this.textInputAction = TextInputAction.done,
    this.enabled = true,
    this.enableClearIcon = false,
    this.enableEncryption = false,
    this.enableEncryptionIcon = false,
    this.contentPadding = 16.0,
    this.style,
    this.hintStyle,
    this.textAlign = TextAlign.start,
    this.focusedBorderSizeColor,
    this.enabledBorderSizeColor,
    this.filled = false,
    this.fillColor,
    this.outlineInputBorder,
    this.onSubmitted,
    this.onTap,
  });

  @override
  ZZTextFieldWidgetState createState() => ZZTextFieldWidgetState();
}

class ZZTextFieldWidgetState extends State<ZZTextFieldWidget> {
  bool _isShowPwd = false;
  bool _isShowDelete = true;

  @override
  void initState() {
    super.initState();
    //监听输入改变
    widget.controller.addListener(() {
      if (!mounted) return;
      setState(() {
        _isShowDelete = widget.controller.text.isEmpty;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Expanded(
          child: TextField(
            focusNode: widget.focusNode,
            maxLength: widget.maxLength,
            maxLines: 1,
            textAlign: widget.textAlign,
            obscureText: widget.enableEncryption ? !_isShowPwd : false,
            autofocus: widget.autoFocus,
            controller: widget.controller,
            style: widget.style,
            enabled: widget.enabled,
            textInputAction: widget.textInputAction,
            onSubmitted: widget.onSubmitted,
            onTap: widget.onTap,
            keyboardType: widget.keyboardType,
            inputFormatters: (widget.keyboardType == TextInputType.number ||
                    widget.keyboardType == TextInputType.phone)
                ? [FilteringTextInputFormatter.allow(RegExp("[0-9]"))]
                : [],
            decoration: InputDecoration(
              contentPadding: widget.enableClearIcon
                  ? EdgeInsets.only(
                      left: widget.contentPadding,
                      right: widget.contentPadding / 4)
                  : EdgeInsets.only(
                      left: widget.contentPadding,
                      right: widget.contentPadding),
              hintText: widget.hintText,
              hintStyle: widget.hintStyle,
              counterText: "",
              disabledBorder: null,
              focusedBorder: widget.focusedBorderSizeColor != null
                  ? UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: widget.focusedBorderSizeColor!, width: 0.8))
                  : null,
              enabledBorder: widget.enabledBorderSizeColor != null
                  ? UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: widget.enabledBorderSizeColor!, width: 0.8))
                  : null,
              border: widget.outlineInputBorder ??
                  const OutlineInputBorder(borderSide: BorderSide.none),
              filled: widget.filled,
              fillColor: widget.fillColor, //Color(0xffaaaaaa)
            ),
          ),
        ),
        Offstage(
          offstage: _isShowDelete,
          child: Padding(
            padding: !widget.enableEncryptionIcon || !widget.enableEncryption
                ? EdgeInsets.only(right: widget.contentPadding)
                : EdgeInsets.only(right: widget.contentPadding / 2),
            child: InkWell(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              child: widget.enableClearIcon
                  ? Image.asset(
                      R.assetsImgIcTextfieldDelete.addPrefix(zzPackagePrefix) ??
                          "",
                      width: 16.w,
                      height: 16.w,
                    )
                  : Container(),
              onTap: () {
                setState(() {
                  widget.controller.text = "";
                });
              },
            ),
          ),
        ),
        Offstage(
          offstage: !widget.enableEncryptionIcon || !widget.enableEncryption,
          child: Padding(
            padding: EdgeInsets.only(right: widget.contentPadding),
            child: InkWell(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              child: Image.asset(
                _isShowPwd
                    ? R.assetsImgIcTextfieldPasswordOn
                            .addPrefix(zzPackagePrefix) ??
                        ""
                    : R.assetsImgIcTextfieldPasswordOff
                            .addPrefix(zzPackagePrefix) ??
                        "",
                width: 24.w,
                height: 24.w,
              ),
              onTap: () {
                setState(() {
                  _isShowPwd = !_isShowPwd;
                });
              },
            ),
          ),
        ),
      ],
    );
  }
}
