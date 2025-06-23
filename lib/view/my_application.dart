import 'package:and_drum_pad_flutter/core/res/style/text_style.dart';
import 'package:and_drum_pad_flutter/view/screen/home/home_screen.dart';
import 'package:and_drum_pad_flutter/view_model/locale_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
class MyApplication extends StatelessWidget {
  const MyApplication({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<LocateViewModel, Locale>(
      selector: (context, localeProvider) => localeProvider.locale,
      builder: (context, locale, child) => MaterialApp(
        theme: ThemeData(
          brightness: Brightness.dark,
          fontFamily: AppFonts.poppins,
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
        home: const HomeScreen(),
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