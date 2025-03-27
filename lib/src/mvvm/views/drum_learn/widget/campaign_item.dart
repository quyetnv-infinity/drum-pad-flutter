import 'package:drumpad_flutter/core/res/drawer/image.dart';
import 'package:drumpad_flutter/src/mvvm/views/lessons/lessons_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CampaignItem extends StatelessWidget {
  final Widget star;
  const CampaignItem({super.key, required this.star});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context).width;
    return GestureDetector(
      onTap: () {
        Navigator.push(context, CupertinoPageRoute(builder: (context) => LessonsScreen(),));
      },
      child: Container(
        height: size * 0.4,
        margin: EdgeInsets.symmetric(vertical: 16),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          image: DecorationImage(image: AssetImage(ResImage.imgCampaignBG), fit: BoxFit.cover)
        ),
        child: Row(
          spacing: 16,
          // mainAxisSize: MainAxisSize.max,
          children: [
            Image.asset(ResImage.imgPad),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Lesson 1', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color:  Colors.white)),
                Text('Fundamental 1', style: TextStyle(fontSize: 23, fontWeight: FontWeight.w600, color:  Colors.white)),
                Text('Progress', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color:  Colors.white)),
                star,
              ],
            )
          ],
        ),
      ),
    );
  }
}
