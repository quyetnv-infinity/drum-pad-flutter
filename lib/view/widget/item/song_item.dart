import 'dart:ui';

import 'package:flutter/material.dart';

class SongItem extends StatelessWidget {
  const SongItem({super.key});

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.sizeOf(context).width;
    return Container(
      height: screenW * 0.6,
      width: screenW * 0.35,
      margin: EdgeInsets.only(right: 8),
      padding: EdgeInsets.only(bottom: 8),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(12)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12)),
                child: Image.asset('assets/images/app_icon.png', height: screenW * 0.4, fit: BoxFit.cover,)),
              Positioned(
                top: 8,
                left: 8,
                child: IntrinsicWidth(
                  child: BlurWidget(text: 'easy')
                )
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8, top: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('inda caadasdasdasdstle',maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontWeight: FontWeight.w500)),
                Text('inda casasdasdasdasdasdtle',maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12, color: Colors.white.withValues(alpha: 0.6)),)
              ],
            ),
          )
        ],
      ),
    );
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
