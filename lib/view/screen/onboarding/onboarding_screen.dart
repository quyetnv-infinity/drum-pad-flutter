import 'dart:io';

import 'package:ads_tracking_plugin/ads_controller.dart';
import 'package:ads_tracking_plugin/native_ad/native_ad_widget.dart';
import 'package:and_drum_pad_flutter/config/ads_config.dart';
import 'package:and_drum_pad_flutter/core/utils/locator_support.dart';
import 'package:and_drum_pad_flutter/view/screen/home/home_screen.dart';
import 'package:and_drum_pad_flutter/view/widget/scaffold/custom_scaffold.dart';
import 'package:and_drum_pad_flutter/view_model/app_setting_provider.dart';
import 'package:and_drum_pad_flutter/view_model/app_state_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> with WidgetsBindingObserver {
  late PageController pageController;
  int currentPage = 0;

  // ✅ Persistent ad widgets - created once, never disposed until screen closes
  Widget? _persistentPage1Ad;
  Widget? _persistentPage4Ad;
  bool _adsInitialized = false;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
    WidgetsBinding.instance.addObserver(this);

    // ✅ Initialize persistent ads immediately
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializePersistentAds();
    });
  }

  // ✅ Create ad widgets once and keep them alive
  void _initializePersistentAds() {
    if (!_adsInitialized) {
      final appStateProvider = Provider.of<AppStateProvider>(context, listen: false);

      _persistentPage1Ad = _PersistentAdWidget(
        key: const ValueKey('page1_ad'),
        adNameSelector: (isFirstOpen) => isFirstOpen ? AdName.nativeOnboarding : AdName.nativeOnboarding2,
        initialIsFirstOpen: appStateProvider.isFirstOpenApp,
        initialShouldShowAds: appStateProvider.shouldShowAds,
      );

      _persistentPage4Ad = _PersistentAdWidget(
        key: const ValueKey('page4_ad'),
        adNameSelector: (isFirstOpen) => isFirstOpen ? AdName.nativeOnboardingPage3 : AdName.nativeOnboardingPage32,
        initialIsFirstOpen: appStateProvider.isFirstOpenApp,
        initialShouldShowAds: appStateProvider.shouldShowAds,
      );

      _adsInitialized = true;
      setState(() {}); // Rebuild once after ads are ready
    }
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
    // ✅ Don't dispose ads here - let _PersistentAdWidget handle it
    super.dispose();
  }

  Future<void> nexPage() async {
    if (currentPage == 3) {
      final appStateProvider = Provider.of<AppStateProvider>(context, listen: false);
      appStateProvider.setFirstOpenApp();
      AdController.shared.setResumeAdState(false);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen())
      );
      Provider.of<AppSettingsProvider>(context, listen: false).increaseTimeOpenApp();
    } else {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        exit(0);
      },
      child: AppScaffold(
        body: _adsInitialized
            ? _buildPageView()
            : const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget _buildPageView() {
    return PageView(
      controller: pageController,
      onPageChanged: (index) {
        // ✅ Update currentPage without setState to avoid rebuilds
        currentPage = index;
      },
      children: [
        _buildPage1(),
        _buildPage2(),
        _buildPage3(),
        _buildPage4(),
      ],
    );
  }

  Widget _buildPage1() {
    return Column(
      children: [
        _buildCustomPage(
          backgroundAsset: 'assets/images/onboarding_1.png',
          title: context.locale.title_onboarding_1,
          subtitle: context.locale.subtitle_onboarding_1,
          currentPageIndex: 0,
        ),
        _persistentPage1Ad!, // ✅ Reuse same widget instance
      ],
    );
  }

  Widget _buildPage2() {
    return Column(
      children: [
        _buildCustomPage(
          backgroundAsset: 'assets/images/onboarding_2.png',
          title: context.locale.title_onboarding_2,
          subtitle: context.locale.subtitle_onboarding_2,
          currentPageIndex: 1,
        ),
        const SizedBox(height: kBottomNavigationBarHeight),
      ],
    );
  }

  Widget _buildPage3() {
    return Column(
      children: [
        _buildCustomPage(
          backgroundAsset: 'assets/images/onboarding_3.png',
          title: context.locale.title_onboarding_3,
          subtitle: context.locale.subtitle_onboarding_3,
          currentPageIndex: 2,
        ),
        const SizedBox(height: kBottomNavigationBarHeight),
      ],
    );
  }

  Widget _buildPage4() {
    return Column(
      children: [
        _buildCustomPage(
          backgroundAsset: 'assets/images/onboarding_4.png',
          title: context.locale.title_onboarding_4,
          subtitle: context.locale.subtitle_onboarding_4,
          currentPageIndex: 3,
        ),
        _persistentPage4Ad!, // ✅ Reuse same widget instance
      ],
    );
  }

  Widget _buildCustomPage({
    required String backgroundAsset,
    required String title,
    required String subtitle,
    required int currentPageIndex,
    EdgeInsets? imagePadding,
  }) {
    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 32.0),
                  child: Image.asset(
                    'assets/images/bg_onboarding.png',
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.fill,
                  ),
                ),
                Padding(
                  padding: imagePadding ?? EdgeInsets.zero,
                  child: Image.asset(
                    backgroundAsset,
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.fill,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 4),
            child: Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFFCCCDD0),
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Row(
              children: [
                // ✅ Use AnimatedBuilder to update indicator without rebuilding pages
                AnimatedBuilder(
                  animation: pageController,
                  builder: (context, child) {
                    return SmoothPageIndicator(
                      controller: pageController,
                      count: 4,
                      effect: WormEffect(
                        dotColor: Colors.white.withValues(alpha: 0.2),
                        activeDotColor: Colors.white,
                        dotHeight: 8.0,
                        dotWidth: 8.0,
                      ),
                    );
                  },
                ),
                const Spacer(),
                InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: nexPage,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white10,
                      borderRadius: BorderRadius.circular(44.0),
                    ),
                    child: Text(
                      currentPageIndex == 3 ? context.locale.start : context.locale.next,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ✅ Persistent Ad Widget - Lives for entire screen lifetime
class _PersistentAdWidget extends StatefulWidget {
  final String Function(bool isFirstOpen) adNameSelector;
  final bool initialIsFirstOpen;
  final bool initialShouldShowAds;

  const _PersistentAdWidget({
    super.key,
    required this.adNameSelector,
    required this.initialIsFirstOpen,
    required this.initialShouldShowAds,
  });

  @override
  State<_PersistentAdWidget> createState() => _PersistentAdWidgetState();
}

class _PersistentAdWidgetState extends State<_PersistentAdWidget> {
  late String currentAdName;
  late bool currentShouldShowAds;
  Widget? _cachedNativeAdWidget;

  @override
  void initState() {
    super.initState();
    currentAdName = widget.adNameSelector(widget.initialIsFirstOpen);
    currentShouldShowAds = widget.initialShouldShowAds;
    _createNativeAdWidget();
  }

  void _createNativeAdWidget() {
    _cachedNativeAdWidget = NativeAdWidget(
      key: ValueKey('persistent_$currentAdName'),
      margin: const EdgeInsets.only(top: 10),
      adName: currentAdName,
      disabled: !currentShouldShowAds,
      onAdLoaded: (value) {
        debugPrint('[PersistentAd] Ad loaded: $currentAdName, success: $value');
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            setState(() {}); // Trigger rebuild to show ad
          }
        });
      },
      height: 50,
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.2),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(7)),
        border: Border.all(width: 1, color: const Color(0xFFD3D3D3)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Selector<AppStateProvider, ({bool isFirstOpen, bool shouldShowAds})>(
      selector: (context, provider) => (
      isFirstOpen: provider.isFirstOpenApp,
      shouldShowAds: provider.shouldShowAds,
      ),
      builder: (context, state, child) {
        final newAdName = widget.adNameSelector(state.isFirstOpen);

        // ✅ Only recreate widget if ad name or show state actually changes
        if (newAdName != currentAdName || state.shouldShowAds != currentShouldShowAds) {
          currentAdName = newAdName;
          currentShouldShowAds = state.shouldShowAds;
          _createNativeAdWidget();
        }

        return _cachedNativeAdWidget!;
      },
    );
  }
}