import 'package:ads_tracking_plugin/ad_config.dart';
import 'package:ads_tracking_plugin/ads_controller.dart';
import 'package:ads_tracking_plugin/ads_tracking_plugin.dart';
import 'package:ads_tracking_plugin/tracking/analytics_tracker.dart';
import 'package:and_drum_pad_flutter/config/ads_config.dart';
import 'package:and_drum_pad_flutter/view_model/ads_provider.dart';
import 'package:and_drum_pad_flutter/view_model/purchase_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppStateProvider with ChangeNotifier {
  AdsProvider adsProvider;
  PurchaseProvider purchaseProvider;
  bool _isFirstOpenApp = false;
  bool _isInitialized = false;

  bool get isFirstOpenApp => _isFirstOpenApp;
  bool get shouldShowAds => adsProvider.adsEnabled && !purchaseProvider.isSubscribed;
  bool get isInitialized => _isInitialized;

  AppStateProvider(this.adsProvider, this.purchaseProvider);

  DateTime? _lastAdTime;
  bool _isLoading = false;

  DateTime? get lastAdTime => _lastAdTime;
  bool get isLoading => _isLoading;

  void setLastAdTime(DateTime? dateTime){
    _lastAdTime = dateTime;
    notifyListeners();
  }

  void setIsLoading(bool isLoading){
    _isLoading = isLoading;
    notifyListeners();
  }

  void updateDependencies(AdsProvider adsProvider, PurchaseProvider purchaseProvider) {
    this.adsProvider = adsProvider;
    this.purchaseProvider = purchaseProvider;
    notifyListeners();
  }

  void updateAdsState(bool isEnabled) {
    adsProvider.updateAdsState(isEnabled);
    notifyListeners();
  }

  Future<void> initialize() async {
    try {
      _isFirstOpenApp = await getFirstOpenApp();
      notifyListeners();

      await purchaseProvider.loadSubscription();
      await initializeAds();

      if (_isFirstOpenApp) {
        AnalyticsTracker.trackInstallEvent();
      }

      _isInitialized = true;
      notifyListeners();
    } catch (error, stackTrace) {
      print("Failed to initialize AppStateProvider: $error");
      AnalyticsTracker.logError(error, stackTrace);
      rethrow;
    }
  }

  Future initializeAds() async {
    await AdController.shared.initialize(
        isAdDisabled: !shouldShowAds,
        configurations: getAdConfigurations(_isFirstOpenApp),
        adjustConfig: AdjustConfig("pdckf8inq96o", AdjustEnvironment.production),
        trackingAdjustConfig: TrackingAdjustConfig(
          appToken: "9032yk",
          eventNameRevenue: "AD Revenue",
        )
    );
  }

  Future<bool> getFirstOpenApp() async {
    final prefs = await SharedPreferences.getInstance();
    bool? savedValue = prefs.getBool('isFirstTime');
    return savedValue ?? true;
  }

  Future<void> setFirstOpenApp() async {
    _isFirstOpenApp = false;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFirstTime', false);
  }
}