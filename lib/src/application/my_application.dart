import 'package:drumpad_flutter/core/res/style/text_style.dart';
import 'package:drumpad_flutter/src/mvvm/views/drum_learn/drum_learn_screen.dart';
import 'package:drumpad_flutter/src/mvvm/views/lessons/lessons_screen.dart';
import 'package:flutter/material.dart';

class MyApplication extends StatelessWidget {
  const MyApplication({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'drum app',
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: AppFonts.sfProDisplay,
        appBarTheme: AppBarTheme(
          color: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          surfaceTintColor: Colors.transparent,
        ),
      ),
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      home: DrumLearnScreen(),
    );
  }
}
