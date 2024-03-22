// ignore_for_file: file_names, empty_catches
library zzkit;

import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';

extension ZZExtensionObject on Object {
  String parse2String() {
    if (this is String) {
      return this as String;
    }
    return toString();
  }

  String parse2NumericString({point = 3}) {
    String str = double.parse(toString()).toString();
    // 分开截取
    List<String> sub = str.split('.');
    // 处理值
    List val = List.from(sub[0].split(''));
    // 处理点
    List<String> points = List.from(sub[1].split(''));
    //处理分割符
    for (int index = 0, i = val.length - 1; i >= 0; index++, i--) {
      // 除以三没有余数、不等于零并且不等于1 就加个逗号
      if (index % 3 == 0 && index != 0 && i != 1) val[i] = val[i] + ',';
    }
    // 处理小数点
    for (int i = 0; i <= point - points.length; i++) {
      points.add('0');
    }
    //如果大于长度就截取
    if (points.length > point) {
      // 截取数组
      points = points.sublist(0, point);
    }
    // 判断是否有长度
    if (points.isNotEmpty) {
      return '${val.join('')}.${points.join('')}';
    } else {
      return val.join('');
    }
  }
}

extension ZZExtensionString on String {
  bool isNumeric() {
    return double.tryParse(this) != null;
  }

  bool isToday() {
    return this ==
            "${DateTime.now().month}/${DateTime.now().day.parse2MonthString()}" ||
        this == "${DateTime.now().month}/${DateTime.now().day}";
  }

  bool isValidName() {
    String regexEmail =
        r"^[\u4e00-\u9fa5\u9fa6-\u9fef\u3400-\u4db5\u20000-\u2ebe0a-zA-Z0-9]+$";
    return RegExp(regexEmail).hasMatch(this);
  }

  bool isValidPassWord() {
    String regexEmail =
        "^[\\w\\=\\*\\!\\@\\#\$\\%\\^\\&\\(\\)\\-\\+]{6,30}[!]?\$";
    return RegExp(regexEmail).hasMatch(this);
  }

  bool isValidEmail() {
    String regexEmail = "^\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*\$";
    return RegExp(regexEmail).hasMatch(this);
  }

  bool isValidUrlEncode() {
    if (this == '+') {
      return true;
    } else if (this == ' ') {
      return true;
    } else if (this == '/') {
      return true;
    } else if (this == '?') {
      return true;
    } else if (this == '%') {
      return true;
    } else if (this == '#') {
      return true;
    } else if (this == '&') {
      return true;
    } else if (this == '=') {
      return true;
    }
    return false;
  }

  String parse2FixedDigitsString(int digit) {
    if (length >= digit) {
      return this;
    }
    String ret = this;
    while (ret.length < digit) {
      ret = "0$ret";
    }
    return ret;
  }

  int parse2Int() {
    if (this == "") {
      return 0;
    }
    if (startsWith("0")) {
      replaceFirst("0", "");
    }
    try {
      return int.parse(this);
    } catch (e) {}
    return 0;
  }

  String parse2MD5String() {
    var bytes = utf8.encode(this);
    Digest md5Result = md5.convert(bytes);
    return md5Result.toString();
  }

  Map<String, dynamic>? parse2Map() {
    return json.decode(this);
  }

  T? parse2Object<T>(T Function(Map<String, dynamic>) fromJson) {
    try {
      dynamic map = parse2Map();
      if (map != null) {
        return fromJson(map);
      }
    } catch (e) {}
    return null;
  }

  String parse2UrlEncodeString() {
    StringBuffer encoded = StringBuffer();
    try {
      for (String character in characters) {
        if (character.isValidUrlEncode() == true) {
          encoded.write(Uri.encodeComponent(character));
        } else {
          encoded.write(character);
        }
      }
    } catch (ex) {}
    return encoded.toString();
  }

  /// To Dollar String
  String parse2DollarString() {
    if (contains("\$")) return this;
    return "\$ $this";
  }

  /// #000000 颜色
  Color parse2Color() {
    RegExp regExp = RegExp(r"([g-z]?[G-Z]+?)");
    String? str = regExp.stringMatch(this);
    if (str != null && str.isNotEmpty) {
      return Colors.white;
    }

    if (length < 6) {
      return Colors.white;
    }

    final buffer = StringBuffer();
    if (length == 6 || length == 7) buffer.write('ff');
    buffer.write(replaceFirst('#', ''));
    if (buffer.length != 8) {
      return Colors.white;
    }

    if (int.parse(buffer.toString(), radix: 16) > 0) {
      return Color(int.parse(buffer.toString(), radix: 16));
    }
    return Colors.white;
  }

  /// 拼接前缀字符串
  String addPrefix(String str) {
    return "$str$this";
  }

  /// 拼接后缀字符串
  String append(String str) {
    return "$this$str";
  }
}

extension ZZExtensionInt on int {
  bool isPositive() {
    return this > 0;
  }

  bool isZero() {
    return this == 0;
  }

  bool isNegative() {
    return this < 0;
  }

  String parse2MonthString() {
    String result = toString();
    if (result.length == 1) {
      result = "0$result";
    }
    return result;
  }

  String parse2PercentageString() {
    if (this == 0) {
      return "- - ";
    } else if (this > 0) {
      return "${toString()}%";
    } else if (this < 0) {
      return "-${toString()}%";
    }
    return "- - ${toString()}%";
  }
}

extension ZZExtensionDateTime on DateTime {
  String parse2MonthString() {
    switch (month) {
      case 1:
        return "Jan";
      case 2:
        return "Feb";
      case 3:
        return "Mar";
      case 4:
        return "Apr";
      case 5:
        return "May";
      case 6:
        return "Jun";
      case 7:
        return "Jul";
      case 8:
        return "Aug";
      case 9:
        return "Sep";
      case 10:
        return "Oct";
      case 11:
        return "Nov";
      case 12:
        return "Dec";
    }
    return "";
  }
}

extension ZZExtensionArrays<T> on List<T> {
  dynamic safeObjectAtIndex(int index) {
    if (isEmpty) {
      return null;
    }
    if (index >= 0 && index < length) {
      return this[index];
    }
    return null;
  }

  List<T> merge(List<T> other) {
    return [...this, ...other];
  }

  List<List<T>>? convertToPairs() {
    if (isEmpty) {
      return null;
    }
    List<List<T>> result = [];
    for (int i = 0; i < length - 1; i += 2) {
      if (i + 1 <= length - 1) {
        result.add([this[i], this[i + 1]]);
      } else {
        result.add([this[i]]);
      }
    }
    return result;
  }

  List<T>? align(int itemPerGroup, int groups) {
    if (isEmpty) return null;
    List<T> array = [];
    for (int i = 0; i < itemPerGroup * groups; i += length) {
      for (int j = 0; j < length; j++) {
        array.add(this[j]);
      }
    }
    return array;
  }
}
