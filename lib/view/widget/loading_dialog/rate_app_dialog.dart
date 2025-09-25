
import 'package:and_drum_pad_flutter/constant/app_info.dart';
import 'package:and_drum_pad_flutter/core/utils/locator_support.dart';
import 'package:and_drum_pad_flutter/view_model/app_setting_provider.dart';
import 'package:and_drum_pad_flutter/view_model/rate_app_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RateAppDialog extends StatefulWidget {
  const RateAppDialog({super.key});

  @override
  State<RateAppDialog> createState() => _RateAppDialogState();
}

class _RateAppDialogState extends State<RateAppDialog> {
  int ratingStar = 0;
  final TextEditingController feedbackController = TextEditingController();
  final FocusNode focusNode = FocusNode();
  int currentLength = 0;
  final int maxLength = 100;

  @override
  void dispose() {
    feedbackController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    feedbackController.addListener(() {
      setState(() {
        currentLength = feedbackController.text.length;
      });
    });

  }

  Widget _buildRatingBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(5, (index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                ratingStar = index + 1;
              });
            },
            child: Image.asset(
              index < ratingStar ? 'assets/images/star_rating_full.png' : 'assets/images/star_rating_empty.png',
              height: 30,
              fit: BoxFit.cover,
            ),
          );
        },),
      ),
    );
  }

  BuildContext? thanksDialogContext;
  Future<void> handleRatingStar() async {
    if(ratingStar <= 3){
      Navigator.pop(context);
      _showDialogThanksForFeedback();
      await Future.delayed(const Duration(seconds: 2));
      if (thanksDialogContext != null) Navigator.pop(thanksDialogContext!);
    } else {
      Navigator.pop(context);
      context.read<AppSettingsProvider>().setShowRate();
      final rateAppProvider = Provider.of<RateAppProvider>(context, listen: false);
      rateAppProvider.showRating();
    }
  }

  void _showDialogThanksForFeedback(){
    showCupertinoDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        thanksDialogContext = context;
        return CupertinoTheme(
          data: const CupertinoThemeData(
            brightness: Brightness.light,
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


  @override
  Widget build(BuildContext context) {
    return CupertinoTheme(
      data: const CupertinoThemeData(
        brightness: Brightness.light,
      ),
      child: CupertinoAlertDialog(
        content: Column(
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(17)
              ),
              child: ClipRRect(borderRadius: BorderRadius.circular(17),child: Image.asset(AppInfo.appIcon)),
            ),
            const SizedBox(height: 16,),
            Text(context.locale.enjoy_ai_fusion, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 18),),
            const SizedBox(height: 4,),
            Text(context.locale.tap_a_star_to_rate_on_app_store, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w400, fontSize: 18))
          ],
        ),
        actions: [
          Column(
            children: [
              CupertinoDialogAction(
                  onPressed: (){
                  },
                  child: _buildRatingBar()
              ),
              if(ratingStar > 0) Container(
                height: 1.0,
                color: CupertinoColors.systemGrey,
              ),
              if(ratingStar != 0) CupertinoDialogAction(
                  onPressed: (){
                    handleRatingStar();
                    context.read<AppSettingsProvider>().setIsShowRate();
                  },
                  child: Text(context.locale.submit, style: const TextStyle(color: Color(0xFF007AFF), fontSize: 16, fontWeight: FontWeight.w500),)
              ),
            ],
          )
        ],
      ),
    );
  }
}