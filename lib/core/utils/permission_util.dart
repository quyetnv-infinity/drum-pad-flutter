import 'package:and_drum_pad_flutter/core/utils/locator_support.dart';
import 'package:base_ui_flutter_v1/base_ui_flutter_v1.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionUtil {
  static void showRequestPhotosPermissionDialog(BuildContext context){
    // RequestPermissionDialog(
    //     title: context.locale.photo_permission,
    //     content: context.locale.photo_permission_description,
    //     acceptText: context.locale.grant_permission,
    //     onAcceptPressed: () async {
    //       AdController.shared.setResumeAdState(true);
    //       await openAppSettings();
    //     },
    //     onCompleted: (){
    //       AdController.shared.setResumeAdState(false);
    //     }
    // );
  }
  static void showRequestScreenRecordPermissionDialog(BuildContext context){
    // RequestPermissionDialog(
    //     title: context.locale.record_permission,
    //     content: context.locale.record_permission_description,
    //     acceptText: context.locale.grant_permission,
    //     onAcceptPressed: () async {
    //       AdController.shared.setResumeAdState(true);
    //       await openAppSettings();
    //     },
    //     onCompleted: (){
    //       AdController.shared.setResumeAdState(false);
    //     }
    // );
  }
}