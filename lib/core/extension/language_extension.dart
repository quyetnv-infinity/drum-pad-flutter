import 'package:drumpad_flutter/core/enum/language_enum.dart';
import 'package:drumpad_flutter/core/res/drawer/icon.dart';
import 'package:drumpad_flutter/core/utils/locator_support.dart';
import 'package:flutter/material.dart';

extension LanguageExtension on LanguageEnum {
  String displayName(BuildContext context) {
    switch (this) {
      case LanguageEnum.en:
        return 'United States';
      case LanguageEnum.de:
        return 'German';
    case LanguageEnum.es:
      return 'Spanish';
      case LanguageEnum.ko:
        return 'Korean';
      case LanguageEnum.fr:
        return 'French';
      case LanguageEnum.pt:
        return 'Portuguese';
      case LanguageEnum.hi:
        return 'Hindi';
      case LanguageEnum.ru:
        return 'Russian';
      default:
        return context.locale.unknown;
    }
  }

  String get getFlag {
    switch (this) {
      case LanguageEnum.en:
        return ResIcon.unitedStates;
      case LanguageEnum.de:
        return ResIcon.german;
    case LanguageEnum.es:
      return ResIcon.spanish;
      case LanguageEnum.ko:
        return ResIcon.korean;
      case LanguageEnum.fr:
        return ResIcon.french;
      case LanguageEnum.pt:
        return ResIcon.portuguese;
      case LanguageEnum.hi:
        return ResIcon.hindi;
      case LanguageEnum.ru:
        return ResIcon.russia;
      default:
        return ResIcon.unitedStates;
    }
  }

  String get code {
    return name;
  }

  Locale toLocale() {
    return Locale(code);
  }
}

extension StringToLanguageEnum on String {
  LanguageEnum? toLanguageEnum() {
    try {
      return LanguageEnum.values.firstWhere((e) => e.name == this);
    } catch (_) {
      return null;
    }
  }
}
