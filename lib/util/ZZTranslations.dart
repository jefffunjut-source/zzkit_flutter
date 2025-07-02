// ignore_for_file: file_names, constant_identifier_names, unnecessary_library_name

library zzkit;

import 'dart:ui';
import 'package:get/get.dart';
import 'package:zzkit_flutter/util/core/ZZConst.dart';

enum ZZTranslationType {
  SimpleChinese,
  TriditionalChinese,
  English,
  French,
  Germany,
  Spanish,
  Portuguese,
  Dutch,
  Russian,
  Korean,
  Japanese,
}

const String kLanguage = "language";
const String kHello = 'hello';

abstract class ZZTranslations extends Translations {
  static const localeEn = Locale('en', 'US');
  static const localeZhSimple = Locale('zh', 'CN');
  static const localeZhTradition = Locale('zh', 'TW');

  static Locale? get locale {
    String? languageCode = ZZ.prefs.getString("kPrefsLanguageCode");
    String? countryCode = ZZ.prefs.getString("kPrefsCountryCode");
    if (languageCode != null && languageCode.isNotEmpty) {
      return Locale(languageCode, countryCode);
    }
    return Get.deviceLocale;
  }

  static void changeLocale(Locale newLocale) {
    ZZ.prefs.setString("kPrefsLanguageCode", newLocale.languageCode);
    ZZ.prefs.setString("kPrefsCountryCode", newLocale.countryCode ?? "");
    Get.updateLocale(newLocale);
  }

  // 子类继承ZZTranslations后重写该方法
  Map<String, String>? mapLanguage(ZZTranslationType languageType);

  @override
  Map<String, Map<String, String>> get keys => {
    'zh_TW': mapLanguage(ZZTranslationType.TriditionalChinese) ?? {},
    'zh_HK': mapLanguage(ZZTranslationType.TriditionalChinese) ?? {},
    'zh_MO': mapLanguage(ZZTranslationType.TriditionalChinese) ?? {},
    'zh_SG': mapLanguage(ZZTranslationType.TriditionalChinese) ?? {},
    'zh_CN': mapLanguage(ZZTranslationType.SimpleChinese) ?? {},
    'en_AU': mapLanguage(ZZTranslationType.English) ?? {},
    'en_CA': mapLanguage(ZZTranslationType.English) ?? {},
    'en_US': mapLanguage(ZZTranslationType.English) ?? {},
    'en_GB': mapLanguage(ZZTranslationType.English) ?? {},
    'fr_CA': mapLanguage(ZZTranslationType.French) ?? {},
    'fr_FR': mapLanguage(ZZTranslationType.French) ?? {},
    'de_DE': mapLanguage(ZZTranslationType.Germany) ?? {},
    'de_CH': mapLanguage(ZZTranslationType.Germany) ?? {},
    'de_AT': mapLanguage(ZZTranslationType.Germany) ?? {},
    'de_LU': mapLanguage(ZZTranslationType.Germany) ?? {},
    'es_ES': mapLanguage(ZZTranslationType.Spanish) ?? {},
    'es_LA': mapLanguage(ZZTranslationType.Spanish) ?? {},
    'pt_PT': mapLanguage(ZZTranslationType.Portuguese) ?? {},
    'pt_BR': mapLanguage(ZZTranslationType.Portuguese) ?? {},
    'nl_NL': mapLanguage(ZZTranslationType.Dutch) ?? {},
    'nl_BE': mapLanguage(ZZTranslationType.Dutch) ?? {},
    'ru_RU': mapLanguage(ZZTranslationType.Russian) ?? {},
    'ja_JP': mapLanguage(ZZTranslationType.Japanese) ?? {},
    'ko_KR': mapLanguage(ZZTranslationType.Korean) ?? {},
  };
}
