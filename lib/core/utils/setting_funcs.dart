// import 'package:ads_tracking_plugin/ads_controller.dart';
import 'package:drumpad_flutter/core/constants/app_info.dart';
import 'package:drumpad_flutter/core/utils/locator_support.dart';
import 'package:drumpad_flutter/src/mvvm/view_model/app_setting_provider.dart';
import 'package:drumpad_flutter/src/mvvm/views/setting/widget/feedback_item.dart';
import 'package:drumpad_flutter/src/mvvm/views/setting/widget/rate_app_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingFuncs {
  static void share(){
    Share.share(
        'Check out this amazing app! ${AppInfo.appLink}',
        subject: 'Beat Maker Pro: Drum Pad'
    );
  }
  static void showDialogReviewThanksForRate(BuildContext context){
    showCupertinoDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return CupertinoTheme(
          data: const CupertinoThemeData(
            brightness: Brightness.light
          ),
          child: CupertinoAlertDialog(
            title: Text(context.locale.thank_you, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 18),),
            content: Column(
              children: [
                Text(context.locale.thank_you_for_rate_description, style: const TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.w400),),
                const SizedBox(height: 15,),
                FeedbackItem(text: context.locale.too_much_ads),
                const SizedBox(height: 6,),
                FeedbackItem(text: context.locale.app_not_work),
                const SizedBox(height: 6,),
                FeedbackItem(text: context.locale.others),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: Text(context.locale.ok.toUpperCase(), style: const TextStyle(color: Color(0xFF007AFF), fontWeight: FontWeight.w900, fontSize: 14),))
            ],
          ),
        );
      },
    );
  }
  static void showDialogThanksForFeedback(BuildContext context){
    showCupertinoDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return CupertinoTheme(
          data: const CupertinoThemeData(
            brightness: Brightness.light
          ),
          child: CupertinoAlertDialog(
            content: Column(
              children: [
                Image.asset('assets/images/happy_star.png', width: 118, height: 144, fit: BoxFit.cover,),
                const SizedBox(height: 24,),
                Text(context.locale.thanks_for_your_feedback, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 18),),
                const SizedBox(height: 8,),
                Text(context.locale.thanks_for_your_feedback_description, style: const TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.w400),),

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
        Navigator.pop(context);
      });
    }
  }
  static void launchURL(String url) async {
    // AdController.shared.setResumeAdState(true);
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