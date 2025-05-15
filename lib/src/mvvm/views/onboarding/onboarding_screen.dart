import 'package:ads_tracking_plugin/ads_controller.dart';
import 'package:ads_tracking_plugin/native_ad/native_ad_widget.dart';
import 'package:ads_tracking_plugin/tracking/services/screen_logger.dart';
import 'package:drumpad_flutter/core/utils/locator_support.dart';
import 'package:drumpad_flutter/src/mvvm/view_model/app_setting_provider.dart';
import 'package:drumpad_flutter/src/mvvm/view_model/app_state_provider.dart';
import 'package:drumpad_flutter/src/mvvm/views/home/home_screen.dart';
import 'package:drumpad_flutter/src/mvvm/views/onboarding/widgets/onboarding_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> with WidgetsBindingObserver, ScreenLogger<OnboardingScreen> {
  Color selectedDotColor = Color(0xFF4F4CFF);
  Color unselectedDotColor = Color(0xFFD1D5DB);
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
      Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) => HomeScreen()));
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
    return Scaffold(
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
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
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
                  borderRadius: BorderRadius.circular(100),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: nexPage,
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                      color: Colors.transparent,
                      child: Text(currentPage + 1 == 4 ? context.locale.lets_go : context.locale.next, style: const TextStyle(color: Color(0xFF4F4CFF), fontWeight: FontWeight.w600, fontSize: 18),),
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
                      adName: 'native_onboarding_1_1',
                      color: Color(0xFF5A2CE4).withAlpha(30),
                      padding: const EdgeInsets.only(bottom: 16),
                    )
                  ),
                  Offstage(
                    offstage: currentPage != 3 || !appStateProvider.shouldShowAds,
                    child: NativeAdWidget(
                      adName: 'native_onboarding_1_4',
                      color: Color(0xFF5A2CE4).withAlpha(30),
                      padding: const EdgeInsets.only(bottom: 16),
                    )
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
