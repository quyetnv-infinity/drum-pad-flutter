import 'package:flutter/material.dart';

class AppScaffold extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget? body;
  final Widget? bottomNavigationBar;
  final bool extendBody;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final bool extendBodyBehindAppBar;

  const AppScaffold({
    super.key,
    this.appBar,
    this.body,
    this.bottomNavigationBar,
    this.extendBody = false,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.extendBodyBehindAppBar = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage('assets/images/gradient_background.png'), fit: BoxFit.fill)
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
    );
  }
}
