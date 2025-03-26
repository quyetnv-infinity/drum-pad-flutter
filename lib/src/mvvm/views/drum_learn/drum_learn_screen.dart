import 'package:drumpad_flutter/core/res/drawer/image.dart';
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
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Row(
            children: [
              Icon(Icons.arrow_back_ios, color: Colors.white, size: 28),
              Text('Back', style: TextStyle(color: Colors.white, fontSize: 17),)
            ],
          ),
        ),
        title: Text('Drum Learn', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),)
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
