import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';

class MarqueeText extends StatelessWidget {
  final String text;
  final double width;
  final TextStyle style;

  const MarqueeText({
    required this.text,
    required this.width,
    required this.style,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final textPainter = TextPainter(
          text: TextSpan(text: text, style: style),
          maxLines: 1,
          textDirection: TextDirection.ltr,
        )..layout(maxWidth: double.infinity);

        if (textPainter.width <= width) {
          return Text(
            text,
            style: style,
            maxLines: 1,
          );
        }

        return Marquee(
          text: text,
          style: style,
          scrollAxis: Axis.horizontal,
          crossAxisAlignment: CrossAxisAlignment.start,
          blankSpace: 20.0,
          velocity: 30.0,
          startPadding: 10.0,
          accelerationDuration: Duration(seconds: 1),
          accelerationCurve: Curves.linear,
          decelerationDuration: Duration(milliseconds: 500),
          decelerationCurve: Curves.easeOut,
        );
      },
    );
  }
}