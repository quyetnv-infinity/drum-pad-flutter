import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:drumpad_flutter/core/res/drawer/icon.dart';
import 'package:drumpad_flutter/core/res/drawer/image.dart';
import 'package:drumpad_flutter/core/utils/locator_support.dart';
import 'package:drumpad_flutter/src/mvvm/models/lesson_model.dart';
import 'package:drumpad_flutter/src/mvvm/views/home/widgets/marquee_text.dart';
import 'package:drumpad_flutter/src/service/api_service/api_service.dart';
import 'package:drumpad_flutter/src/widgets/blur_widget.dart';
import 'package:drumpad_flutter/src/widgets/star/star_result.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SongItem extends StatefulWidget {
  final bool isFromLearnFromSong;
  final SongCollection model;
  final bool isUnlocked;
  const SongItem({super.key, required this.isFromLearnFromSong,required this.model, this.isUnlocked = true});

  @override
  State<SongItem> createState() => _SongItemState();
}

class _SongItemState extends State<SongItem> {
  bool isErrorLoading = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: Container(
              width: MediaQuery.sizeOf(context).width * 0.42,
              decoration: BoxDecoration(
                color: Color(0xFF5936C2).withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CachedNetworkImage(imageUrl: '${ApiService.BASEURL}${widget.model.image}', fit: BoxFit.cover, errorWidget: (context, url, error) => const Icon(Icons.image_not_supported_outlined), width: double.infinity, height: double.infinity,),
                  ),
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Row(
                      spacing: 8,
                      children: [
                        BlurWidget(text: widget.model.difficulty.toUpperCase(),),
                        if(widget.isFromLearnFromSong)
                          BlurWidget(text: '${widget.model.lessons.isNotEmpty ? widget.model.lessons.length : widget.model.stepQuantity} ${context.locale.step.toUpperCase()}',),
                      ],
                    )),
                  if(widget.model.lessons.isNotEmpty && getStarAverage() != 0) Positioned(
                    bottom: 10,
                    left: 10,
                    child: RatingStars.custom(value: getStarAverage() * 100/3, smallStarWidth: 20, smallStarHeight: 20, bigStarWidth: 20, bigStarHeight: 20, isFlatStar: true,),
                  ),
                  if(!widget.isUnlocked) Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(8),
                        gradient: LinearGradient(colors: [
                          Color(0xFF5936C2).withValues(alpha: 0.7), Color(0xFF150C31).withValues(alpha: 0.7)
                        ], begin: Alignment.topCenter, end: Alignment.bottomCenter)
                      ),
                      alignment: Alignment.center,
                      child: SvgPicture.asset('assets/icons/ic_lock.svg'),
                    )
                  )
                ],
              ),
            ),
          ),
          // Text(model.name ?? "hihi", style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w600),),
          SizedBox(height: 6),
          SizedBox(
            width: MediaQuery.sizeOf(context).width * 0.42 ,
            height: 26,
            child: MarqueeText(text: widget.model.name ?? "", width: MediaQuery.sizeOf(context).width * 0.42, style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w600),)),
          Text(widget.model.author ??" haha", style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w400),)
        ],
      ),
    );
  }

  double getStarAverage(){
    if(!widget.isFromLearnFromSong){
      return widget.model.lessons[0].star;
    } else {
      final list = widget.model.lessons;
      int count = 0;
      double starSum = 0;
      for(var i = 0; i < list.length; i++){
        if(list[i].star != 0){
          count++;
          starSum += list[i].star;
        }
      }
      if(count != 0){
        return starSum/count;
      }
      return 0;
    }
  }
}
