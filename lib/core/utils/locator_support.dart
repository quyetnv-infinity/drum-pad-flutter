import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

extension LocatorSupport on BuildContext{
  AppLocalizations get locale {
    AppLocalizations? locate = AppLocalizations.of(this);
    if(locate == null){
      throw Exception('error');
    }
    return locate;
  }
}