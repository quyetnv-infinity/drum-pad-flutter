import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


class AppSettingsProvider with ChangeNotifier {
  // AdsProvider adsProvider;
  // PurchaseProvider purchaseProvider;

  bool _isFirstOpenApp = true;
  bool _isInitialized = false;

  // bool get shouldShowAds => adsProvider.adsEnabled && !purchaseProvider.isSubscribed;

  bool get isFirstOpenApp => _isFirstOpenApp;
  bool get isInitialized => _isInitialized;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isShowRate = true;
  bool get isShowRate => _isShowRate;

  bool _showRate = true;
  bool get showRate => _showRate;

  bool _isFirstShowRate = false;
  bool get isFirstShowRate => _isFirstShowRate;

  int _timeOpenApp = 0;
  int get timeOpenApp => _timeOpenApp;

  int _timeUserUse = 0;
  int get timeUserUse => _timeUserUse;

  int _timeOpenAds = 0;
  int get timeOpenAds => _timeOpenAds;

  bool _toolTips = true;
  bool get toolTips => _toolTips;

  // Future<void> showInterstitialAd(BuildContext context) async {
  //   if (_isLoading) return;
  //
  //   final now = DateTime.now();
  //   if(!context.read<CheckConnectProvider>().isConnected){
  //     context.pop();
  //     return;
  //   }
  //   if(shouldShowAds){
  //   if (_lastAdTime == null || now.difference(_lastAdTime!).inSeconds >= 30) {
  //     print('show ad');
  //     _isLoading = true;
  //     EasyLoading.show();
  //     notifyListeners();
  //     try {
  //       await AdController.shared.interstitialAd.showAd(
  //         "inter_back",
  //         onLoadingStateChanged: (isLoading, [String? errorMessage]) {
  //           _isLoading = isLoading;
  //           notifyListeners();
  //         },
  //         onFullScreenAdDismissed: (_) {
  //           updateAdTime(DateTime.now());
  //         },
  //       );
  //     } catch (e) {
  //       print(e);
  //     } finally {
  //       _isLoading = false;
  //       notifyListeners();
  //       EasyLoading.dismiss();
  //     }
  //   }
  //   }
  //   context.pop();
  // }

  AppSettingsProvider() {
    _initSettings();
    getFirstOpenApp().then((value) {
      _isFirstOpenApp = value;
      notifyListeners();
      // purchaseProvider.loadSubscription().then((_) {
      //   initializeAds();
      // });
    });
  }


  // void updateDependencies(AdsProvider adsProvider, PurchaseProvider purchaseProvider) {
  //   adsProvider = adsProvider;
  //   purchaseProvider = purchaseProvider;
  //   notifyListeners();
  // }

  // void updateAdsState(bool isEnabled) {
  //   adsProvider.updateAdsState(isEnabled);
  //   notifyListeners();
  // }

  // void initializeAds() {
  //   print("initializeAds: $shouldShowAds");
  //   AdController.shared.initialize(
  //     isAdDisabled: !shouldShowAds,
  //     configurations: getAdConfigurations(_isFirstOpenApp),
  //   );
  // }

  Future<void> _initSettings() async {
    _isFirstOpenApp = await getFirstOpenApp();
    _isInitialized = true;
    _isShowRate = await getIsShowRate();
    _showRate = await getShowRate();
    _timeOpenApp = await getTimeOpenApp();
    _isFirstShowRate = await getFirstShowRate();
    _toolTips = await getFirstToolTips();
    _timeUserUse = await getTimeUse();
    print(_timeUserUse);
    notifyListeners();
  }

  Future<bool> getFirstOpenApp() async {
    final prefs = await SharedPreferences.getInstance();
    bool? savedValue = prefs.getBool('isFirstTime');
    print('get first open');
    return savedValue ?? true;
  }

  Future<void> setFirstOpenApp() async {
    _isFirstOpenApp = false;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFirstTime', false);
    print('set first open app');
  }

  Future<bool> getIsShowRate() async {
    final prefs = await SharedPreferences.getInstance();
    bool? savedValue = prefs.getBool('isShowRate');
    return savedValue ?? true;
  }

  Future<void> setIsShowRate() async {
    _isShowRate = false;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isShowRate', false);
    print('Show rate updated to false');
  }

  Future<bool> getShowRate() async {
    final prefs = await SharedPreferences.getInstance();
    bool? savedValue = prefs.getBool('isFirstShowRate');
    return savedValue ?? true;
  }

  Future<void> setShowRate() async {
    _showRate = false;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFirstShowRate', false);
  }
  Future<bool> getFirstShowRate() async {
    final prefs = await SharedPreferences.getInstance();
    bool? savedValue = prefs.getBool('isFirstOpenShow');
    return savedValue ?? false;
  }

  Future<void> setFirstShowRate() async {
    _isFirstShowRate = true;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFirstOpenShow', false);
    print(_isFirstShowRate);
  }
  Future<int> getTimeOpenApp() async {
    final prefs = await SharedPreferences.getInstance();
    int? savedValue = prefs.getInt('timeOpenApp');
    return savedValue ?? 0;
  }

  Future<void> increaseTimeOpenApp() async {
    _timeOpenApp ++;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('timeOpenApp', _timeOpenApp);
  }
  void updateTimeOpenAds() {
    _timeOpenAds ++;
    print('time open ads: $_timeOpenAds');
    notifyListeners();
  }

  Future<void> setFirstToolTips() async {
    _toolTips = false;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('toolTips', false);
    print(_toolTips);
  }
  Future<bool> getFirstToolTips() async {
    final prefs = await SharedPreferences.getInstance();
    bool? savedValue = prefs.getBool('toolTips');
    return savedValue ?? true;
  }

  Future<void> increaseTimeUse() async {
    _timeUserUse ++;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('timeUse', _timeUserUse);
  }

  Future<int> getTimeUse() async {
    final prefs = await SharedPreferences.getInstance();
    int? savedValue = prefs.getInt('timeUse');
    return savedValue ?? 0;
  }

}
