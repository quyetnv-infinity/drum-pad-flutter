import 'package:ads_tracking_plugin/ads_controller.dart';
import 'package:ads_tracking_plugin/language/base_language_view.dart';
import 'package:drumpad_flutter/core/enum/language_enum.dart';
import 'package:drumpad_flutter/core/extension/language_extension.dart';
import 'package:drumpad_flutter/core/res/drawer/icon.dart';
import 'package:drumpad_flutter/core/utils/locator_support.dart';
import 'package:drumpad_flutter/src/mvvm/view_model/app_state_provider.dart';
import 'package:drumpad_flutter/src/mvvm/view_model/locale_view_model.dart';
import 'package:drumpad_flutter/src/mvvm/views/onboarding/onboarding_screen.dart';
import 'package:drumpad_flutter/src/widgets/scaffold/custom_scaffold.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:ads_tracking_plugin/native_ad/native_ad_widget.dart';


class LanguageScreen extends StatefulWidget {
  final bool fromSetting;

  const LanguageScreen({super.key, required this.fromSetting});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> with WidgetsBindingObserver {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_){
      setState(() {
        context.read<LocateViewModel>().initSelectedLanguage();
      });
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if(widget.fromSetting) return;
    if (state == AppLifecycleState.paused) {
      // AdController.shared.toggleResumeAdDisabled(true);
    }
    if (state == AppLifecycleState.resumed) {
      // AdController.shared.toggleResumeAdDisabled(false);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final locateViewModel = context.watch<LocateViewModel>();
    return CustomScaffold(
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              customAppBar(),
              const SizedBox(height: 16),
              Expanded(
                child: BaseLanguageList<LanguageEnum>(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  itemDecorationBuilder: (item, isSelected) {
                    return BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(18)),
                      gradient: LinearGradient(colors:
                        isSelected ? [Color(0xFFAF9BEC), Color(0xFF9276E4)] : [Color(0xFF6141BE), Color(0xFF421AB5)]
                      ,begin: Alignment.topCenter, end: Alignment.bottomCenter)
                    );
                  },
                  paddingInside: const EdgeInsets.symmetric(vertical: 4),
                  leadingBuilder: (context, item) => SvgPicture.asset(item.getFlag),
                  items: LanguageEnum.values,
                  displayNameBuilder: (item) => item.displayName(context),
                  textStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500
                  ),
                  textStyleSelected: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500
                  ),
                  selectedItem: locateViewModel.selectedLanguage,
                  onSelectItem: (value) {
                    context.read<LocateViewModel>().selectLanguage(value);
                  }
                ),
              ),
              if (!widget.fromSetting)
                Consumer<AppStateProvider>(
                  builder: (context, appStateProvider, _) {
                    return NativeAdWidget(
                      adName: "native_language",
                      disabled: !appStateProvider.shouldShowAds,
                      decoration: BoxDecoration(
                        color: Colors.grey.withValues(alpha: 0.1),
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                      ),
                    );
                  }
                )
            ],
          ),
        ),
      )
    );
  }

  Widget customAppBar(){
    return SizedBox(
      height: 50,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: widget.fromSetting ? Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: IconButton(icon: Icon(Icons.arrow_back_ios, color: Colors.white,), onPressed: () { Navigator.pop(context); },),
            ) : Container(),
          ),
          Align(
            alignment: Alignment.center,
            child: Text(context.locale.language, style: const TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.w700
            ),),
          ),
          if (context.read<LocateViewModel>().showCheckButton)
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.only(right: 12),
                child: IconButton(
                  icon: SvgPicture.asset(ResIcon.doneIcon),
                  onPressed: () {
                    context.read<LocateViewModel>().saveLanguage();
                    if (widget.fromSetting) {
                      Navigator.pop(context);
                    } else {
                      Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) => OnboardingScreen(),));
                    }
                  },
                ),
              )
            )
        ],
      ),
    );
  }
}

