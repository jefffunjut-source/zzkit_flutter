import 'dart:ui';
import 'package:get/get.dart';
import 'package:zzkit_flutter/util/zz_const.dart';

/// 支持的翻译类型
enum ZZTranslationType {
  simpleChinese,
  triditionalChinese,
  english,
  french,
  germany,
  spanish,
  portuguese,
  dutch,
  russian,
  korean,
  japanese,
}

/// 常量键
const String kLanguage = "language";
const String kHello = 'hello';

/// 翻译基类，子类继承并实现 mapLanguage
abstract class ZZTranslations extends Translations {
  /// 常用语言 Locale
  static const localeEn = Locale('en', 'US');
  static const localeZhSimple = Locale('zh', 'CN');
  static const localeZhTradition = Locale('zh', 'TW');

  /// 当前使用的 Locale
  static Locale? get locale {
    final languageCode = ZZ.prefs.getString("kPrefsLanguageCode");
    final countryCode = ZZ.prefs.getString("kPrefsCountryCode");
    if (languageCode != null && languageCode.isNotEmpty) {
      return Locale(
        languageCode,
        countryCode?.isNotEmpty == true ? countryCode : null,
      );
    }
    return Get.deviceLocale;
  }

  /// 切换应用语言
  static void changeLocale(Locale newLocale) {
    ZZ.prefs.setString("kPrefsLanguageCode", newLocale.languageCode);
    ZZ.prefs.setString("kPrefsCountryCode", newLocale.countryCode ?? "");
    Get.updateLocale(newLocale);
  }

  /// 子类需实现：返回对应语言的 key-value 映射
  Map<String, String>? mapLanguage(ZZTranslationType languageType);

  /// 国际化字典
  @override
  Map<String, Map<String, String>> get keys {
    final tradChinese = mapLanguage(ZZTranslationType.triditionalChinese) ?? {};
    final simpleChinese = mapLanguage(ZZTranslationType.simpleChinese) ?? {};
    final english = mapLanguage(ZZTranslationType.english) ?? {};
    final french = mapLanguage(ZZTranslationType.french) ?? {};
    final germany = mapLanguage(ZZTranslationType.germany) ?? {};
    final spanish = mapLanguage(ZZTranslationType.spanish) ?? {};
    final portuguese = mapLanguage(ZZTranslationType.portuguese) ?? {};
    final dutch = mapLanguage(ZZTranslationType.dutch) ?? {};
    final russian = mapLanguage(ZZTranslationType.russian) ?? {};
    final japanese = mapLanguage(ZZTranslationType.japanese) ?? {};
    final korean = mapLanguage(ZZTranslationType.korean) ?? {};

    return {
      'zh_TW': tradChinese,
      'zh_HK': tradChinese,
      'zh_MO': tradChinese,
      'zh_SG': tradChinese,
      'zh_CN': simpleChinese,
      'en_AU': english,
      'en_CA': english,
      'en_US': english,
      'en_GB': english,
      'fr_CA': french,
      'fr_FR': french,
      'de_DE': germany,
      'de_CH': germany,
      'de_AT': germany,
      'de_LU': germany,
      'es_ES': spanish,
      'es_LA': spanish,
      'pt_PT': portuguese,
      'pt_BR': portuguese,
      'nl_NL': dutch,
      'nl_BE': dutch,
      'ru_RU': russian,
      'ja_JP': japanese,
      'ko_KR': korean,
    };
  }
}
