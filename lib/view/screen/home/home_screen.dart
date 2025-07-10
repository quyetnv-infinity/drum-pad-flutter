import 'dart:io';

import 'package:ads_tracking_plugin/ads_controller.dart';
import 'package:ads_tracking_plugin/collapsible_banner_ad/collapsible_banner_ad_widget.dart';
import 'package:and_drum_pad_flutter/core/res/style/text_style.dart';
import 'package:and_drum_pad_flutter/core/utils/locator_support.dart';
import 'package:and_drum_pad_flutter/core/utils/network_checking.dart';
import 'package:and_drum_pad_flutter/view/screen/beat_learn/beat_learn_screen.dart';
import 'package:and_drum_pad_flutter/view/screen/beat_runner/beat_runner_screen.dart';
import 'package:and_drum_pad_flutter/view/screen/profile/profile_screen.dart';
import 'package:and_drum_pad_flutter/view/screen/theme/theme_screen.dart';
import 'package:and_drum_pad_flutter/view/widget/bottom_navigation/bottom_navigation.dart';
import 'package:and_drum_pad_flutter/view/widget/loading_dialog/no_internet_dialog.dart';
import 'package:and_drum_pad_flutter/view/widget/scaffold/custom_scaffold.dart';
import 'package:and_drum_pad_flutter/view_model/network_provider.dart';
import 'package:and_drum_pad_flutter/view_model/purchase_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with WidgetsBindingObserver, AutomaticKeepAliveClientMixin<HomeScreen> {
  int _currentIndex = 0;
  late NoInternetDialog noInternetDialog;
  bool _wasConnected = true;

  final List<Widget Function()> _screenBuilders = [
        () => const BeatRunnerScreen(),
        () => const BeatLearnScreen(),
        () => const ThemeScreen(),
        () => const ProfileScreen(),
  ];

  late final List<Widget?> _screens =
  List<Widget?>.filled(_screenBuilders.length, null);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Khởi tạo màn hình đầu tiên
    _screens[_currentIndex] = _screenBuilders[_currentIndex]();
    noInternetDialog = NoInternetDialog(
      onTapGoSettings: () {
        AdController.shared.setResumeAdState(true);
        Navigator.pop(context);
        NetworkChecking.navigateToWiFiSettings(context);
      },
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {

        if(_currentIndex != 0){
          setState(() {
            _currentIndex = 0;
          });
          return;
        }
        exit(0);
      },
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: Colors.transparent,
            extendBody: true,
            extendBodyBehindAppBar: true,
            resizeToAvoidBottomInset: false,
            floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
            floatingActionButton: null,
            bottomNavigationBar: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                BottomNavigation(
                  currentIndex: _currentIndex,
                  onTap: (index) {
                    setState(() {
                      // Khởi tạo nếu chưa được tạo
                      _screens[index] ??= _screenBuilders[index]();
                      _currentIndex = index;
                    });
                  },
                ),
                Consumer<PurchaseProvider>(
                  builder: (context, purchaseProvider, _) {
                    return !purchaseProvider.isSubscribed ? const SafeArea(child: CollapsibleBannerAdWidget(adName: "banner_home")) : const SizedBox.shrink();
                  }
                )
              ],
            ),
            body: Selector<NetworkProvider, bool>(
              selector: (p0, p1) => p1.isConnected,
              builder: (context, isConnected, _) {
                if (_wasConnected != isConnected) {
                  if (!isConnected) {
                    print('show==========');
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      noInternetDialog.show(context);
                    });
                  } else {
                    print('hide==========');
                    noInternetDialog.dismiss();
                  }
                  _wasConnected = isConnected;
                }
                return IndexedStack(
                  index: _currentIndex,
                  children: List.generate(_screenBuilders.length, (index) {
                    return _screens[index] ?? const Center(child: CircularProgressIndicator());
                  }),
                );
              }
            ),
          ),
          ValueListenableBuilder<bool>(
            valueListenable: AdController.shared.isAppOpenAdLoadingNotifier,
            builder: (context, isLoading, child) {
              return isLoading
                  ? Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(color: Colors.black),
                    const SizedBox(height: 20),
                    Text(
                      'Welcome back',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              )
                  : const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}
