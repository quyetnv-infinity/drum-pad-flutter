import 'package:and_drum_pad_flutter/view/widget/loading_dialog/no_internet_dialog.dart';
import 'package:and_drum_pad_flutter/view_model/network_provider.dart';
import 'package:flutter/material.dart';
import 'package:open_settings_plus/core/open_settings_plus.dart';
import 'package:provider/provider.dart';

class NetworkChecking {
  static Future<bool> checkNetwork(BuildContext context, {Function()? handleActionWhenComplete, Function()? handleWhenShowDialog}) async {
    // final isConnected = await base_ui.NetworkChecking.checkConnection();
    final isConnected = Provider.of<NetworkProvider>(context, listen: false).isConnected;
    if(!isConnected) {
      handleWhenShowDialog?.call();
      showLostInternetConnectionDialog(context, handleActionWhenComplete: handleActionWhenComplete);
    }
    return isConnected;
  }

  static void showLostInternetConnectionDialog(BuildContext context, {Function()? handleActionWhenComplete}) {
    NoInternetDialog(
      onTapGoSettings: () {
        // AdController.shared.setResumeAdState(true);
        Navigator.pop(context);
        navigateToWiFiSettings(context);
      },
    )
    .show(context)
    .whenComplete(() {
      handleActionWhenComplete?.call();
    },);
  }

  static void navigateToWiFiSettings(BuildContext context) {
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      OpenSettingsPlusIOS settings = const OpenSettingsPlusIOS();
      settings.wifi();
    } else if(Theme.of(context).platform == TargetPlatform.android) {
      OpenSettingsPlusAndroid settings = const OpenSettingsPlusAndroid();
      settings.wifi();
    }
  }

}