import 'package:flutter/material.dart';

enum BackgroundType {
  image,
  gradient,
  color,
}

class CustomScaffold extends StatelessWidget {
  final Widget? body;
  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Color? backgroundColor;
  final String backgroundImage;
  final BoxFit backgroundFit;
  final Gradient? gradient;
  final BackgroundType backgroundType;

  const CustomScaffold({
    super.key,
    this.body,
    this.appBar,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.backgroundColor,
    this.backgroundImage = 'assets/images/img_bg.png',
    this.backgroundFit = BoxFit.cover,
    this.backgroundType = BackgroundType.image,
    this.gradient = const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFF5A2CE4),
        Color(0xFF141414),
        Color(0xFF141414),
      ],
      stops: [0.0, 0.4, 1.0],
    ),
  });

  Widget _background() {
    switch (backgroundType) {
      case BackgroundType.image:
        return Image.asset(
          backgroundImage,
          fit: backgroundFit,
        );
      case BackgroundType.gradient:
        return Container(
          decoration: BoxDecoration(gradient: gradient),
        );
      case BackgroundType.color:
        return Container(
          color: backgroundColor,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background Image
        Positioned.fill(
          child: _background(),
        ),
        // Scaffold with transparent background
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: appBar,
          body: body,
          bottomNavigationBar: bottomNavigationBar,
          floatingActionButton: floatingActionButton,
          floatingActionButtonLocation: floatingActionButtonLocation,
        ),
      ],
    );
  }
}
