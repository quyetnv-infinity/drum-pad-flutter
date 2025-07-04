import 'package:and_drum_pad_flutter/core/utils/locator_support.dart';
import 'package:and_drum_pad_flutter/view/screen/result/widget/gradient_text.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CongratulationsWidget extends StatelessWidget {
  final Function() onTapExit;
  const CongratulationsWidget({super.key, required this.onTapExit});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).width * 0.25;
    return GestureDetector(
      onTap: onTapExit,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: height, horizontal: 20),
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height,
        color: Color(0xFF000000).withValues(alpha: 0.85),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Lottie.asset('assets/anim/congratulation.json', height: 300, width: 300),
            GradientText(context.locale.congratulation, style: TextStyle(
              fontSize: 32, fontWeight: FontWeight.w700
            )),
            Text(context.locale.congratulation_title, textAlign: TextAlign.center, style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.w500, color: Colors.white
            ),),
            Spacer(),
            Text(context.locale.tap_to_exit, style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.w500, color: Colors.white
            ),),
          ],
        ),
      ),
    );
  }
}

