import 'package:ads_tracking_plugin/utils/dialog_util.dart';
import 'package:drumpad_flutter/core/utils/locator_support.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionUtil {
  static void showRequestRecordScreenPermissionDialog(BuildContext context){
    DialogUtil.requestPermissionDialog(
        context: context,
        permissionName: context.locale.drum_learn,
        permissionDescription: context.locale.beat_runner,
        grantPermissionText: context.locale.grant_permission,
        handleAction: () async {
          // AdController.shared.toggleResumeAdDisabled(true);
          await openAppSettings();
        },
        handleActionWhenComplete: (){
          // AdController.shared.toggleResumeAdDisabled(false);
        }
    );
  }

}