import 'package:and_drum_pad_flutter/core/utils/locator_support.dart';
import 'package:and_drum_pad_flutter/view/widget/item/song_item.dart';
import 'package:flutter/material.dart';

class RecommendListSong extends StatelessWidget {
  const RecommendListSong({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 12,
      children: [
        Text(context.locale.recent_list_song, style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white.withValues(alpha: 0.8))),
        SizedBox(
          height: MediaQuery.sizeOf(context).width * 0.53,
          child: ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: 6,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
            return SongItem();
          },),
        )
      ],
    );
  }
}
