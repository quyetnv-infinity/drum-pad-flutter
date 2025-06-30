import 'dart:math';

import 'package:and_drum_pad_flutter/core/res/drawer/icon.dart';
import 'package:and_drum_pad_flutter/core/res/drawer/image.dart';
import 'package:and_drum_pad_flutter/core/res/style/text_style.dart';
import 'package:and_drum_pad_flutter/core/utils/font_responsive.dart';
import 'package:and_drum_pad_flutter/core/utils/locator_support.dart';
import 'package:and_drum_pad_flutter/data/model/lesson_model.dart';
import 'package:and_drum_pad_flutter/data/service/api_service/api_service.dart';
import 'package:and_drum_pad_flutter/view/widget/blur_widget.dart';
import 'package:and_drum_pad_flutter/view/widget/button/icon_button_custom.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AddNewSong extends StatefulWidget {
  final SongCollection? songCollection;
  final Function() onTap;
  final Function() onTapClearSong;
  const AddNewSong({super.key, required this.onTap, this.songCollection, required this.onTapClearSong});

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
  double baseWidth = 375.0;

  @override
  Widget build(BuildContext context) {

    return IntrinsicHeight(
      child: LayoutBuilder(
        builder: (context, constraints) {
          // final size = constraints.maxHeight > MediaQuery.sizeOf(context).width * 0.2 ? constraints.maxHeight * 0.8 : MediaQuery.sizeOf(context).width * 0.2;
          final screenW = MediaQuery.sizeOf(context).width;
          final maxSizeByWidth = screenW * 0.4;
          final maxSizeByHeight = constraints.maxHeight * 0.8;
          final size = min(maxSizeByWidth, maxSizeByHeight);
          final scaleFactor = constraints.maxHeight / maxSizeByWidth;
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
                child: SizedBox(
                  width:constraints.maxWidth,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      /// CÁI NÀY LÀ BACGROUND
                      Positioned.fill(
                        left: size * 0.4,
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/bg_2.png',
                              height: size,
                              fit: BoxFit.fitHeight,
                            ),
                            Expanded(
                              child: Container(
                                height: size,
                                decoration: BoxDecoration(
                                    image: DecorationImage(image: AssetImage('assets/bg_1.png'),
                                      fit: BoxFit.fill,)
                                ),
                                child: Stack(
                                  children: [
                                    ///HIỆN TEXT ADĐ HOẶC INFOR BÀI HÁT
                                    Positioned(
                                      left:  widget.songCollection == null? 0 : size * 0.1,
                                      right: widget.songCollection == null ? 0 : null,
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
                                                width: 160,
                                                child: Text(context.locale.choose_a_song_to_play, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white.withValues(alpha: 0.6)))
                                            ),
                                          ],
                                        ): _buildSongInformation(size),
                                      ),
                                    ),
                                    if(widget.songCollection != null)
                                      Positioned(
                                        right: size *0.1,
                                        top: size *0.1,
                                        child: Transform.scale(
                                          scale: 0.8,
                                          child: IconButtonCustom(iconAsset: ResIcon.icClose, onTap: widget.onTapClearSong
                                          ),
                                        ),
                                      )
                                  ],
                                )
                              ),
                            ),
                          ],
                        ),
                      ),
                      ///CÁI NÀY LÀ ẢNH BÀI HÁT
                      Positioned(
                        left: 0,
                        child: widget.songCollection == null ? SvgPicture.asset(
                          ResIcon.icAddSong,
                          height: size * 0.8,
                          fit: BoxFit.fitWidth,
                        ): RotationTransition(
                        turns: _rotationController,
                        child: Container(
                          width: size * 0.8,
                          height: size * 0.8,
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
                      )),


                    ],
                  ),
                )
              ),
            ),
          );
        }
      ),
    );
  }
  Widget _buildSongInformation(double size){
    return Padding(
      padding: EdgeInsets.symmetric(vertical: size * 0.1),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BlurWidget(text: widget.songCollection!.difficulty, fontSize: FontResponsive.responsiveFontSize(size *2.7, 10),),
          Text(
            widget.songCollection!.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: FontResponsive.responsiveFontSize(size *2.7, 20)),
          ),
          Text(
            widget.songCollection!.author,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: FontResponsive.responsiveFontSize(size *2.7, 14),
              color: Colors.white.withValues(alpha: 0.6),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: size *0.1, vertical: size *0.06),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              gradient: LinearGradient(colors: [Color(0xffA005ff), Color(0xffD796FF)]
              )
            ),
            child: Text(context.locale.choose_songs, style: TextStyle(fontSize: FontResponsive.responsiveFontSize(size *2.7, 12), fontWeight: FontWeight.w600),),
          )
        ],
      ),
    );
  }
}
