// ignore_for_file: file_names, unnecessary_library_name, deprecated_member_use
library zzkit;

import 'dart:io';
import 'dart:ui';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:zzkit_flutter/util/core/ZZConst.dart';
import 'package:webview_flutter/webview_flutter.dart';

const zzKeyUserToken = "zzKeyUserToken";

class ZZDevice {
  static double designWidth = 414.0;
  static double designHeight = 896.0;

  static String platform() {
    return Platform.isAndroid ? "android" : (Platform.isIOS ? "ios" : "other");
  }

  static Future<String?> deviceId() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      IosDeviceInfo info = await deviceInfo.iosInfo;
      return info.identifierForVendor;
    } else if (Platform.isAndroid) {
      AndroidDeviceInfo info = await deviceInfo.androidInfo;
      return info.id;
    }
    return null;
  }

  static Future<String?> os() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      IosDeviceInfo info = await deviceInfo.iosInfo;
      return info.systemName + info.systemVersion;
    } else if (Platform.isAndroid) {
      AndroidDeviceInfo info = await deviceInfo.androidInfo;
      return (info.version.baseOS ?? "android") +
          info.version.sdkInt.toString();
    }
    return null;
  }

  static Future<String?> model() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      IosDeviceInfo info = await deviceInfo.iosInfo;
      return info.model;
    } else if (Platform.isAndroid) {
      AndroidDeviceInfo info = await deviceInfo.androidInfo;
      return info.model;
    }
    return null;
  }

  static Future<String> getUserAgent() async {
    final WebViewController controller = WebViewController();
    Object value = await controller.runJavaScriptReturningResult(
      "navigator.userAgent",
    );
    if (Platform.isAndroid) {
      return "$value (WWHT,Android,V1.2)";
    } else {
      return "$value (WWHT,iOS,V1.2)";
    }
  }

  static String secondsSince1970() {
    String time = (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString();
    return time;
  }

  static String? userToken() {
    String? token = ZZ.prefs.getString(zzKeyUserToken);
    return token;
  }

  static double safeW(num w) => w * scaleWidth;

  static double safeH(num h) => h * scaleHeight;

  static double safeSp(num sp) => sp * scaleText;

  static double get scale => window.devicePixelRatio;
  static double get deviceWidth => window.physicalSize.width / scale;
  static double get deviceHeight => window.physicalSize.height / scale;
  static double get scaleWidth => deviceWidth / designWidth;
  static double get scaleHeight => deviceHeight / designHeight;
  static double get scaleText => scaleWidth;
}
