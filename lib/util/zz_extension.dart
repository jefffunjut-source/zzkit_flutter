// ignore_for_file: file_names, empty_catches, unnecessary_library_name, deprecated_member_use

import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:characters/characters.dart';

/// 对象扩展
extension ZZExtensionObject on Object {
  String parse2String() => this is String ? this as String : toString();

  /// 将数字转换成带千分位和固定小数位的字符串
  String parse2NumericString({int point = 3}) {
    double number = double.tryParse(toString()) ?? 0;
    List<String> parts = number.toStringAsFixed(point).split('.');
    String integerPart = parts[0];
    String decimalPart = parts.length > 1 ? parts[1] : '0' * point;

    // 千分位处理
    final buffer = StringBuffer();
    for (int i = 0; i < integerPart.length; i++) {
      int positionFromRight = integerPart.length - i;
      buffer.write(integerPart[i]);
      if (positionFromRight > 1 && positionFromRight % 3 == 1) {
        buffer.write(',');
      }
    }
    return '${buffer.toString()}.${decimalPart.substring(0, point)}';
  }
}

/// 字符串扩展
extension ZZExtensionString on String {
  bool isNumeric() => double.tryParse(this) != null;

  bool isToday() {
    final now = DateTime.now();
    final todayString = "${now.month}/${now.day.parse2String(digit: 2)}";
    return this == todayString || this == "${now.month}/${now.day}";
  }

  bool isValidName() {
    final regex = RegExp(
      r"^[\u4e00-\u9fa5\u9fa6-\u9fef\u3400-\u4db5\u20000-\u2ebe0a-zA-Z0-9]+$",
    );
    return regex.hasMatch(this);
  }

  bool isValidPassWord() {
    final regex = RegExp(r"^[\w\=\*\!\@\#\$\%\^\&\(\)\-\+]{6,30}[!]?$");
    return regex.hasMatch(this);
  }

  bool isValidEmail() {
    final regex = RegExp(r"^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$");
    return regex.hasMatch(this);
  }

  bool isValidUrlEncode() {
    return ['+', ' ', '/', '?', '%', '#', '&', '='].contains(this);
  }

  String parse2FixedDigitsString(int digit) {
    String result = this;
    while (result.length < digit) {
      result = '0$result';
    }
    return result;
  }

  int parse2Int() {
    String cleaned = replaceFirst(RegExp(r'^0+'), '');
    return int.tryParse(cleaned) ?? 0;
  }

  double parse2Double() {
    String cleaned = replaceFirst(RegExp(r'^0+'), '');
    return double.tryParse(cleaned) ?? 0;
  }

  String parse2MD5String() => md5.convert(utf8.encode(this)).toString();

  Map<String, dynamic>? parse2Map() {
    try {
      return json.decode(this);
    } catch (_) {
      return null;
    }
  }

  T? parse2Object<T>(T Function(Map<String, dynamic>) fromJson) {
    try {
      final map = parse2Map();
      if (map != null) return fromJson(map);
    } catch (_) {}
    return null;
  }

  String parse2UrlEncodeString() {
    final sb = StringBuffer();
    for (final char in characters) {
      sb.write(char.isValidUrlEncode() ? Uri.encodeComponent(char) : char);
    }
    return sb.toString();
  }

  String parse2DollarString() => contains('\$') ? this : '\$ $this';

  Color parse2Color() {
    try {
      final hex = replaceFirst('#', '');
      if (hex.length < 6) return Colors.white;
      final buffer = StringBuffer();
      if (hex.length == 6 || hex.length == 7) buffer.write('ff');
      buffer.write(hex);
      final colorInt = int.parse(buffer.toString(), radix: 16);
      return Color(colorInt > 0 ? colorInt : 0xFFFFFFFF);
    } catch (_) {
      return Colors.white;
    }
  }

  String addPrefix(String str) => "$str$this";

  String append(String str) => "$this$str";

  String plus(int number) => "${parse2Int() + number}";

  String minus(int number) => "${parse2Int() - number}";

  Color? toColor() {
    try {
      if (isEmpty) return null;
      final hexString = replaceAll("#", "");
      final int hexValue = int.parse(hexString, radix: 16);
      final red = (hexValue >> 16) & 0xFF;
      final green = (hexValue >> 8) & 0xFF;
      final blue = hexValue & 0xFF;
      return Color.fromARGB(255, red, green, blue);
    } catch (_) {
      return null;
    }
  }

  String? desensitize({int keepPrefixLength = 3, int keepSuffixLength = 2}) {
    if (isEmpty || length <= keepPrefixLength + keepSuffixLength) return this;
    final prefix = substring(0, keepPrefixLength);
    final suffix = substring(length - keepSuffixLength);
    final mask = '*' * (length - keepPrefixLength - keepSuffixLength);
    return "$prefix$mask$suffix";
  }

  bool isValidChineseIDCard() {
    if (isEmpty) return false;
    final trimmed = replaceAll(RegExp(r'\s+'), '');
    final idRegex = RegExp(
      r'^([1-9]\d{5}(18|19|20)\d{2}(0[1-9]|1[0-2])(0[1-9]|[12]\d|3[01])\d{3}(\d|X|x))|([1-9]\d{5}\d{2}(0[1-9]|1[0-2])(0[1-9]|[12]\d|3[01])\d{3})$',
    );
    if (!idRegex.hasMatch(trimmed)) return false;
    if (trimmed.length == 18) {
      const weights = [7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2];
      const checkCodes = [
        '1',
        '0',
        'X',
        '9',
        '8',
        '7',
        '6',
        '5',
        '4',
        '3',
        '2',
      ];
      int sum = 0;
      for (int i = 0; i < 17; i++) sum += int.parse(trimmed[i]) * weights[i];
      final checkCode = checkCodes[sum % 11];
      if (trimmed[17].toUpperCase() != checkCode) return false;
    }
    return true;
  }

  bool isValidUnionPayDebitCard() {
    final trimmed = replaceAll(RegExp(r'\s+'), '');
    if (![16, 18, 19].contains(trimmed.length)) return false;
    if (!RegExp(r'^\d+$').hasMatch(trimmed)) return false;
    int sum = 0;
    bool doubleNext = false;
    for (int i = trimmed.length - 1; i >= 0; i--) {
      int digit = int.parse(trimmed[i]);
      if (doubleNext) {
        digit *= 2;
        if (digit > 9) digit -= 9;
      }
      sum += digit;
      doubleNext = !doubleNext;
    }
    return sum % 10 == 0;
  }

  bool isValidCreditCardNumber() {
    final trimmed = replaceAll(RegExp(r'[^\d]'), '');
    if (trimmed.length < 13 || trimmed.length > 19) return false;
    int sum = 0;
    bool doubleNext = false;
    for (int i = trimmed.length - 1; i >= 0; i--) {
      int digit = int.parse(trimmed[i]);
      if (doubleNext) {
        digit *= 2;
        if (digit > 9) digit -= 9;
      }
      sum += digit;
      doubleNext = !doubleNext;
    }
    return sum % 10 == 0;
  }

  double? calculateTextWidth(TextStyle? style) {
    if (isEmpty) return 0;
    final painter = TextPainter(
      text: TextSpan(text: this, style: style),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    );
    painter.layout(minWidth: 0, maxWidth: double.infinity);
    return painter.size.width;
  }

  int? calculateTextLength() {
    int len = 0;
    for (int i = 0; i < length; i++) {
      len += RegExp(r'[\u4E00-\u9FFF]').hasMatch(this[i]) ? 2 : 1;
    }
    return len;
  }
}

/// 数字扩展
extension ZZExtensionInt on num {
  bool isPositive() => this > 0;
  bool isZero() => this == 0;
  bool isNegative() => this < 0;

  String parse2String({int digit = 2}) {
    String result = toString();
    while (result.length < digit) result = "0$result";
    return result;
  }

  String parse2PercentageString() {
    if (this == 0) return "- - ";
    if (this > 0) return "${toString()}%";
    return "-${toString()}%";
  }

  double? parse2FixedRound({int decimal = 2}) {
    final factor = pow(10, decimal).toInt();
    return (this * factor).round() / factor;
  }

  double? parse2FixedFloor({int decimal = 2}) {
    final factor = pow(10, decimal).toInt();
    return (this * factor).floor() / factor;
  }

  double? parse2FixedCeiling({int decimal = 2}) {
    final factor = pow(10, decimal).toInt();
    return (this * factor).ceil() / factor;
  }
}

/// DateTime 扩展
extension ZZExtensionDateTime on DateTime {
  String parse2MonthString() {
    const months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec",
    ];
    return months[month - 1];
  }
}

/// List 扩展
extension ZZExtensionArrays<T> on List<T> {
  T? safeObjectAtIndex(int index) =>
      (index >= 0 && index < length) ? this[index] : null;

  void safeAdd(T? object) {
    if (object != null) add(object);
  }

  void safeAddAll(List<T>? objects) {
    if (objects != null && objects.isNotEmpty) addAll(objects);
  }

  List<T> merge(List<T> other) => [...this, ...other];

  List<List<T>>? tuples({required int itemsPerTuple, bool cutoff = true}) {
    if (isEmpty) return null;
    List<List<T>> result = [];
    List<T> tuple = [];
    for (final element in this) {
      if (tuple.length == itemsPerTuple) {
        result.add(tuple);
        tuple = [element];
      } else {
        tuple.add(element);
      }
    }
    if (!cutoff || tuple.length == itemsPerTuple) result.add(tuple);
    return result;
  }

  List<T>? multiple({
    int times = 3,
    int leastTims = 3,
    int maxCapacity = 1000,
  }) {
    if (isEmpty) return null;
    List<T> result = [];
    for (int i = 0; i < max(times, leastTims); i++) {
      if (i >= leastTims && result.length > maxCapacity) break;
      result.addAll(this);
    }
    return result;
  }

  List? reshape() => isEmpty ? this : [this];
}
