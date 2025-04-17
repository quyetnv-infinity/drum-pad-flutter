import 'package:ads_tracking_plugin/ads_controller.dart';
import 'package:ads_tracking_plugin/utils/dialog_util.dart';
import 'package:ads_tracking_plugin/utils/network_checking.dart';
import 'package:drumpad_flutter/core/utils/locator_support.dart';
import 'package:flutter/material.dart';
import 'package:open_settings_plus/core/open_settings_plus.dart';

class NetworkChecking {
  static Future<bool> checkNetwork(BuildContext context, {Function()? handleActionWhenComplete, Function()? handleWhenShowDialog}) async {
    return NetworkUtil().checkNetwork(onNoConnection:() {
      handleWhenShowDialog?.call();
      DialogUtil.showLostConnectionDialog(
          context: context,
          barrierDismissible: false,
          brightness: Brightness.light,
          lostConnectionText: context.locale.lost_connection,
          lostConnectionDescription: context.locale.lost_connection_description,
          actionText: context.locale.try_again,
          handleActionWhenComplete: () {
            handleActionWhenComplete?.call();
          },
          handleAction: () {
            AdController.shared.setResumeAdState(true);
            Navigator.pop(context);
            navigateToWiFiSettings(context);
          }
      );
    }
    );
  }

  static void navigateToWiFiSettings(BuildContext context) {
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      OpenSettingsPlusIOS settings = const OpenSettingsPlusIOS();
      settings.wifi();
    }
  }

}