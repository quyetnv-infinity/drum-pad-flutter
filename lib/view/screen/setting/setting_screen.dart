import 'package:and_drum_pad_flutter/core/res/drawer/icon.dart';
import 'package:and_drum_pad_flutter/core/utils/locator_support.dart';
import 'package:and_drum_pad_flutter/core/utils/setting_funcs.dart';
import 'package:and_drum_pad_flutter/view/screen/language/language_screen.dart';
import 'package:and_drum_pad_flutter/view/widget/app_bar/custom_app_bar.dart';
import 'package:and_drum_pad_flutter/view/widget/scaffold/custom_scaffold.dart';
import 'package:base_ui_flutter_v1/base_ui_flutter_v1.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: CustomAppBar(
        iconLeading: ResIcon.icBack,
        onTapLeading: () {
          Navigator.pop(context);
        },
        title: context.locale.setting,
      ),
      body: SettingWidget(
        basePadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        baseDecoration: BoxDecoration(
          color: Color(0x10CACACA),
          borderRadius: BorderRadius.circular(12),
        ),
        baseTitleStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        children: [
          SettingItem(
            title: context.locale.language,
            onPress: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => const LanguageScreen(fromSetting: true),
              ));
            },
            leading: SvgPicture.asset(ResIcon.icLanguage),
            trailing: SvgPicture.asset(ResIcon.icArrowRight),
          ),
          SettingItem(
            title: context.locale.term_of_service,
            onPress: () {
              SettingFuncs.termsOfService();
            },
            leading: SvgPicture.asset(ResIcon.icTermOfService),
            trailing: SvgPicture.asset(ResIcon.icArrowRight),
          ),
          // SettingItem(
          //   title: context.locale.rate,
          //   onPress: () {},
          //   leading: SvgPicture.asset(ResIcon.icStarColor),
          //   trailing: SvgPicture.asset(ResIcon.icArrowRight),
          // ),
          SettingItem(
            title: context.locale.share,
            onPress: () {
              SettingFuncs.share();
            },
            leading: SvgPicture.asset(ResIcon.icShare),
            trailing: SvgPicture.asset(ResIcon.icArrowRight),
          ),
          SettingItem(
            title: context.locale.policy,
            onPress: () {
              SettingFuncs.privacyPolicy();
            },
            leading: SvgPicture.asset(ResIcon.icShieldSecurity),
            trailing: SvgPicture.asset(ResIcon.icArrowRight),
          ),
        ],
      ),
    );
  }
}
