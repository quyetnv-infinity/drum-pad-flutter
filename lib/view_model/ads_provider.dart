import 'package:and_drum_pad_flutter/view_model/app_setting_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class AdsProvider with ChangeNotifier {
  final AppSettingsProvider appSettingsProvider;
  AdsProvider({required this.appSettingsProvider});

  bool _adsEnabled = true;
  DateTime? _lastAdTime;
  bool _isLoading = false;

  bool get adsEnabled => _adsEnabled;


  void updateAdsState(bool isEnabled) {
    _adsEnabled = isEnabled;
    notifyListeners();
  }

  void showInterAd({required String name, Function()? callback, bool indicator = false}) {
    if (_isLoading) return;

    final now = DateTime.now();
    if (_lastAdTime == null || now.difference(_lastAdTime!).inSeconds >= 35) {
      // AdController.shared.interstitialAd.showAd(
      //   name,
      //   onLoadingStateChanged: (isLoading, [_]) {
      //     if (indicator) {
      //       if (isLoading) {
      //         EasyLoading.show(indicator: const CircularProgressIndicator(color: Colors.blue), maskType: EasyLoadingMaskType.black, dismissOnTap: false);
      //       } else {
      //         EasyLoading.dismiss();
      //       }
      //     }
      //     _isLoading = isLoading;
      //     notifyListeners();
      //   },
      //   onFullScreenAdDisplayed: (_) async {
      //
      //   },
      //   onFullScreenAdDismissed: (_) {
      //     _lastAdTime = DateTime.now();
      //     callback?.call();
      //
      //
      //   })
      //   .then((_) {})
      //   .catchError((e) {
      //     print(e);
      //     callback?.call();
      //   }
      // );
    } else {
      callback?.call();
    }
  }
}
