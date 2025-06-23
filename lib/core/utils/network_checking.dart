// import 'package:ads_tracking_plugin/ads_controller.dart';
import 'package:drumpad_flutter/core/utils/locator_support.dart';
import 'package:flutter/material.dart';
import 'package:open_settings_plus/core/open_settings_plus.dart';
import 'package:base_ui_flutter_v1/base_ui_flutter_v1.dart' as base_ui;

class NetworkChecking {
  static Future<bool> checkNetwork(BuildContext context, {Function()? handleActionWhenComplete, Function()? handleWhenShowDialog}) async {
    final isConnected = await base_ui.NetworkChecking.checkConnection();
    if(!isConnected) {
      handleWhenShowDialog?.call();
      base_ui.ConnectedFailDialog(
        barrierDismissible: false,
        brightness: Brightness.light,
        title: context.locale.lost_connection,
        content: context.locale.lost_connection_description,
        actionText: context.locale.try_again,
        onCompleted: () {
          handleActionWhenComplete?.call();
        },
        onActionPressed: () {
          // AdController.shared.setResumeAdState(true);
          Navigator.pop(context);
          navigateToWiFiSettings(context);
        }
      ).onShow(context);
    }
    return isConnected;
  }

  static void navigateToWiFiSettings(BuildContext context) {
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      OpenSettingsPlusIOS settings = const OpenSettingsPlusIOS();
      settings.wifi();
    }
  }

}