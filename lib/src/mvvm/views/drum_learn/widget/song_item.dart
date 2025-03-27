import 'dart:ui';

import 'package:drumpad_flutter/core/res/drawer/icon.dart';
import 'package:drumpad_flutter/core/res/drawer/image.dart';
import 'package:drumpad_flutter/src/mvvm/models/lesson_model.dart';
import 'package:drumpad_flutter/src/widgets/blur_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SongItem extends StatelessWidget {
  final double height;
  final bool isFromLearnFromSong;
  final SongCollection model;
  const SongItem({super.key, required this.height, required this.isFromLearnFromSong,required this.model});

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
              image: DecorationImage(image: AssetImage(model.image ?? ResImage.imgRose), fit: BoxFit.cover)
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 10,
                  left: 10,
                  child: Row(
                    spacing: 8,
                    children: [
                      BlurWidget(text: model.difficulty.toUpperCase(),),
                      if(isFromLearnFromSong)
                        BlurWidget(text: '5 STEPS',),
                    ],
                  )),
                Positioned(
                  bottom: 10,
                  left: 10,
                  child: Row(
                    children: [
                      SvgPicture.asset(ResIcon.icStarFull)
                    ],
                  ),
                )
              ],
            ),
          ),
          Text(model.name ?? "hihi", style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w600),),
          Text(model.author ??" haha", style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w400),)
        ],
      ),
    );
  }
}
