// import 'package:ads_tracking_plugin/ads_controller.dart';
import 'package:drumpad_flutter/src/mvvm/view_model/app_setting_provider.dart';
import 'package:drumpad_flutter/src/mvvm/view_model/background_audio_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class AdsProvider with ChangeNotifier {
  final AppSettingsProvider appSettingsProvider;
  final BackgroundAudioProvider backgroundAudioProvider;
  AdsProvider({required this.appSettingsProvider, required this.backgroundAudioProvider});

  bool _adsEnabled = true;
  DateTime? _lastAdTime;
  bool _isLoading = false;

  bool get adsEnabled => _adsEnabled;


  void updateAdsState(bool isEnabled) {
    _adsEnabled = isEnabled;
    notifyListeners();
  }

  // void showInterAd({required String name, Function()? callback, bool indicator = false}) {
  //   if (_isLoading) return;
  //
  //   final now = DateTime.now();
  //   if (_lastAdTime == null || now.difference(_lastAdTime!).inSeconds >= 35) {
  //     AdController.shared.interstitialAd.showAd(
  //       name,
  //       onLoadingStateChanged: (isLoading, [_]) {
  //         if (indicator) {
  //           if (isLoading) {
  //             EasyLoading.show(indicator: const CircularProgressIndicator(color: Colors.blue), maskType: EasyLoadingMaskType.black, dismissOnTap: false);
  //           } else {
  //             EasyLoading.dismiss();
  //           }
  //         }
  //         _isLoading = isLoading;
  //         notifyListeners();
  //       },
  //         onFullScreenAdDisplayed: (_) async {
  //           await backgroundAudioProvider.pause();
  //           print(backgroundAudioProvider.isPlaying);
  //         },
  //       onFullScreenAdDismissed: (_) {
  //         _lastAdTime = DateTime.now();
  //         callback?.call();
  //
  //
  //       })
  //       .then((_) {})
  //       .catchError((e) {
  //         print(e);
  //         callback?.call();
  //       }
  //     );
  //   } else {
  //     callback?.call();
  //   }
  // }
  Future<void> nextScreen(BuildContext context, Widget screen, bool isReplacement) async{
    print(appSettingsProvider.timeOpenApp);
    if (appSettingsProvider.timeOpenApp == 1) {
      await _navigate(context, screen, isReplacement);
    } else {
      await backgroundAudioProvider.pause();
      // showInterAd(
      //   name: "inter_home",
      //   callback: () async => await _navigate(context, screen, isReplacement),
      //   indicator: true
      // );
    }
  }

  Future<void> nextScreenFuture(BuildContext context, Function() callback) async {
    if (appSettingsProvider.timeOpenApp == 1) {
     callback();
    } else {
      if(backgroundAudioProvider.isPlaying) await backgroundAudioProvider.pause();
      // showInterAd(
      //   name: "inter_home",
      //   callback: () => callback(),
      //   indicator: true
      // );
    }
  }


  Future<void> _navigate(BuildContext context, Widget screen, bool isReplacement)  async {
    if (!isReplacement) {
      await Navigator.push(context, CupertinoPageRoute(builder: (_) => screen));
    } else {
      await Navigator.pushReplacement(context, CupertinoPageRoute(builder: (_) => screen));
    }
  }
}
