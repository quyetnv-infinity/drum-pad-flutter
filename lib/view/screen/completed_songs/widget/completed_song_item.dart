import 'package:and_drum_pad_flutter/core/res/drawer/icon.dart';
import 'package:and_drum_pad_flutter/core/utils/locator_support.dart';
import 'package:and_drum_pad_flutter/data/model/lesson_model.dart';
import 'package:and_drum_pad_flutter/data/service/api_service/api_service.dart';
import 'package:and_drum_pad_flutter/view/widget/blur_widget.dart';
import 'package:and_drum_pad_flutter/view/widget/button/icon_button_custom.dart';
import 'package:and_drum_pad_flutter/view/widget/star/star_result.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CompletedSongItem extends StatefulWidget {
  final SongCollection songCollection;
  final Function() onTap;
  const CompletedSongItem({super.key, required this.songCollection, required this.onTap});

  @override
  State<CompletedSongItem> createState() => _CompletedSongItemState();
}

class _CompletedSongItemState extends State<CompletedSongItem> {
  bool _isPressed = false;

  void _onTapDown(TapDownDetails details) {
    setState(() {
      _isPressed = true;
    });
  }

  void _onTapUp(TapUpDetails details) {
    setState(() {
      _isPressed = false;
    });
    widget.onTap;
  }

  void _onTapCancel() {
    setState(() {
      _isPressed = false;
    });
  }

  void _onHover(bool isHovering) {
    setState(() {
      _isPressed = isHovering;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _onHover(true),
      onExit: (_) => _onHover(false),
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        child: AnimatedScale(
            scale: _isPressed ? 0.95 : 1.0,
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeOut,
            child: Padding(
              padding: const EdgeInsets.all(8.0).copyWith(bottom: 0),
              child: Row(
                spacing: 12,
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: CachedNetworkImage(imageUrl: "${ApiService.BASEURL}${widget.songCollection.image}", height: 64, width: 64, fit: BoxFit.cover,)),
                  Column(
                    spacing: 4,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.songCollection.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                      ),
                      RatingStars.custom(value: getStarPercent(), smallStarWidth: 16, smallStarHeight: 16, bigStarWidth: 16, bigStarHeight: 16, isFlatStar: true,),
                      BlurWidget(text: widget.songCollection.difficulty,)
                    ],
                  ),
                  Spacer(),
                  InkWell(
                    borderRadius: BorderRadius.circular(30),
                    onTap: widget.onTap,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white.withValues(alpha: 0.6)),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(context.locale.replay, style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontWeight: FontWeight.w500, fontSize: 14),),
                    ),
                  )
                ],
              ),
            )
        ),
      ),
    );
  }

  double getStarPercent() {
    final lessons = widget.songCollection.lessons;
    int count = 0;
    double starSum = 0;
    for(var lesson in lessons){
      if(lesson.star != 0){
        count++;
        starSum += lesson.star;
      }
    }
    double average = 0;
    if(count != 0){
      average = starSum/count;
    }

    return average >= 3 ? 100 : (average >= 2 ? 75 : (average >= 1 ? 45 : 0));
  }
}
