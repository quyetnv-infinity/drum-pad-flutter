
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
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<AppSettingsProvider>().setFalseRateInSession();
    },);
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
              height: 40,
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
      context.read<AppSettingsProvider>().setShowRate();
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
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        thanksDialogContext = context;
        return Theme(
          data: ThemeData(
            brightness: Brightness.light,
          ),
          child: AlertDialog(
            backgroundColor: Colors.white,
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


  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        brightness: Brightness.light,
      ),
      child: AlertDialog(
        backgroundColor: Colors.white,
        actionsPadding: EdgeInsets.symmetric(horizontal: 12),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Transform.translate(
                  offset: Offset(-16, 0),
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: SizedBox(
                      width: 28,
                      height: 28,
                      child: Icon(Icons.close, size: 28, color: Color(0xFF999CA1),),
                    ),
                  ),
                ),
                Container(
                  width: 198,
                  height: 119,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(17),
                    color: Colors.white
                  ),
                  child: ClipRRect(borderRadius: BorderRadius.circular(17),child: Image.asset('assets/images/img_rate_heart.png', fit: BoxFit.cover,)),
                ),
                SizedBox(width: 28,)
              ],
            ),
            const SizedBox(height: 8,),
            Text(context.locale.your_feedback_matters, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 16),),
            const SizedBox(height: 4,),
            Text(context.locale.tap_on_the_stars_to_rate_and_help_us_grow_stronger, style: const TextStyle(color: Color(0xFF494949), fontWeight: FontWeight.w400, fontSize: 12), textAlign: TextAlign.center,)
          ],
        ),
        actions: [
          Column(
            children: [
              _buildRatingBar(),
              if(ratingStar > 0) SizedBox(height: 12,),
              if(ratingStar != 0) InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: (){
                  handleRatingStar();
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 14),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    gradient: LinearGradient(colors: [
                      Color(0xFF2F6BFF), Color(0xFF3DAEFF)
                    ])
                  ),
                  child: Text(context.locale.submit, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),)
                )
              ),
              SizedBox(height: 12,),
            ],
          )
        ],
      ),
    );
  }
}