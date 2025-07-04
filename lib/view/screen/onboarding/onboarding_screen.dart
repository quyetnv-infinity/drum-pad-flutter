import 'dart:io';

import 'package:ads_tracking_plugin/ads_controller.dart';
import 'package:and_drum_pad_flutter/view/screen/home/home_screen.dart';
import 'package:and_drum_pad_flutter/view/screen/onboarding/widgets/onboarding_widget.dart';
import 'package:and_drum_pad_flutter/view/widget/scaffold/custom_scaffold.dart';
import 'package:and_drum_pad_flutter/view_model/app_setting_provider.dart';
import 'package:and_drum_pad_flutter/view_model/app_state_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

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
      final appStateProvider =
          Provider.of<AppStateProvider>(context, listen: false);
      appStateProvider.setFirstOpenApp();
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));
      Provider.of<AppSettingsProvider>(context, listen: false)
          .increaseTimeOpenApp();
      print(
          'time open appppp${Provider.of<AppSettingsProvider>(context, listen: false).timeOpenApp}');
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
        body: PageView.builder(
          controller: pageController,
          onPageChanged: (index) {
            setState(() {
              currentPage = index;
            });
          },
          itemCount: pages(context).length,
          itemBuilder: (context, index) {
            return pages(context)[index];
          },
        ),
      ),
    );
  }

  List<Widget> pages(BuildContext context) => [
        page1(context, controller: pageController, currentPage: currentPage, onTapNext: () => nexPage(),),
        page2(context, controller: pageController, currentPage: currentPage, onTapNext: () => nexPage()),
        page3(context, controller: pageController, currentPage: currentPage, onTapNext: () => nexPage()),
        page4(context, controller: pageController, currentPage: currentPage, onTapNext: () => nexPage()),
      ];
}
