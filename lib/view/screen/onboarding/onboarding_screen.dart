import 'package:ads_tracking_plugin/ads_controller.dart';
import 'package:ads_tracking_plugin/native_ad/native_ad_widget.dart';
import 'package:and_drum_pad_flutter/config/ads_config.dart';
import 'package:and_drum_pad_flutter/core/utils/locator_support.dart';
import 'package:and_drum_pad_flutter/view/screen/home/home_screen.dart';
import 'package:and_drum_pad_flutter/view/screen/onboarding/widgets/onboarding_widget.dart';
import 'package:and_drum_pad_flutter/view/widget/scaffold/custom_scaffold.dart';
import 'package:and_drum_pad_flutter/view_model/app_setting_provider.dart';
import 'package:and_drum_pad_flutter/view_model/app_state_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> with WidgetsBindingObserver {
  Color selectedDotColor = Colors.white;
  Color unselectedDotColor = Colors.white.withValues(alpha: 0.2);
  PageController pageController = PageController();
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.paused) {
      AdController.shared.setResumeAdState(true);
    }
    if (state == AppLifecycleState.resumed) {
      AdController.shared.setResumeAdState(false);
    }
  }

  @override
  void dispose() {
    pageController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> nexPage() async {
    if (currentPage == 3) {
      final appStateProvider = Provider.of<AppStateProvider>(context, listen: false);
      appStateProvider.setFirstOpenApp();
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
      Provider.of<AppSettingsProvider>(context, listen: false).increaseTimeOpenApp();
      print('time open appppp${Provider.of<AppSettingsProvider>(context, listen: false).timeOpenApp}');
    } else {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                // Image.asset(onboardingBackground!, fit: BoxFit.cover, width: double.infinity),
                PageView(
                  controller: pageController,
                  physics: const ClampingScrollPhysics(),
                  onPageChanged: (index) {
                    setState(() {
                      currentPage = index;
                    });
                  },
                  children: pages(context),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Container(
            color: Colors.transparent,
            padding: const EdgeInsets.symmetric(horizontal: 16,),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: SmoothPageIndicator(
                    controller: pageController,
                    count: 4,
                    effect: ExpandingDotsEffect(
                      activeDotColor: selectedDotColor,
                      dotColor: unselectedDotColor,
                      dotHeight: 8,
                      dotWidth: 8,
                      expansionFactor: 2,
                      // spacing: 4,
                    ),
                  )
                ),
                Material(
                  borderRadius: BorderRadius.circular(44),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: nexPage,
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                      color: Colors.white.withValues(alpha: 0.1),
                      child: Text(currentPage + 1 == 4 ? context.locale.start : context.locale.next, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 12),),
                    ),
                  ),
                )
              ],
            ),
          ),
          Consumer<AppStateProvider>(
            builder: (context, appStateProvider, _) {
              return Stack(
                children: [
                  Offstage(
                    offstage: currentPage != 0 || !appStateProvider.shouldShowAds,
                    child: NativeAdWidget(
                      adName: appStateProvider.isFirstOpenApp ? AdName.nativeOnboarding : AdName.nativeOnboarding2,
                      disabled: !appStateProvider.shouldShowAds,
                      onAdLoaded: (value) {
                        print("Native ad loaded: $value");
                      },
                      padding: EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                          color: Colors.grey.withValues(alpha: 0.2),
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(7)),
                          border: Border.all(width: 1, color: Color(0xFFD3D3D3))
                      ),
                    ),
                  ),
                  Offstage(
                    offstage: currentPage != 3 || !appStateProvider.shouldShowAds,
                    child: NativeAdWidget(
                      adName: appStateProvider.isFirstOpenApp ? AdName.nativeOnboardingPage3 : AdName.nativeOnboardingPage32,
                      disabled: !appStateProvider.shouldShowAds,
                      onAdLoaded: (value) {
                        print("Native ad loaded: $value");
                      },
                      padding: EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                          color: Colors.grey.withValues(alpha: 0.2),
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(7)),
                          border: Border.all(width: 1, color: Color(0xFFD3D3D3))
                      ),
                    ),
                  )
                ],
              );
            }
          )
        ]
      )
    );
  }

  List<Widget> pages(BuildContext context) => [
    page1(context),
    page2(context),
    page3(context),
    page4(context),
  ];
}
