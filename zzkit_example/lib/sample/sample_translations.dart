// ignore_for_file: file_names

import 'package:zzkit_flutter/util/ZZTranslations.dart';

class SampleTranslations extends ZZTranslations {
  @override
  Map<String, String>? mapLanguage(ZZTranslationType languageType) {
    switch (languageType) {
      case ZZTranslationType.SimpleChinese:
        return {"1": "一"};
      case ZZTranslationType.English:
        return {"1": "one"};
      case ZZTranslationType.French:
        return {"1": "un"};
      case ZZTranslationType.Russian:
        return {"1": "oдин"};
      default:
        return {"1": "1"};
    }
  }
}
