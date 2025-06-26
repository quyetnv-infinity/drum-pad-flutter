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

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  int _selectedIndex = 0;

  final Map<int, Widget> _loadedPages = {};

  Widget _getPage(int index) {
    if (_loadedPages.containsKey(index)) {
      return _loadedPages[index]!;
    }

    late final Widget page;
    switch (index) {
      case 0:
        page = BeatRunnerScreen();
        break;
      case 1:
        page = BeatLearnScreen();
        break;
      case 2:
        page = ThemeScreen();
        break;
      case 3:
        page = ProfileScreen();
        break;
      default:
        page = const SizedBox();
    }

    _loadedPages[index] = page;
    return page;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadedPages[0] = BeatRunnerScreen(); // preload trang đầu
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _onItemTapped(index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBody: true,
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: null,
      bottomNavigationBar: BottomNavigation(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: List.generate(4, (index) => _getPage(index)),
      ),
    );
  }
}