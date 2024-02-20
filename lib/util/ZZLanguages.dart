// ignore_for_file: file_names, constant_identifier_names

library zzkit;

import 'dart:ui';
import 'package:get/get.dart';
import 'package:zzkit_flutter/util/core/ZZAppConsts.dart';

enum ZZLanguageType {
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
  Japanese
}

const String kLanguage = "language";
const String kHello = 'hello';

abstract class ZZLanguages extends Translations {
  static Locale? get locale {
    String? languageCode = APP.prefs.getString("kPrefsLanguageCode");
    String? countryCode = APP.prefs.getString("kPrefsCountryCode");
    if (languageCode != null && languageCode.isNotEmpty) {
      return Locale(languageCode, countryCode);
    }
    return Get.deviceLocale;
  }

  static const fallbackLocaleEn = Locale('en', 'US');
  static const fallbackLocaleCn = Locale('zh', 'CN');

  static void changeLocale(Locale newLocale) {
    APP.prefs.setString("kPrefsLanguageCode", newLocale.languageCode);
    APP.prefs.setString("kPrefsCountryCode", newLocale.countryCode ?? "");
    Get.updateLocale(newLocale);
  }

  Map<String, String>? wordsMapForDifferentLanguage(
      ZZLanguageType languageType);

  @override
  Map<String, Map<String, String>> get keys => {
        'zh_CN':
            wordsMapForDifferentLanguage(ZZLanguageType.SimpleChinese) ?? {},
        'zh_TW':
            wordsMapForDifferentLanguage(ZZLanguageType.TriditionalChinese) ??
                {},
        'zh_HK':
            wordsMapForDifferentLanguage(ZZLanguageType.TriditionalChinese) ??
                {},
        'zh_MO':
            wordsMapForDifferentLanguage(ZZLanguageType.TriditionalChinese) ??
                {},
        'zh_SG':
            wordsMapForDifferentLanguage(ZZLanguageType.TriditionalChinese) ??
                {},
        'en_AU': wordsMapForDifferentLanguage(ZZLanguageType.English) ?? {},
        'en_CA': wordsMapForDifferentLanguage(ZZLanguageType.English) ?? {},
        'en_US': wordsMapForDifferentLanguage(ZZLanguageType.English) ?? {},
        'en_GB': wordsMapForDifferentLanguage(ZZLanguageType.English) ?? {},
        'fr_CA': wordsMapForDifferentLanguage(ZZLanguageType.French) ?? {},
        'fr_FR': wordsMapForDifferentLanguage(ZZLanguageType.French) ?? {},
        'de_DE': wordsMapForDifferentLanguage(ZZLanguageType.Germany) ?? {},
        'de_CH': wordsMapForDifferentLanguage(ZZLanguageType.Germany) ?? {},
        'de_AT': wordsMapForDifferentLanguage(ZZLanguageType.Germany) ?? {},
        'de_LU': wordsMapForDifferentLanguage(ZZLanguageType.Germany) ?? {},
        'es_ES': wordsMapForDifferentLanguage(ZZLanguageType.Spanish) ?? {},
        'es_LA': wordsMapForDifferentLanguage(ZZLanguageType.Spanish) ?? {},
        'pt_PT': wordsMapForDifferentLanguage(ZZLanguageType.Portuguese) ?? {},
        'pt_BR': wordsMapForDifferentLanguage(ZZLanguageType.Portuguese) ?? {},
        'nl_NL': wordsMapForDifferentLanguage(ZZLanguageType.Dutch) ?? {},
        'nl_BE': wordsMapForDifferentLanguage(ZZLanguageType.Dutch) ?? {},
        'ru_RU': wordsMapForDifferentLanguage(ZZLanguageType.Russian) ?? {},
        'ja_JP': wordsMapForDifferentLanguage(ZZLanguageType.Japanese) ?? {},
        'ko_KR': wordsMapForDifferentLanguage(ZZLanguageType.Korean) ?? {},
      };
}
