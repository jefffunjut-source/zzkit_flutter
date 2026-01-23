// ignore_for_file: file_names

import 'package:zzkit_flutter/util/zz_translations.dart';

class SampleTranslations extends ZZTranslations {
  @override
  Map<String, String>? mapLanguage(ZZTranslationType languageType) {
    switch (languageType) {
      case ZZTranslationType.simpleChinese:
        return {"1": "一"};
      case ZZTranslationType.english:
        return {"1": "one"};
      case ZZTranslationType.french:
        return {"1": "un"};
      case ZZTranslationType.russian:
        return {"1": "oдин"};
      default:
        return {"1": "1"};
    }
  }
}
