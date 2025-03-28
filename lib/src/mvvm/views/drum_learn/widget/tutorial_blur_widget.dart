import 'package:drumpad_flutter/core/res/drawer/image.dart';
import 'package:drumpad_flutter/core/utils/locator_support.dart';
import 'package:flutter/material.dart';

class TutorialBlurWidget extends StatelessWidget {
  final double padHeight;
  const TutorialBlurWidget({super.key, required this.padHeight});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: Colors.black.withValues(alpha: 0.7),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: padHeight,
          child: HoldAndSlide(),
        ),
      ),
    );
  }
}

class HoldAndSlide extends StatelessWidget {
  const HoldAndSlide({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(context.locale.hold_and_slide, style: TextStyle(
          color: Colors.white, fontSize: 24, fontWeight: FontWeight.w500
        ),),
        Image.asset(ResImage.imgTutoStick),
        Text(context.locale.tap_to_exit, style: TextStyle(
            color: Colors.white, fontSize: 24, fontWeight: FontWeight.w500
        ),),
      ],
    );
  }
}

