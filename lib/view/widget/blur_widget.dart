import 'dart:ui';

import 'package:flutter/material.dart';

class BlurWidget extends StatelessWidget {
  final String text;
  final double? fontSize;
  const BlurWidget({super.key, required this.text, this.fontSize });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
        child: Container(
          padding: const EdgeInsets.only(top: 3, bottom: 3, left: 8, right: 8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(text, style: TextStyle(fontSize:fontSize ?? 10, color: Colors.white.withValues(alpha: 0.6), fontWeight: FontWeight.w500),),
        )
      )
    );
  }
}
