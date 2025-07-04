import 'package:and_drum_pad_flutter/core/res/drawer/icon.dart';
import 'package:and_drum_pad_flutter/data/model/lesson_model.dart';
import 'package:and_drum_pad_flutter/data/service/api_service/api_service.dart';
import 'package:and_drum_pad_flutter/view/widget/blur_widget.dart';
import 'package:and_drum_pad_flutter/view/widget/button/icon_button_custom.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class SongCategoryItem extends StatefulWidget {
  final SongCollection songCollection;
  final Function() onTap;
  const SongCategoryItem({super.key, required this.songCollection, required this.onTap});

  @override
  State<SongCategoryItem> createState() => _SongCategoryItemState();
}

class _SongCategoryItemState extends State<SongCategoryItem> {
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
            padding: const EdgeInsets.symmetric(horizontal: 16).copyWith(bottom: 8),
            child: Container(
              color: Colors.transparent,
              child: Row(
                spacing: 12,
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: CachedNetworkImage(imageUrl: "${ApiService.BASEURL}${widget.songCollection.image}", height: 64, width: 64, fit: BoxFit.cover,)),
                  Column(
                    spacing: 2,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.songCollection.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      Text(
                        widget.songCollection.author,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                          color: Colors.white.withValues(alpha: 0.6),
                        ),
                      ),
                      BlurWidget(text: widget.songCollection.difficulty,)
                    ],
                  ),
                  Spacer(),
                  IconButtonCustom(iconAsset: ResIcon.icPlay, onTap:  widget.onTap)
                ],
              ),
            ),
          )
        ),
      ),
    );
  }
}
