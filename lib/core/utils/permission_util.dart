import 'package:ads_tracking_plugin/utils/dialog_util.dart';
import 'package:drumpad_flutter/core/utils/locator_support.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionUtil {
  static void showRequestPhotosPermissionDialog(BuildContext context){
    DialogUtil.requestPermissionDialog(
        context: context,
        permissionName: context.locale.photo_permission,
        permissionDescription: context.locale.photo_permission_description,
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
  static void showRequestScreenRecordPermissionDialog(BuildContext context){
    DialogUtil.requestPermissionDialog(
        context: context,
        permissionName: context.locale.record_permission,
        permissionDescription: context.locale.record_permission_description,
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