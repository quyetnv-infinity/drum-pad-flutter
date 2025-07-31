import 'package:ads_tracking_plugin/ads_controller.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppScaffoldLoadingAds extends StatelessWidget {

  final PreferredSizeWidget? appBar;
  final Widget? body;
  final Widget? bottomNavigationBar;
  final bool extendBody;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final bool extendBodyBehindAppBar;
  final String imagePath;
  const AppScaffoldLoadingAds({super.key,
    this.appBar,
    this.body,
    this.bottomNavigationBar,
    this.extendBody = false,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.extendBodyBehindAppBar = false,
    this.imagePath = 'assets/images/gradient_background.png',});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
              image: DecorationImage(image: AssetImage(imagePath), fit: BoxFit.fill)
          ),
          child: Scaffold(
            appBar: appBar,
            backgroundColor: Colors.transparent,
            body: body,
            bottomNavigationBar: bottomNavigationBar,
            extendBody: extendBody,
            floatingActionButton: floatingActionButton,
            floatingActionButtonLocation: floatingActionButtonLocation,
            extendBodyBehindAppBar: extendBodyBehindAppBar,
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
    );
  }
}
