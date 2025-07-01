import 'package:and_drum_pad_flutter/constant/app_info.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingFuncs {
  static void share(){
    SharePlus.instance.share(
        ShareParams(
          text: 'Check out this amazing app! ${AppInfo.appLink}',
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
  // static void showDialogThanksForFeedback(BuildContext context){
  //   showCupertinoDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (context) {
  //       return CupertinoTheme(
  //         data: const CupertinoThemeData(
  //           brightness: Brightness.light
  //         ),
  //         child: CupertinoAlertDialog(
  //           content: Column(
  //             children: [
  //               Image.asset('assets/images/happy_star.png', width: 118, height: 144, fit: BoxFit.cover,),
  //               const SizedBox(height: 24,),
  //               Text(context.locale.thanks_for_your_feedback, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 18),),
  //               const SizedBox(height: 8,),
  //               Text(context.locale.thanks_for_your_feedback_description, style: const TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.w400),),
  //
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }
  // static void rateUs(BuildContext context){
  //   if(context.read<AppSettingsProvider>().showRate){
  //     showCupertinoDialog(
  //         context: context,
  //         barrierDismissible: true,
  //         builder: (context) {
  //           return const RateAppDialog();
  //         }
  //     );} else{
  //     showDialogThanksForFeedback(context);
  //     Future.delayed(Duration(seconds: 2), () {
  //       Navigator.pop(context);
  //     });
  //   }
  // }
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