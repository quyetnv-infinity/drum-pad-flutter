import 'package:and_drum_pad_flutter/core/utils/locator_support.dart';
import 'package:and_drum_pad_flutter/data/model/lesson_model.dart';
import 'package:and_drum_pad_flutter/view/widget/item/song_item.dart';
import 'package:flutter/material.dart';

class RecommendListSong extends StatelessWidget {
  final String title;
  final Function(SongCollection song) onTapItem;
  final List<SongCollection> listSongs;
  const RecommendListSong({super.key, required this.title, required this.onTapItem, required this.listSongs});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 12,
      children: [
        Text(title, style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white.withValues(alpha: 0.8))),
        SizedBox(
          height: MediaQuery.sizeOf(context).width * 0.56,
          child: ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemCount: listSongs.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final song = listSongs[index];
              return SongItem(
                songCollection: song,
                onTap: () {
                  onTapItem(song);
                },
              );
            }
          ),
        )
      ],
    );
  }
}
