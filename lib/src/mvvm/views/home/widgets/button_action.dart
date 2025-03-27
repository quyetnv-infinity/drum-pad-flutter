import 'package:drumpad_flutter/core/res/dimen/spacing.dart';
import 'package:drumpad_flutter/core/res/drawer/icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ButtonAction extends StatelessWidget {
  final String title;
  final String content;
  final String imageBackground;
  final Function() onPressed;
  const ButtonAction({super.key, required this.title, required this.content, required this.imageBackground, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: onPressed,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          image: DecorationImage(
            image: AssetImage(imageBackground),
            fit: BoxFit.cover,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 23,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  ResSpacing.h12,
                  Text(
                    content,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            SvgPicture.asset(ResIcon.icArrowLeftCircleSolid),
          ],
        ),
      ),
    );
  }
}
