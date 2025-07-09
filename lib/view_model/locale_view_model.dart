import 'dart:ui';
import 'package:and_drum_pad_flutter/constant/key_sharepreference.dart';
import 'package:and_drum_pad_flutter/core/enum/language_enum.dart';
import 'package:and_drum_pad_flutter/core/extension/language_extension.dart';
import 'package:and_drum_pad_flutter/service_locator/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LocateViewModel extends ChangeNotifier {
  LanguageEnum _currentLanguage = LanguageEnum.en;
  LanguageEnum? _selectedLanguage; // Có thể null khi chưa chọn
  final _prefs = ServiceLocator.instance.get<SharedPreferences>();

  Locale get locale => _currentLanguage.toLocale();
  LanguageEnum get currentLanguage => _currentLanguage;
  LanguageEnum? get selectedLanguage => _selectedLanguage;

  // Getter mới để kiểm tra xem có nên hiển thị nút check hay không
  bool get showCheckButton => _selectedLanguage != null;

  LocateViewModel(){
    initLocale();
  }

  Future<void> initLocale() async {
    final savedLocale = _prefs.getString(SharePreferencesKey.currentLanguage);
    if (savedLocale != null) {
      final languageEnum = savedLocale.toLanguageEnum();
      if (languageEnum != null) {
        _currentLanguage = languageEnum;
        _selectedLanguage = languageEnum;
        notifyListeners();
      }
    } else {
      final systemLocale = PlatformDispatcher.instance.locale;
      final systemLanguageCode = systemLocale.languageCode;
      final systemLanguageEnum = systemLanguageCode.toLanguageEnum();

      if (systemLanguageEnum != null &&
          AppLocalizations.supportedLocales
              .contains(systemLanguageEnum.toLocale())) {
        _currentLanguage = systemLanguageEnum;
        // Không set selectedLanguage ở đây nữa
      }
    }
  }

  void initSelectedLanguage(){
    final savedLocale = _prefs.getString(SharePreferencesKey.currentLanguage);
    if(savedLocale != null) _selectedLanguage = _currentLanguage;
    print('init language: $_selectedLanguage');
    notifyListeners();
  }

  void selectLanguage(LanguageEnum language) {
    // if (!AppLocalizations.supportedLocales.contains(language.toLocale())) {
    //   return;
    // }
    _selectedLanguage = language;
    print(_selectedLanguage);
    notifyListeners();
  }

  Future<void> saveLanguage() async {
    if (_selectedLanguage == null) {
      _currentLanguage = LanguageEnum.en;
      notifyListeners();
      return;
    }
    if (_selectedLanguage == null ||
        !AppLocalizations.supportedLocales
            .contains(_selectedLanguage!.toLocale())) {
      return;
    }

    _currentLanguage = _selectedLanguage!;
    print('save current language: ${_currentLanguage.name}');
    // await _prefs.setString(
    //     SharePreferencesKey.currentLanguage, _currentLanguage.code);
    notifyListeners();
  }

  bool isLanguageSupported(LanguageEnum language) {
    return AppLocalizations.supportedLocales.contains(language.toLocale());
  }

  List<LanguageEnum> getSupportedLanguages() {
    return LanguageEnum.values.where(isLanguageSupported).toList();
  }
}
