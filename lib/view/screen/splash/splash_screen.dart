import 'dart:io';

import 'package:ads_tracking_plugin/ads_controller.dart';
import 'package:ads_tracking_plugin/ads_tracking_plugin.dart';
import 'package:and_drum_pad_flutter/config/ads_config.dart';
import 'package:and_drum_pad_flutter/constant/app_info.dart';
import 'package:and_drum_pad_flutter/view/screen/home/home_screen.dart';
import 'package:and_drum_pad_flutter/view/screen/language/language_screen.dart';
import 'package:and_drum_pad_flutter/view/widget/scaffold/custom_scaffold.dart';
import 'package:and_drum_pad_flutter/view_model/ads_provider.dart';
import 'package:and_drum_pad_flutter/view_model/app_setting_provider.dart';
import 'package:and_drum_pad_flutter/view_model/app_state_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with WidgetsBindingObserver {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    AdController.shared.setResumeAdState(true);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if(state == AppLifecycleState.paused) {
      AdController.shared.setResumeAdState(true);
    }
  }

  void _onLoadingEnd() {
    EUConsent().requestConsent(() {
      final adsProvider = Provider.of<AdsProvider>(context, listen: false);
      adsProvider.showInterAd(
        name: AdName.interSplash,
        callback: () {
          _navigateToHome();
        }
      );
    });
  }

  Future<void> _navigateToHome() async {
    AdController.shared.setResumeAdState(false);
    final isFirstOpenApp = Provider.of<AppStateProvider>(context, listen: false).isFirstOpenApp;

    if (isFirstOpenApp || Platform.isAndroid) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LanguageScreen(fromSetting: false,)));
    } else {
      AdController.shared.setResumeAdState(false);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
      Provider.of<AppSettingsProvider>(context, listen: false).increaseTimeOpenApp();
      print('time open appppp${Provider.of<AppSettingsProvider>(context, listen: false).timeOpenApp}');
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
        body: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                  image: DecorationImage(image: AssetImage('assets/images/splash_screen.png'), fit: BoxFit.cover)
              ),
            ),
            Align(
                alignment: Alignment.center,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipRRect(borderRadius: BorderRadius.circular(24), child: Image.asset(AppInfo.appIcon, width: MediaQuery.of(context).size.width * 0.43, height: MediaQuery.of(context).size.width * 0.43, fit: BoxFit.cover,)),
                    const SizedBox(height: 48,),
                    Image.asset('assets/images/drum_pad_text_splash.png', width: MediaQuery.of(context).size.width * 0.54, fit: BoxFit.fitWidth,),
                    const SizedBox(height: 48,),
                    Opacity(
                      opacity: 0,
                      child: FractionallySizedBox(
                          widthFactor: 0.8,
                          child: TweenAnimationBuilder<double>(
                            tween: Tween<double>(begin: 0.0, end: 1.0),
                            duration: const Duration(seconds: 5), // Thời gian hoàn thành
                            builder: (context, value, child) {
                              return LinearProgressIndicator(
                                  value: value,
                                  backgroundColor: Colors.white.withValues(alpha: 0.1),
                                  valueColor: const AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                  minHeight: 8
                              );
                            },
                            onEnd: _onLoadingEnd,
                          )
                      ),
                    ),
                  ],
                )
            ),
          ],
        ),
      ),
    );
  }
}
