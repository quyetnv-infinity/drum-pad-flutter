import 'package:ads_tracking_plugin/ads_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class AdsProvider with ChangeNotifier {
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
    if (_lastAdTime == null || now.difference(_lastAdTime!).inSeconds >= 30) {
      AdController.shared.interstitialAd.showAd(
        name,
        onLoadingStateChanged: (isLoading, [_]) {
          if (indicator) {
            if (isLoading) {
              EasyLoading.show(indicator: const CircularProgressIndicator(color: Colors.blue), maskType: EasyLoadingMaskType.black, dismissOnTap: false);
            } else {
              EasyLoading.dismiss();
            }
          }
          _isLoading = isLoading;
          notifyListeners();
        },
        onFullScreenAdDismissed: (_) {
          _lastAdTime = DateTime.now();
          callback?.call();
        })
        .then((_) {})
        .catchError((e) {
          print(e);
          callback?.call();
        }
      );
    } else {
      callback?.call();
    }
  }
}
