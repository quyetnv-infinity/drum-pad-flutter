import 'package:drumpad_flutter/core/constants/app_info.dart';
import 'package:drumpad_flutter/src/mvvm/view_model/app_setting_provider.dart';
import 'package:drumpad_flutter/src/mvvm/view_model/app_state_provider.dart';
import 'package:drumpad_flutter/src/mvvm/views/drum_learn/drum_learn_screen.dart';
import 'package:drumpad_flutter/src/mvvm/views/home/home_screen.dart';
import 'package:drumpad_flutter/src/mvvm/views/language/language_screen.dart';
import 'package:flutter/cupertino.dart';
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
      // AdController.shared.toggleResumeAdDisabled(true);
    }
    if(state == AppLifecycleState.resumed) {
      // AdController.shared.toggleResumeAdDisabled(false);
    }
  }

  void _onLoadingEnd() {
    // final adsProvider = Provider.of<AdsProvider>(context, listen: false);
    // adsProvider.showInterAd(
    //   name: "inter_splash",
    //   callback: () {
        _navigateToHome();
    //   }
    // );
  }

  Future<void> _navigateToHome() async {
    // AdController.shared.toggleResumeAdDisabled(false);
    final isFirstOpenApp = Provider.of<AppStateProvider>(context, listen: false).isFirstOpenApp;

    if (isFirstOpenApp) {
      Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) => const LanguageScreen(fromSetting: false,)));
    } else {
      Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) => const HomeScreen()));
      Provider.of<AppSettingsProvider>(context, listen: false).increaseTimeOpenApp();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                      duration: const Duration(seconds: 2), // Thời gian hoàn thành
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
    );
  }
}
