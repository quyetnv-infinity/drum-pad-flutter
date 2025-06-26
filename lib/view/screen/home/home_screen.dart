import 'package:and_drum_pad_flutter/core/res/style/text_style.dart';
import 'package:and_drum_pad_flutter/core/utils/locator_support.dart';
import 'package:and_drum_pad_flutter/view/screen/beat_learn/beat_learn_screen.dart';
import 'package:and_drum_pad_flutter/view/screen/beat_runner/beat_runner_screen.dart';
import 'package:and_drum_pad_flutter/view/screen/profile/profile_screen.dart';
import 'package:and_drum_pad_flutter/view/screen/theme/theme_screen.dart';
import 'package:and_drum_pad_flutter/view/widget/bottom_navigation/bottom_navigation.dart';
import 'package:and_drum_pad_flutter/view/widget/scaffold/custom_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with WidgetsBindingObserver, AutomaticKeepAliveClientMixin<HomeScreen> {
  int _currentIndex = 0;

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

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBody: true,
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: null,
      bottomNavigationBar: BottomNavigation(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            // Khởi tạo nếu chưa được tạo
            _screens[index] ??= _screenBuilders[index]();
            _currentIndex = index;
          });
        },
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: List.generate(_screenBuilders.length, (index) {
          return _screens[index] ?? const Center(child: CircularProgressIndicator());
        }),
      ),
    );
  }
}
