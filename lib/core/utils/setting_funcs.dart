import 'dart:io';

import 'package:ads_tracking_plugin/ads_controller.dart';
import 'package:and_drum_pad_flutter/constant/app_info.dart';
import 'package:and_drum_pad_flutter/core/utils/locator_support.dart';
import 'package:and_drum_pad_flutter/view/widget/loading_dialog/rate_app_dialog.dart';
import 'package:and_drum_pad_flutter/view_model/app_setting_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingFuncs {
  static void share(){
    SharePlus.instance.share(
        ShareParams(
          text: 'Check out this amazing app! ${Platform.isIOS ? AppInfo.appLinkIOS : AppInfo.appLinkAndroid}',
          subject: 'Drum Pad & DJ Beat Maker Pro',
        )
    );
  }
  // static void showDialogReviewThanksForRate(BuildContext context){
  //   showCupertinoDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (context) {
  //       return CupertinoTheme(
  //         data: const CupertinoThemeData(
  //           brightness: Brightness.light
  //         ),
  //         child: CupertinoAlertDialog(
  //           title: Text(context.locale.thank_you, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 18),),
  //           content: Column(
  //             children: [
  //               Text(context.locale.thank_you_for_rate_description, style: const TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.w400),),
  //               const SizedBox(height: 15,),
  //               FeedbackItem(text: context.locale.too_much_ads),
  //               const SizedBox(height: 6,),
  //               FeedbackItem(text: context.locale.app_not_work),
  //               const SizedBox(height: 6,),
  //               FeedbackItem(text: context.locale.others),
  //             ],
  //           ),
  //           actions: [
  //             TextButton(
  //                 onPressed: (){
  //                   Navigator.pop(context);
  //                 },
  //                 child: Text(context.locale.ok.toUpperCase(), style: const TextStyle(color: Color(0xFF007AFF), fontWeight: FontWeight.w900, fontSize: 14),))
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }
  static void showDialogThanksForFeedback(BuildContext context){
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Theme(
          data: ThemeData(
            brightness: Brightness.light
          ),
          child: AlertDialog(
            backgroundColor: Colors.white,
            alignment: Alignment.center,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('assets/images/happy_star.png', width: 118, height: 144, fit: BoxFit.cover,),
                const SizedBox(height: 24,),
                Text(context.locale.thanks_for_your_feedback, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 18),),
                const SizedBox(height: 8,),
                Text(context.locale.thanks_for_your_feedback_description, style: const TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.w400), textAlign: TextAlign.center,),
              ],
            ),
          ),
        );
      },
    );
  }
  static void rateUs(BuildContext context){
    if(context.read<AppSettingsProvider>().showRate){
      showCupertinoDialog(
          context: context,
          barrierDismissible: true,
          builder: (context) {
            return const RateAppDialog();
          }
      );} else{
      showDialogThanksForFeedback(context);
      Future.delayed(Duration(seconds: 2), () {
        print('pop');
        Navigator.pop(context);
      });
    }
  }

  static void rateAppWithoutFeedback(BuildContext context){
    final appProvider = context.read<AppSettingsProvider>();
    if(appProvider.showRate && appProvider.isShowRateInSession){
      showCupertinoDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return const RateAppDialog();
        }
      );
    }
  }

  static void launchURL(String url) async {
    AdController.shared.setResumeAdState(true);
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw "Could not launch $url";
    }
  }
  static void termsOfService(){
    launchURL(AppInfo.termOfServiceLink);
  }
  static void privacyPolicy(){
    launchURL(AppInfo.policyPrivacyLink);
    print('object');
  }
}