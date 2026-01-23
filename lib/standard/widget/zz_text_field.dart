import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zzkit_flutter/r.dart';
import 'package:zzkit_flutter/util/zz_const.dart';
import 'package:zzkit_flutter/util/zz_manager.dart';

typedef ZZTextFieldChanged = void Function(String text);

class ZZTextField extends StatefulWidget {
  final TextEditingController controller;
  final int maxLength;
  final int? maxLines;
  final bool autoFocus;
  final TextInputType keyboardType;
  final String hintText;
  final FocusNode? focusNode;
  final TextInputAction textInputAction;
  final bool enabled;

  // 基础功能
  final bool enableClearIcon;
  final bool enableEncryption;
  final bool enableEncryptionIcon;

  // 样式
  final EdgeInsetsGeometry? contentPadding;
  final double sidePadding;
  final TextStyle? style;
  final TextStyle? hintStyle;
  final TextAlign textAlign;
  final TextAlignVertical textAlignVertical;
  final bool? filled;
  final Color? fillColor;
  final Color? focusedBorderColor;
  final Color? enabledBorderColor;
  final OutlineInputBorder? outlineInputBorder;

  // 新增功能
  final Widget? prefixWidget;
  final Widget? suffixWidget;
  final ZZTextFieldChanged? onChanged;
  final ValueChanged<String>? onSubmitted;
  final GestureTapCallback? onTap;

  const ZZTextField({
    super.key,
    required this.controller,
    this.maxLength = 50,
    this.maxLines = 1,
    this.autoFocus = false,
    this.keyboardType = TextInputType.text,
    this.hintText = "",
    this.focusNode,
    this.textInputAction = TextInputAction.done,
    this.enabled = true,
    this.enableClearIcon = false,
    this.enableEncryption = false,
    this.enableEncryptionIcon = false,
    this.contentPadding,
    this.sidePadding = 12,
    this.style,
    this.hintStyle,
    this.textAlign = TextAlign.start,
    this.textAlignVertical = TextAlignVertical.top,
    this.filled = false,
    this.fillColor,
    this.focusedBorderColor,
    this.enabledBorderColor,
    this.outlineInputBorder,
    this.prefixWidget,
    this.suffixWidget,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
  });

  @override
  State<ZZTextField> createState() => _ZZTextFieldState();
}

class _ZZTextFieldState extends State<ZZTextField> {
  bool passwordVisible = false;
  bool showClearIcon = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_updateClearIcon);
  }

  void _updateClearIcon() {
    if (!mounted) return;
    setState(() {
      showClearIcon = widget.controller.text.isNotEmpty;
    });
    widget.onChanged?.call(widget.controller.text);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_updateClearIcon);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (widget.prefixWidget != null) widget.prefixWidget!,
        Expanded(
          child: TextField(
            controller: widget.controller,
            focusNode: widget.focusNode,
            maxLength: widget.maxLength,
            maxLines: widget.maxLines,
            autofocus: widget.autoFocus,
            enabled: widget.enabled,
            textInputAction: widget.textInputAction,
            keyboardType: widget.keyboardType,
            textAlign: widget.textAlign,
            textAlignVertical: widget.textAlignVertical,
            obscureText: widget.enableEncryption ? !passwordVisible : false,
            style: widget.style,
            onSubmitted: widget.onSubmitted,
            onTap: widget.onTap,
            inputFormatters:
                (widget.keyboardType == TextInputType.number ||
                        widget.keyboardType == TextInputType.phone)
                    ? [FilteringTextInputFormatter.allow(RegExp("[0-9]"))]
                    : null,
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: widget.hintStyle,
              counterText: "",
              contentPadding:
                  widget.contentPadding ??
                  EdgeInsets.symmetric(
                    horizontal: widget.sidePadding,
                    vertical: 12.w,
                  ),
              filled: widget.filled,
              fillColor: widget.fillColor,
              focusedBorder:
                  widget.focusedBorderColor != null
                      ? UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: widget.focusedBorderColor!,
                          width: 0.8,
                        ),
                      )
                      : null,
              enabledBorder:
                  widget.enabledBorderColor != null
                      ? UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: widget.enabledBorderColor!,
                          width: 0.8,
                        ),
                      )
                      : null,
              border:
                  widget.outlineInputBorder ??
                  const OutlineInputBorder(borderSide: BorderSide.none),
            ),
          ),
        ),
        if (widget.enableClearIcon) _buildClearIcon(),
        if (widget.enableEncryption && widget.enableEncryptionIcon)
          _buildPasswordToggle(),
        if (widget.suffixWidget != null) widget.suffixWidget!,
      ],
    );
  }

  Widget _buildClearIcon() {
    return Offstage(
      offstage: !showClearIcon,
      child: Padding(
        padding: EdgeInsets.only(right: widget.sidePadding / 2),
        child: InkWell(
          onTap: () => widget.controller.clear(),
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          child: ZZ.image(
            R.assetsImgIcTextfieldDelete,
            bundleName: zzBundleName,
            width: 20.w,
            height: 20.w,
            fit: BoxFit.fitWidth,
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordToggle() {
    return Padding(
      padding: EdgeInsets.only(right: widget.sidePadding),
      child: InkWell(
        onTap: () => setState(() => passwordVisible = !passwordVisible),
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        child: ZZ.image(
          passwordVisible
              ? R.assetsImgIcTextfieldPasswordOn
              : R.assetsImgIcTextfieldPasswordOff,
          bundleName: zzBundleName,
          width: 20.w,
          height: 20.w,
          fit: BoxFit.fitWidth,
        ),
      ),
    );
  }
}
