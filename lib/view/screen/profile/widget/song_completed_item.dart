import 'dart:ui';

import 'package:and_drum_pad_flutter/data/model/lesson_model.dart';
import 'package:and_drum_pad_flutter/data/service/api_service/api_service.dart';
import 'package:and_drum_pad_flutter/view/widget/star/star_result.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class SongCompletedItem extends StatefulWidget {
  final SongCollection songCollection;
  final Function() onTap;
  const SongCompletedItem({super.key, required this.songCollection, required this.onTap});

  @override
  State<SongCompletedItem> createState() => _SongCompletedItemState();
}

class _SongCompletedItemState extends State<SongCompletedItem> {
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
    widget.onTap();
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
    final screenW = MediaQuery.sizeOf(context).width;

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
          child: Container(
            height: screenW * 0.6,
            width: screenW * 0.35,
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.only(bottom: 8),
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      ),
                      child: CachedNetworkImage(imageUrl:
                      '${ApiService.BASEURL}${widget.songCollection.image}',
                        height: screenW * 0.4,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 8,
                      left: 8,
                      child: IntrinsicWidth(
                        child: BlurWidget(text: widget.songCollection.difficulty), // giữ nguyên widget của bạn
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8, top: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.songCollection.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      RatingStars.custom(value: getStarPercent(), smallStarWidth: 16, smallStarHeight: 16, bigStarWidth: 16, bigStarHeight: 16, isFlatStar: true,)
                    ],
                  ),
                )
              ],
            ),
          ),
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

class BlurWidget extends StatelessWidget {
  final String text;
  const BlurWidget({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(4),
        ),
        child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
            child: Container(
              padding: const EdgeInsets.only(top: 3, bottom: 3, left: 8, right: 8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(text.toUpperCase(), style: TextStyle(fontSize: 10, color: Colors.black, fontWeight: FontWeight.w700),),
            )
        )
    );
  }
}