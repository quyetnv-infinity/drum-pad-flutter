import 'package:drumpad_flutter/core/res/drawer/image.dart';
import 'package:drumpad_flutter/core/utils/locator_support.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'widget/resume_widget.dart';

class DrumLearnScreen extends StatelessWidget {
  const DrumLearnScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leadingWidth: 100,
        toolbarHeight: 50,
        backgroundColor: Colors.transparent,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Row(
              children: [
                Icon(Icons.arrow_back_ios, color: Colors.white, size: 22),
                Text(context.locale.back, style: TextStyle(color: Colors.white, fontSize: 17),)
              ],
            ),
          ),
        ),
        title: Text(context.locale.drum_learn, style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),)
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(image: DecorationImage(image: AssetImage(ResImage.imgBG),fit: BoxFit.cover)),
        child: SafeArea(
          child: Column(
            children: [
              ResumeWidget()
            ],
          ),
        ),
      ),
    );
  }
}
