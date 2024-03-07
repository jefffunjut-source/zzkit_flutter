// ignore_for_file: file_names, constant_identifier_names

library zzkit;

import 'dart:ui';
import 'package:get/get.dart';
import 'package:zzkit_flutter/util/core/ZZAppConsts.dart';

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
  Japanese
}

const String kLanguage = "language";
const String kHello = 'hello';

abstract class ZZTranslations extends Translations {
  static Locale? get locale {
    String? languageCode = ZZ.prefs.getString("kPrefsLanguageCode");
    String? countryCode = ZZ.prefs.getString("kPrefsCountryCode");
    if (languageCode != null && languageCode.isNotEmpty) {
      return Locale(languageCode, countryCode);
    }
    return Get.deviceLocale;
  }

  static const fallbackLocaleEn = Locale('en', 'US');
  static const fallbackLocaleCn = Locale('zh', 'CN');

  static void changeLocale(Locale newLocale) {
    ZZ.prefs.setString("kPrefsLanguageCode", newLocale.languageCode);
    ZZ.prefs.setString("kPrefsCountryCode", newLocale.countryCode ?? "");
    Get.updateLocale(newLocale);
  }

  Map<String, String>? wordsMapForDifferentLanguage(
      ZZTranslationType languageType);

  @override
  Map<String, Map<String, String>> get keys => {
        'zh_CN':
            wordsMapForDifferentLanguage(ZZTranslationType.SimpleChinese) ?? {},
        'zh_TW': wordsMapForDifferentLanguage(
                ZZTranslationType.TriditionalChinese) ??
            {},
        'zh_HK': wordsMapForDifferentLanguage(
                ZZTranslationType.TriditionalChinese) ??
            {},
        'zh_MO': wordsMapForDifferentLanguage(
                ZZTranslationType.TriditionalChinese) ??
            {},
        'zh_SG': wordsMapForDifferentLanguage(
                ZZTranslationType.TriditionalChinese) ??
            {},
        'en_AU': wordsMapForDifferentLanguage(ZZTranslationType.English) ?? {},
        'en_CA': wordsMapForDifferentLanguage(ZZTranslationType.English) ?? {},
        'en_US': wordsMapForDifferentLanguage(ZZTranslationType.English) ?? {},
        'en_GB': wordsMapForDifferentLanguage(ZZTranslationType.English) ?? {},
        'fr_CA': wordsMapForDifferentLanguage(ZZTranslationType.French) ?? {},
        'fr_FR': wordsMapForDifferentLanguage(ZZTranslationType.French) ?? {},
        'de_DE': wordsMapForDifferentLanguage(ZZTranslationType.Germany) ?? {},
        'de_CH': wordsMapForDifferentLanguage(ZZTranslationType.Germany) ?? {},
        'de_AT': wordsMapForDifferentLanguage(ZZTranslationType.Germany) ?? {},
        'de_LU': wordsMapForDifferentLanguage(ZZTranslationType.Germany) ?? {},
        'es_ES': wordsMapForDifferentLanguage(ZZTranslationType.Spanish) ?? {},
        'es_LA': wordsMapForDifferentLanguage(ZZTranslationType.Spanish) ?? {},
        'pt_PT':
            wordsMapForDifferentLanguage(ZZTranslationType.Portuguese) ?? {},
        'pt_BR':
            wordsMapForDifferentLanguage(ZZTranslationType.Portuguese) ?? {},
        'nl_NL': wordsMapForDifferentLanguage(ZZTranslationType.Dutch) ?? {},
        'nl_BE': wordsMapForDifferentLanguage(ZZTranslationType.Dutch) ?? {},
        'ru_RU': wordsMapForDifferentLanguage(ZZTranslationType.Russian) ?? {},
        'ja_JP': wordsMapForDifferentLanguage(ZZTranslationType.Japanese) ?? {},
        'ko_KR': wordsMapForDifferentLanguage(ZZTranslationType.Korean) ?? {},
      };
}
