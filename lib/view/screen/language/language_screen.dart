import 'package:and_drum_pad_flutter/core/enum/language_enum.dart';
import 'package:and_drum_pad_flutter/core/extension/language_extension.dart';
import 'package:and_drum_pad_flutter/core/res/dimen/spacing.dart';
import 'package:and_drum_pad_flutter/core/utils/locator_support.dart';
import 'package:and_drum_pad_flutter/view/screen/language/widget/english_container.dart';
import 'package:and_drum_pad_flutter/view/screen/language/widget/other_language_container.dart';
import 'package:and_drum_pad_flutter/view/screen/onboarding/onboarding_screen.dart';
import 'package:and_drum_pad_flutter/view/widget/scaffold/custom_scaffold.dart';
import 'package:and_drum_pad_flutter/view_model/app_state_provider.dart';
import 'package:and_drum_pad_flutter/view_model/locale_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

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
      context.read<LocateViewModel>().initSelectedLanguage();
    });
    print(LanguageEnum.values.first.getPrioritizedLanguages);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if(widget.fromSetting) return;
    if (state == AppLifecycleState.paused) {
      // AdController.shared.setResumeAdState(true);
    }
    if (state == AppLifecycleState.resumed) {
      // AdController.shared.setResumeAdState(false);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final locateViewModel = Provider.of<LocateViewModel>(context, listen: true);
    return AppScaffold(
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              customAppBar(locateViewModel),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ListView.separated(
                    itemCount: LanguageEnum.values.length - 4,
                    padding: EdgeInsets.only(bottom: 50),
                    separatorBuilder: (context, index) => ResSpacing.h8,
                    itemBuilder: (context, index) {
                      final itemLanguage = LanguageEnum.en.getPrioritizedLanguages[index];
                      if(itemLanguage == LanguageEnum.en) {
                        return EnglishContainer(
                          selectedLanguage: locateViewModel.selectedLanguage,
                          onLanguageChanged: (value) {
                            locateViewModel.selectLanguage(value);
                          },
                        );
                      }
                      return OtherLanguageContainer(
                        value: itemLanguage,
                        languageSelected: locateViewModel.selectedLanguage,
                        onLanguageChanged: (language) {
                          locateViewModel.selectLanguage(language);
                        },
                      );
                    },
                  )
                ),
              ),
              if (!widget.fromSetting)
                Consumer<AppStateProvider>(
                  builder: (context, appStateProvider, _) {
                    return Container(
                      width: double.infinity,
                      height: 280,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                      ),
                    );
                    // return NativeAdWidget(
                    //   adName: "native_language",
                    //   disabled: !appStateProvider.shouldShowAds,
                    //   padding: EdgeInsets.only(bottom: 16),
                    //   decoration: BoxDecoration(
                    //     color: Colors.grey.withValues(alpha: 0.1),
                    //     borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                    //   ),
                    // );
                  }
                )
            ],
          ),
        ),
      )
    );
  }

  Widget customAppBar(LocateViewModel locateViewModel){
    return Container(
      height: 50,
      margin: EdgeInsets.symmetric(horizontal: 21),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(context.locale.language, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Colors.white),),
          ),
          if(locateViewModel.showCheckButton) Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () {
                if(!locateViewModel.showCheckButton) return;
                locateViewModel.saveLanguage();
                if (widget.fromSetting) {
                  Navigator.pop(context);
                } else {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => OnboardingScreen(),));
                }
              },
              child: SvgPicture.asset('assets/icons/ic_check.svg')
            )
          )
        ],
      ),
    );
  }
}

