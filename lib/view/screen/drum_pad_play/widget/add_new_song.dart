import 'package:and_drum_pad_flutter/core/res/drawer/icon.dart';
import 'package:and_drum_pad_flutter/core/res/drawer/image.dart';
import 'package:and_drum_pad_flutter/core/res/style/text_style.dart';
import 'package:and_drum_pad_flutter/core/utils/locator_support.dart';
import 'package:and_drum_pad_flutter/data/model/lesson_model.dart';
import 'package:and_drum_pad_flutter/data/service/api_service/api_service.dart';
import 'package:and_drum_pad_flutter/view/widget/blur_widget.dart';
import 'package:and_drum_pad_flutter/view/widget/button/icon_button_custom.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class AddNewSong extends StatefulWidget {
  final SongCollection? songCollection;
  final Function() onTap;
  const AddNewSong({super.key, required this.onTap, this.songCollection});

  @override
  State<AddNewSong> createState() => _AddNewSongState();
}

class _AddNewSongState extends State<AddNewSong> with SingleTickerProviderStateMixin {
  bool _isPressed = false;
  late AnimationController _rotationController;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat(); // Lặp vô hạn
  }
  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

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
          child: Stack(
            alignment: Alignment.center,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child:Image.asset(
                  ResImage.imgBgAdd1,
                  height: screenW * 0.4,
                  fit: BoxFit.cover,
                )
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: widget.songCollection == null ? Image.asset(
                  ResImage.imgBgAdd2,
                  height: screenW * 0.33,
                  fit: BoxFit.cover,
                ): RotationTransition(
                  turns: _rotationController,
                  child: Container(
                    width: screenW * 0.33,
                    height: screenW * 0.33,
                    clipBehavior: Clip.antiAlias,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: CachedNetworkImage(
                      imageUrl: "${ApiService.BASEURL}${widget.songCollection?.image}",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Positioned(
                left:  widget.songCollection == null? screenW * 0.45 : screenW * 0.38,
                top: 0,
                bottom: 0,
                child: Align(
                  alignment: Alignment.center,
                  child: widget.songCollection == null ? Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(context.locale.add_new_song, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 20, fontFamily: AppFonts.commando)),
                      SizedBox(
                        width: 180,
                        child: Text(context.locale.choose_a_song_to_play, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white.withValues(alpha: 0.6)))
                      ),
                    ],
                  ): _buildSongInformation(),
                ),
              ),
              if(widget.songCollection != null)
               Positioned(
                 right: 10,
                 top: 10,
                 child: Transform.scale(
                   scale: 0.8,
                   child: IconButtonCustom(iconAsset: ResIcon.icClose, onTap: () {

                   },),
                 ),
               )
            ],
          )
        ),
      ),
    );
  }
  Widget _buildSongInformation(){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BlurWidget(text: widget.songCollection!.difficulty),
          Text(
            widget.songCollection!.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
          ),
          SizedBox(height: 8),
          Text(
            widget.songCollection!.author,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: Colors.white.withValues(alpha: 0.6),
            ),
          ),
          SizedBox(height: 16),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              gradient: LinearGradient(colors: [Color(0xffA005ff), Color(0xffD796FF)]
              )
            ),
            child: Text(context.locale.choose_songs, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),),
          )
        ],
      ),
    );
  }
}
