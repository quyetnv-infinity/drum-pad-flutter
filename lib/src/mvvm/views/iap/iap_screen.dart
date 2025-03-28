import 'package:drumpad_flutter/core/res/drawer/icon.dart';
import 'package:drumpad_flutter/core/utils/locator_support.dart';
import 'package:drumpad_flutter/core/utils/setting_funcs.dart';
import 'package:drumpad_flutter/src/mvvm/views/iap/widget/text_gradient.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class IapScreen extends StatefulWidget {
  const IapScreen({super.key});

  @override
  State<IapScreen> createState() => _IapScreenState();
}

class _IapScreenState extends State<IapScreen> {
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Image.asset('assets/images/iap_img.png'),
                SafeArea(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: SvgPicture.asset(ResIcon.icX),
                    ),
                  )
                ),
                SafeArea(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Center(child: iapText(context.locale.unlock_all_premium_features)),
                        _buildDescription(context),
                        _buildSubscriptionItem(context, context.locale.monthly, "hehe", 0),
                        SizedBox(height: 16),
                        _buildSubscriptionItem(context, context.locale.yearly, "hihi", 1),
                        SizedBox(height: 24),
                        _buildContinueButton(context, () {},),
                        _buildPolicyRow()
                      ],
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildDescription(BuildContext context){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        spacing: 8,
        children: [
          Row(
            spacing: 10,
            children: [
              SvgPicture.asset(ResIcon.icDoneIAP),
              Text(context.locale.up_to_date_song, style: TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500
              ),)
            ],
          ),
          Row(
            spacing: 10,
            children: [
              SvgPicture.asset(ResIcon.icDoneIAP),
              Text(context.locale.new_lessons, style: TextStyle(
                  color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500
              ),)
            ],
          ),
          Row(
            spacing: 10,
            children: [
              SvgPicture.asset(ResIcon.icDoneIAP),
              Text(context.locale.new_keyboard, style: TextStyle(
                  color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500
              ),)
            ],
          )
        ],
      ),
    );
  }
  Widget _buildSubscriptionItem(BuildContext context, String text, String price, int index){
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
              colors: selectedIndex == index ? [Color(0xFFFFF200), Color(0xFFFD7779) ]: [Color(0xFF390966), Color(0xFF390966)]
          )
        ),
        child: Row(
          spacing: 16,
          children: [
            SvgPicture.asset( selectedIndex == index ? ResIcon.icRadioSelected : ResIcon.icRadio),
            Column(
              spacing: 4,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(text, style: TextStyle(color: selectedIndex == index ? Colors.black : Colors.white, fontSize: 16, fontWeight: FontWeight.w500),),
                Text(price, style: TextStyle(color: selectedIndex == index ? Colors.black : Colors.white, fontSize: 18, fontWeight: FontWeight.w700),),
              ],
            )
          ],
        ),
      ),
    );
  }
  Widget _buildContinueButton(BuildContext context, Function() func){
    return GestureDetector(
      onTap: func,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          color: Color(0xFF381A8B),
          borderRadius: BorderRadius.circular(50),
        ),
        child: Row(
          spacing: 6,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(context.locale.continuee, style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),),
            Icon(CupertinoIcons.arrow_right, size: 18 ,)
          ],
        ),
      ),
    );
  }
  Widget _buildPolicyRow(){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          TextButton(onPressed: () {
            SettingFuncs.termsOfService();
          },
            child: Text(context.locale.term_of_use, style: TextStyle( color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),),
          ),
          TextButton(onPressed: () {
            SettingFuncs.privacyPolicy();
          },
            child: Text(context.locale.privacy_policy, style: TextStyle( color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),),
          ),
          /// RESTORE FUNC
          TextButton(onPressed: () {},
            child: Text(context.locale.restore, style: TextStyle( color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),),
          ),
        ],
      ),
    );
  }
}
