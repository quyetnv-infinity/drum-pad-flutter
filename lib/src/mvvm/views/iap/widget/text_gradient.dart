import 'package:drumpad_flutter/core/res/style/text_style.dart';
import 'package:flutter/material.dart';

Widget iapText(
  String text, {
  double fontSize = 24,
  FontWeight fontWeight = FontWeight.w700,
}) {
  return ShaderMask(
    blendMode: BlendMode.srcIn,
    shaderCallback: (bounds) => LinearGradient(
      colors: [
        Color(0xFFFFF200),
        Color(0xFFFD7779),
      ],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    ).createShader(bounds),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: fontWeight,
        ),
        textAlign: TextAlign.center,
      ),
    ),
  );
}
