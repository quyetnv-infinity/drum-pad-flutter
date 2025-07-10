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
      case LanguageEnum.ar:
        return 'Arabic';
      case LanguageEnum.hr:
        return 'Croatian';
      case LanguageEnum.cs:
        return 'Czech';
      case LanguageEnum.nl:
        return 'Dutch';
      case LanguageEnum.fil:
        return 'Filipino';
      case LanguageEnum.id:
        return 'Indonesian';
      case LanguageEnum.it:
        return 'Italian';
      case LanguageEnum.ja:
        return 'Japanese';
      case LanguageEnum.ms:
        return 'Malay';
      case LanguageEnum.pl:
        return 'Polish';
      case LanguageEnum.sr:
        return 'Serbian';
      case LanguageEnum.sv:
        return 'Swedish';
      case LanguageEnum.tr:
        return 'Turkish';
      case LanguageEnum.vi:
        return 'Vietnamese';
      case LanguageEnum.zh:
        return 'Chinese';
    }
  }

  String localeName(BuildContext context) {
    switch (this) {
      case LanguageEnum.en:
        return context.locale.english;
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
      case LanguageEnum.ar:
        return context.locale.arabic;
      case LanguageEnum.hr:
        return context.locale.croatian;
      case LanguageEnum.cs:
        return context.locale.czech;
      case LanguageEnum.nl:
        return context.locale.dutch;
      case LanguageEnum.fil:
        return context.locale.filipino;
      case LanguageEnum.id:
        return context.locale.indonesian;
      case LanguageEnum.it:
        return context.locale.italian;
      case LanguageEnum.ja:
        return context.locale.japanese;
      case LanguageEnum.ms:
        return context.locale.malay;
      case LanguageEnum.pl:
        return context.locale.polish;
      case LanguageEnum.sr:
        return context.locale.serbian;
      case LanguageEnum.sv:
        return context.locale.swedish;
      case LanguageEnum.tr:
        return context.locale.turkish;
      case LanguageEnum.vi:
        return context.locale.vietnamese;
      case LanguageEnum.zh:
        return context.locale.chinese;
    }
  }

  String get getFlag {
    switch (this) {
      case LanguageEnum.en:
        return ResIcon.unitedKingdom;
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
      // case LanguageEnum.ar:
      //   return ResIcon.arabic;
      // case LanguageEnum.hr:
      //   return ResIcon.croatian;
      // case LanguageEnum.cs:
      //   return ResIcon.czech;
      // case LanguageEnum.nl:
      //   return ResIcon.dutch;
      // case LanguageEnum.fil:
      //   return ResIcon.filipino;
      // case LanguageEnum.ind:
      //   return ResIcon.indonesian;
      // case LanguageEnum.it:
      //   return ResIcon.italian;
      // case LanguageEnum.ja:
      //   return ResIcon.japanese;
      // case LanguageEnum.ms:
      //   return ResIcon.malay;
      // case LanguageEnum.pl:
      //   return ResIcon.polish;
      // case LanguageEnum.sr:
      //   return ResIcon.serbian;
      // case LanguageEnum.sv:
      //   return ResIcon.swedish;
      // case LanguageEnum.tr:
      //   return ResIcon.turkish;
      // case LanguageEnum.vi:
      //   return ResIcon.vietnamese;
      // case LanguageEnum.zh:
      //   return ResIcon.chinese;
      default:
        return ResIcon.unitedStates;
    }
  }

  String get code {
    return name;
  }

  Locale toLocale() {
    switch (this) {
      case LanguageEnum.en:
        return const Locale('en');
      case LanguageEnum.de:
        return const Locale('de');
      case LanguageEnum.es:
        return const Locale('es');
      case LanguageEnum.ko:
        return const Locale('ko');
      case LanguageEnum.fr:
        return const Locale('fr');
      case LanguageEnum.pt:
        return const Locale('pt');
      case LanguageEnum.hi:
        return const Locale('hi');
      case LanguageEnum.ru:
        return const Locale('ru');
      case LanguageEnum.ar:
        return const Locale('ar');
      case LanguageEnum.hr:
        return const Locale('hr');
      case LanguageEnum.cs:
        return const Locale('cs');
      case LanguageEnum.nl:
        return const Locale('nl');
      case LanguageEnum.fil:
        return const Locale('fil');
      case LanguageEnum.id:
        return const Locale('id'); // Indonesian language code is 'id'
      case LanguageEnum.it:
        return const Locale('it');
      case LanguageEnum.ja:
        return const Locale('ja');
      case LanguageEnum.ms:
        return const Locale('ms');
      case LanguageEnum.pl:
        return const Locale('pl');
      case LanguageEnum.sr:
        return const Locale('sr');
      case LanguageEnum.sv:
        return const Locale('sv');
      case LanguageEnum.tr:
        return const Locale('tr');
      case LanguageEnum.vi:
        return const Locale('vi');
      case LanguageEnum.zh:
        return const Locale('zh');
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
      case 'en-US':
      case 'en-GB':
      case 'en-CA':
      case 'en-ZA':
        deviceLangEnum = LanguageEnum.en;
        break;
      case 'id':
      // Nếu bạn đã sửa enum từ `in` => `ind` thì sửa tại đây
        deviceLangEnum = LanguageEnum.id;
        break;
      default:
        try {
          deviceLangEnum = LanguageEnum.values.firstWhere(
                (lang) => lang.name == deviceLanguage,
          );
        } catch (_) {
          // Không tìm thấy ngôn ngữ
        }
    }

    // Lấy 8 ngôn ngữ đầu tiên
    final top8Languages = LanguageEnum.values.take(8).toList();

    if (deviceLangEnum != null) {
      if (top8Languages.contains(deviceLangEnum)) {
        // Nếu trong top 8: đưa lên đầu, sau đó thêm các phần tử còn lại (không trùng)
        return [
          deviceLangEnum,
          ...top8Languages.where((lang) => lang != deviceLangEnum)
        ];
      } else {
        // Nếu không trong top 8: đưa lên đầu và thêm top 8, bỏ trùng
        final result = <LanguageEnum>[deviceLangEnum];
        result.addAll(top8Languages.where((lang) => lang != deviceLangEnum));
        return result;
      }
    }

    // Nếu không xác định được ngôn ngữ: trả về top 8
    return top8Languages;
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
