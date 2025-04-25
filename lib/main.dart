import 'dart:async';
import 'package:ads_tracking_plugin/ads_tracking_plugin.dart';
import 'package:ads_tracking_plugin/analyze/analytics_tracker.dart';
import 'package:ads_tracking_plugin/att_permission.dart';
import 'package:drumpad_flutter/config/ads_config.dart';
import 'package:drumpad_flutter/core/constants/hive_table.dart';
import 'package:drumpad_flutter/hive/hive_registrar.g.dart';
import 'package:drumpad_flutter/service_locator/service_locator.dart';
import 'package:drumpad_flutter/src/application/my_application.dart';
import 'package:drumpad_flutter/src/mvvm/models/lesson_model.dart';
import 'package:drumpad_flutter/src/mvvm/view_model/ads_provider.dart';
import 'package:drumpad_flutter/src/mvvm/view_model/app_setting_provider.dart';
import 'package:drumpad_flutter/src/mvvm/view_model/app_state_provider.dart';
import 'package:drumpad_flutter/src/mvvm/view_model/background_audio_provider.dart';
import 'package:drumpad_flutter/src/mvvm/view_model/campaign_provider.dart';
import 'package:drumpad_flutter/src/mvvm/view_model/category_provider.dart';
import 'package:drumpad_flutter/src/mvvm/view_model/drum_learn_provider.dart';
import 'package:drumpad_flutter/src/mvvm/view_model/locale_view_model.dart';
import 'package:drumpad_flutter/src/mvvm/view_model/network_provider.dart';
import 'package:drumpad_flutter/src/mvvm/view_model/purchase_provider.dart';
import 'package:drumpad_flutter/src/mvvm/view_model/rate_app_provider.dart';
import 'package:drumpad_flutter/src/mvvm/view_model/result_information_provider.dart';
import 'package:drumpad_flutter/src/mvvm/view_model/tutorial_provider.dart';
import 'package:drumpad_flutter/src/mvvm/view_model/unlock_provider.dart';
import 'package:drumpad_flutter/src/service/api_service/song_service.dart';
import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await initTrackingPermission();
    await Firebase.initializeApp();
    await Future.wait([
      AnalyticsTracker.setupCrashlytics(),
      RemoteConfig.initializeRemoteConfig(adConfigs: getAdConfigurations(false), devMode: AdUnitId.devMode),
      AnalyticsTracker.trackAppOpens(),
      _initHive(),
      ServiceLocator.instance.initialise(),
    ].toList());
    final purchaseProvider = PurchaseProvider();
    final AppSettingsProvider appSettingsProvider = AppSettingsProvider();
    final BackgroundAudioProvider backgroundAudioProvider = BackgroundAudioProvider();
    final adsProvider = AdsProvider(appSettingsProvider: appSettingsProvider, backgroundAudioProvider: backgroundAudioProvider);
    final songService = SongService();
    final categoryProvider = CategoryProvider(songService);

    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => LocateViewModel()),
          ChangeNotifierProvider(create: (_) => appSettingsProvider),
          ChangeNotifierProvider(create: (_) => RateAppProvider()),
          ChangeNotifierProvider(create: (_) => NetworkProvider()),
          ChangeNotifierProvider(create: (_) => backgroundAudioProvider),
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
        child: const MyApplication(),
      ),
    );
    configLoading();
  }, (error, stackTrace) {
    AnalyticsTracker.logError(error, stackTrace);
  });
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