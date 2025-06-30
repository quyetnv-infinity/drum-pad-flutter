import 'dart:async';
import 'package:and_drum_pad_flutter/core/res/style/text_style.dart';
import 'package:and_drum_pad_flutter/data/service/api_service/song_service.dart';
import 'package:and_drum_pad_flutter/hive/hive_registrar.g.dart';
import 'package:and_drum_pad_flutter/service_locator/service_locator.dart';
import 'package:and_drum_pad_flutter/view/screen/splash/splash_screen.dart';
import 'package:and_drum_pad_flutter/view_model/ads_provider.dart';
import 'package:and_drum_pad_flutter/view_model/app_setting_provider.dart';
import 'package:and_drum_pad_flutter/view_model/app_state_provider.dart';
import 'package:and_drum_pad_flutter/view_model/campaign_provider.dart';
import 'package:and_drum_pad_flutter/view_model/category_provider.dart';
import 'package:and_drum_pad_flutter/view_model/drum_learn_provider.dart';
import 'package:and_drum_pad_flutter/view_model/locale_view_model.dart';
import 'package:and_drum_pad_flutter/view_model/network_provider.dart';
import 'package:and_drum_pad_flutter/view_model/purchase_provider.dart';
import 'package:and_drum_pad_flutter/view_model/rate_app_provider.dart';
import 'package:and_drum_pad_flutter/view_model/result_information_provider.dart';
import 'package:and_drum_pad_flutter/view_model/theme_provider.dart';
import 'package:and_drum_pad_flutter/view_model/tutorial_provider.dart';
import 'package:and_drum_pad_flutter/view_model/unlock_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hive_ce/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'constant/hive_table.dart';
import 'data/model/lesson_model.dart';

void main() {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    // await initTrackingPermission();
    // await Firebase.initializeApp();
    await Future.wait([
      // AnalyticsTracker.setupCrashlytics(),
      // RemoteConfig.initializeRemoteConfig(adConfigs: getAdConfigurations(false), devMode: AdUnitId.devMode),
      // AnalyticsTracker.trackAppOpens(),
      _initHive(),
      ServiceLocator.instance.initialise(),
    ].toList());
    final purchaseProvider = PurchaseProvider();
    final AppSettingsProvider appSettingsProvider = AppSettingsProvider();
    final adsProvider = AdsProvider(appSettingsProvider: appSettingsProvider,);
    final songService = SongService();
    final categoryProvider = CategoryProvider(songService);

    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => LocateViewModel()),
          ChangeNotifierProvider(create: (_) => appSettingsProvider),
          ChangeNotifierProvider(create: (_) => RateAppProvider()),
          ChangeNotifierProvider(create: (_) => NetworkProvider()),
          ChangeNotifierProvider(create: (_) => ThemeProvider(), lazy: false,),
          ChangeNotifierProvider(create: (_) => categoryProvider, lazy: false,),
          ChangeNotifierProvider(create: (_) => TutorialProvider(), lazy: false,),
          ChangeNotifierProvider(create: (_) => DrumLearnProvider(songService), lazy: false,),
          ChangeNotifierProvider(create: (_) => ResultInformationProvider(), lazy: false,),
          ChangeNotifierProvider(create: (_) => UnlockedSongsProvider(), lazy: false,),
          ChangeNotifierProvider(create: (_) => adsProvider),
          ChangeNotifierProvider(create: (_) => purchaseProvider),
          ChangeNotifierProxyProvider<CategoryProvider, CampaignProvider>(
            create: (_) => CampaignProvider(categoryProvider),
            update: (_, category, campaign) {
              campaign?.updateDependencies(category);
              return campaign ?? CampaignProvider(category);
            },
            lazy: false,
          ),
          ChangeNotifierProxyProvider2<AdsProvider, PurchaseProvider, AppStateProvider>(
            create: (_) => AppStateProvider(adsProvider, purchaseProvider),
            update: (_, ads, purchase, appState) {
              appState?.updateDependencies(ads, purchase);
              return appState ?? AppStateProvider(ads, purchase);
            },
            lazy: false,
          ),
        ],
        child: const MyApp(),
      ),
    );
    configLoading();
  }, (error, stackTrace) {
    // AnalyticsTracker.logError(error, stackTrace);
  });
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

Future<void> _initHive() async {
  var dir = await getApplicationDocumentsDirectory();
  await dir.create(recursive: true);
  var dbPath = '${dir.path}/hive_db';
  Hive
    ..init(dbPath)
    ..registerAdapters();
  await Hive.openBox<SongCollection>(HiveTable.songCollectionTable);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
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
          splashFactory: NoSplash.splashFactory,
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
