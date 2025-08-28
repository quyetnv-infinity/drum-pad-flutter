import 'package:ads_tracking_plugin/ads_controller.dart';
import 'package:ads_tracking_plugin/tracking/services/screen_logger.dart';
import 'package:ads_tracking_plugin/tracking/services/screen_time_tracker.dart';
import 'package:and_drum_pad_flutter/view/screen/home/home_screen.dart';
import 'package:and_drum_pad_flutter/view/screen/onboarding/widgets/onboarding_widget.dart';
import 'package:and_drum_pad_flutter/view_model/app_setting_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> with ScreenLogger<OnboardingScreen>, ScreenTimeLogger<OnboardingScreen> {
  late ScrollController _scrollController;
  int _currentPage = 0;
  final int _totalPages = 4;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.hasClients) {
      final screenWidth = MediaQuery.of(context).size.width;
      final currentPageDouble = _scrollController.offset / screenWidth;
      final newPage = currentPageDouble.round().clamp(0, _totalPages - 1);

      if (newPage != _currentPage) {
        setState(() {
          _currentPage = newPage;
        });
      }
    }
  }

  void _nextPage() {
    if (_currentPage < _totalPages - 1) {
      final screenWidth = MediaQuery.of(context).size.width;
      final targetOffset = (_currentPage + 1) * screenWidth;

      _scrollController.animateTo(
        targetOffset,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _goToHome() {
    AdController.shared.setResumeAdState(false);
    context.read<AppSettingsProvider>().setFirstOpenApp();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const HomeScreen(),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        controller: _scrollController,
        physics: const PageScrollPhysics(),
        child: Row(
          children: [
            page1(
              context,
              currentPage: _currentPage,
              dataLength: _totalPages,
              onTapNext: _nextPage,
            ),
            page2(
              context,
              currentPage: _currentPage,
              dataLength: _totalPages,
              onTapNext: _nextPage,
            ),
            page3(
              context,
              currentPage: _currentPage,
              dataLength: _totalPages,
              onTapNext: _nextPage,
            ),
            page4(
              context,
              currentPage: _currentPage,
              dataLength: _totalPages,
              onTapNext: _goToHome,
            ),
          ],
        ),
      ),
    );
  }
}