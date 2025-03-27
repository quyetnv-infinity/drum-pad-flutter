import 'package:drumpad_flutter/core/utils/locator_support.dart';
import 'package:drumpad_flutter/core/utils/setting_funcs.dart';
import 'package:drumpad_flutter/src/mvvm/views/language/language_screen.dart';
import 'package:drumpad_flutter/src/widgets/scaffold/custom_scaffold.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: AppBar(
        leadingWidth: 100,
        toolbarHeight: 50,
        backgroundColor: Colors.transparent,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Row(
              children: [
                Icon(Icons.arrow_back_ios, color: Colors.white, size: 24),
                Text(context.locale.back, style: TextStyle(color: Colors.white, fontSize: 17),)
              ],
            ),
          ),
        ),
        title: Text(context.locale.setting, style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),)
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _buildItemSetting('assets/icons/ic_language.svg', context.locale.language, () => Navigator.push(context, CupertinoPageRoute(builder: (context) => LanguageScreen(fromSetting: true),)),),
          _buildItemSetting('assets/icons/ic_rate.svg', context.locale.rate_us, () => SettingFuncs.rateUs(context),),
          _buildItemSetting('assets/icons/ic_share.svg', context.locale.share, () => SettingFuncs.share(),),
          _buildItemSetting('assets/icons/ic_term.svg', context.locale.term_of_service, () => SettingFuncs.termsOfService(),),
          _buildItemSetting('assets/icons/ic_policy.svg', context.locale.policy, () => SettingFuncs.privacyPolicy(),),
        ],
      ),
    );
  }

  Widget _buildItemSetting(String iconSvg, String text, void Function() onTap){
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 64,
        margin: EdgeInsets.symmetric(horizontal: 24, vertical: 4),
        padding: EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(colors: [
            Color(0xFF6141BE), Color(0xFF421AB5)
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter)
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SvgPicture.asset(iconSvg),
            SizedBox(width: 16,),
            Text(text, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 20),)
          ],
        ),
      ),
    );
  }
}
