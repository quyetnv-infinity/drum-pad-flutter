import 'package:drumpad_flutter/core/res/style/text_style.dart';
import 'package:drumpad_flutter/src/mvvm/view_model/locale_view_model.dart';
import 'package:drumpad_flutter/src/mvvm/views/lessons/lessons_screen.dart';
import 'package:drumpad_flutter/src/mvvm/views/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class MyApplication extends StatelessWidget {
  const MyApplication({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<LocateViewModel, Locale>(
      selector: (context, localeProvider) => localeProvider.locale,
      builder: (context, locale, child) => MaterialApp(
        theme: ThemeData(
          brightness: Brightness.dark,
          fontFamily: AppFonts.sfProDisplay,
          appBarTheme: AppBarTheme(
            color: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            surfaceTintColor: Colors.transparent,
          ),
        ),
        themeMode: ThemeMode.dark,
        locale: locale,
        debugShowCheckedModeBanner: false,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const SplashScreen(),
        builder: EasyLoading.init(),
      ),
    );
  }
}

void configLoading() {
  EasyLoading.instance
    ..loadingStyle = EasyLoadingStyle.custom
    ..backgroundColor = Colors.white
    ..indicatorSize = 0
    ..radius = 12.0
    ..textColor = Colors.black
    ..maskColor = Colors.black.withOpacity(0.4)
    ..dismissOnTap = true
    ..indicatorWidget = null
    ..indicatorColor = Colors.transparent;
}