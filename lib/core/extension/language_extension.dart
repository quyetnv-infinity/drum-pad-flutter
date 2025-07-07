import 'dart:ui';

import 'package:and_drum_pad_flutter/core/enum/language_enum.dart';
import 'package:and_drum_pad_flutter/core/res/drawer/icon.dart';
import 'package:and_drum_pad_flutter/core/utils/locator_support.dart';
import 'package:flutter/cupertino.dart';

extension LanguageExtension on LanguageEnum {
  String get displayName {
    switch (this) {
      case LanguageEnum.en:
        return 'English';
      // case LanguageEnum.enGB:
      //   return 'English (UK)';
      // case LanguageEnum.enUS:
      //   return 'English (US)';
      // case LanguageEnum.enCA:
      //   return 'English (Canada)';
      // case LanguageEnum.enZA:
      //   return 'English (South African)';
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
    }
  }

  String localeName(BuildContext context) {
    switch (this) {
      case LanguageEnum.en:
        return context.locale.english;
      // case LanguageEnum.enGB:
      //   return context.locale.english;
      // case LanguageEnum.enUS:
      //   return context.locale.english;
      // case LanguageEnum.enCA:
      //   return context.locale.english;
      // case LanguageEnum.enZA:
      //   return context.locale.english;
      case LanguageEnum.de:
        return context.locale.german;
      case LanguageEnum.es:
        return context.locale.spanish;
      case LanguageEnum.ko:
        return context.locale.korean;
      case LanguageEnum.fr:
        return context.locale.french;
      case LanguageEnum.pt:
        return context.locale.portuguese;
      case LanguageEnum.hi:
        return context.locale.hindi;
      case LanguageEnum.ru:
        return context.locale.russian;
    }
  }

  String get getFlag {
    switch (this) {
      case LanguageEnum.en:
        return ResIcon.unitedKingdom;
      // case LanguageEnum.enGB:
      //   return ResIcon.unitedKingdom;
      // case LanguageEnum.enUS:
      //   return ResIcon.unitedStates;
      // case LanguageEnum.enCA:
      //   return ResIcon.canada;
      // case LanguageEnum.enZA:
      //   return ResIcon.southAfrican;
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
    switch (this) {
      // case LanguageEnum.enUS:
      //   return const Locale('en', 'US');
      // case LanguageEnum.enGB:
      //   return const Locale('en', 'GB');
      // case LanguageEnum.enCA:
      //   return const Locale('en', 'CA');
      // case LanguageEnum.enZA:
      //   return const Locale('en', 'ZA');
      case LanguageEnum.es:
        return const Locale('es');
      case LanguageEnum.fr:
        return const Locale('fr');
      case LanguageEnum.hi:
        return const Locale('hi');
      case LanguageEnum.pt:
        return const Locale('pt');
      case LanguageEnum.de:
        return const Locale('de');
      case LanguageEnum.ko:
        return const Locale('ko');
      case LanguageEnum.ru:
        return const Locale('ru');
      case LanguageEnum.en:
      default:
        return const Locale('en');
    }
  }

  List<LanguageEnum> get getPrioritizedLanguages {
    final deviceLocale = PlatformDispatcher.instance.locale;
    final deviceLanguage = deviceLocale.languageCode;
    final deviceCountry = deviceLocale.countryCode;

    final deviceLocaleCode = deviceCountry != null
        ? '$deviceLanguage-$deviceCountry'
        : deviceLanguage;

    LanguageEnum? deviceLangEnum;
    switch (deviceLocaleCode) {
      // case 'en-US':
      //   deviceLangEnum = LanguageEnum.enUS;
      //   break;
      // case 'en-GB':
      //   deviceLangEnum = LanguageEnum.enGB;
      //   break;
      // case 'en-CA':
      //   deviceLangEnum = LanguageEnum.enCA;
      //   break;
      // case 'en-ZA':
      //   deviceLangEnum = LanguageEnum.enZA;
      //   break;
      default:
        try {
          deviceLangEnum = LanguageEnum.values.firstWhere(
                (lang) => lang.name == deviceLanguage,
          );
        } catch (_) {
          // null
        }
    }
    // print(deviceLangEnum);

    final prioritizedList = <LanguageEnum>[];

    if (deviceLangEnum != null) {
      prioritizedList.add(deviceLangEnum);
    } else {
      prioritizedList.add(LanguageEnum.en);
    }

    const englishOrder = [
      LanguageEnum.en,
      // LanguageEnum.enGB,
      // LanguageEnum.enUS,
      // LanguageEnum.enCA,
      // LanguageEnum.enZA,
    ];

    prioritizedList.addAll(
      englishOrder.where((lang) => !prioritizedList.contains(lang)),
    );

    prioritizedList.addAll(
      LanguageEnum.values
          .where((lang) => !prioritizedList.contains(lang)),
    );

    prioritizedList.removeWhere((element) => englishOrder.contains(element) && element != englishOrder.first,);

    return prioritizedList;
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
