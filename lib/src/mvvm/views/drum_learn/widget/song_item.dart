import 'dart:ui';

import 'package:drumpad_flutter/core/res/drawer/icon.dart';
import 'package:drumpad_flutter/core/res/drawer/image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SongItem extends StatelessWidget {
  final double height;
  const SongItem({super.key, required this.height});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: height,
            width: MediaQuery.sizeOf(context).width * 0.42,
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(image: AssetImage(ResImage.imgRose), fit: BoxFit.cover)
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 10,
                  left: 10,
                  child: buildBlur(context, 'HARD')),
                Positioned(
                  bottom: 10,
                  left: 10,
                  child: Row(
                    children: [
                      SvgPicture.asset(ResIcon.starFull)
                    ],
                  ),
                )
              ],
            ),
          ),
          Text('Jack', style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w600),),
          Text('ViruSs', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w400),)
        ],
      ),
    );
  }
  Widget buildBlur(BuildContext context, String text){
    return Container(
      alignment: Alignment.center,
      clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(4),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
          padding: const EdgeInsets.only(top: 3, bottom: 3, left: 8, right: 8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(text, style: TextStyle(fontSize: 10),),
        )
      )
    );
  }
}
