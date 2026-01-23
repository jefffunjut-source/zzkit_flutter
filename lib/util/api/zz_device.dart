import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:zzkit_flutter/util/core/zz_const.dart';
import 'package:webview_flutter/webview_flutter.dart';

const zzKeyUserToken = "zzKeyUserToken";

class ZZDevice {
  static double designWidth = 414.0;
  static double designHeight = 896.0;

  /// 当前平台标识
  static String platform() {
    if (Platform.isAndroid) return "android";
    if (Platform.isIOS) return "ios";
    return "other";
  }

  /// 获取设备唯一 ID，如果不存在则生成并存储
  static Future<String> deviceId() async {
    String? deviceId = ZZ.prefs.getString("device_id_key");
    if (deviceId != null && deviceId.isNotEmpty) return deviceId;

    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      final IosDeviceInfo info = await deviceInfo.iosInfo;
      deviceId = info.identifierForVendor;
    } else if (Platform.isAndroid) {
      final AndroidDeviceInfo info = await deviceInfo.androidInfo;
      deviceId = info.id;
    }

    deviceId ??= _generateRandomString(32);
    ZZ.prefs.setString("device_id_key", deviceId);
    return deviceId;
  }

  /// 生成随机字符串
  static String _generateRandomString(int length) {
    const chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final rand = Random.secure();
    return List.generate(
      length,
      (_) => chars[rand.nextInt(chars.length)],
    ).join();
  }

  /// 获取操作系统及版本信息
  static Future<String?> os() async {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      final IosDeviceInfo info = await deviceInfo.iosInfo;
      return '${info.systemName}${info.systemVersion}';
    } else if (Platform.isAndroid) {
      final AndroidDeviceInfo info = await deviceInfo.androidInfo;
      return '${info.version.baseOS ?? "android"}${info.version.sdkInt}';
    }
    return null;
  }

  /// 获取设备型号
  static Future<String?> model() async {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      final IosDeviceInfo info = await deviceInfo.iosInfo;
      return info.model;
    } else if (Platform.isAndroid) {
      final AndroidDeviceInfo info = await deviceInfo.androidInfo;
      return info.model;
    }
    return null;
  }

  /// 获取 UserAgent，并追加自定义标识
  static Future<String> getUserAgent() async {
    final WebViewController controller = WebViewController();
    final Object value = await controller.runJavaScriptReturningResult(
      "navigator.userAgent",
    );
    final platformTag = Platform.isAndroid ? "Android" : "iOS";
    return "$value (WWHT,$platformTag,V1.2)";
  }

  /// 当前时间戳（秒）
  static String secondsSince1970() {
    return (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString();
  }

  /// 获取用户 token
  static String? userToken() => ZZ.prefs.getString(zzKeyUserToken);

  /// 屏幕适配 - 宽度
  static double safeW(num w) => w * scaleWidth;

  /// 屏幕适配 - 高度
  static double safeH(num h) => h * scaleHeight;

  /// 屏幕适配 - 字体
  static double safeSp(num sp) => sp * scaleText;

  /// 屏幕像素比例
  static double get scale => window.devicePixelRatio;

  /// 设备屏幕宽度（逻辑像素）
  static double get deviceWidth => window.physicalSize.width / scale;

  /// 设备屏幕高度（逻辑像素）
  static double get deviceHeight => window.physicalSize.height / scale;

  /// 宽度缩放系数
  static double get scaleWidth => deviceWidth / designWidth;

  /// 高度缩放系数
  static double get scaleHeight => deviceHeight / designHeight;

  /// 字体缩放系数（默认随宽度缩放）
  static double get scaleText => scaleWidth;
}
