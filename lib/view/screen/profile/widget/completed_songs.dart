import 'package:and_drum_pad_flutter/core/utils/locator_support.dart';
import 'package:and_drum_pad_flutter/data/model/lesson_model.dart';
import 'package:and_drum_pad_flutter/view/screen/profile/widget/song_completed_item.dart';
import 'package:flutter/material.dart';

Widget completedSongs(BuildContext context, List<SongCollection> list, {required void Function(SongCollection song) onTapItem, required void Function() onTapViewAll}) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    spacing: 8,
    children: [
      Padding(
        padding: const EdgeInsets.only(right: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(context.locale.completed_songs, style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white.withValues(alpha: 0.8))),
            InkWell(
              onTap: () {
                onTapViewAll.call();
              },
              child: Text(context.locale.view_all, style: TextStyle(fontWeight: FontWeight.w500, color: Color(0xFFF461FF)))
            ),
          ],
        ),
      ),
      SizedBox(
        height: MediaQuery.sizeOf(context).width * 0.53,
        child: ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemCount: list.length > 3 ? 3 : list.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final song = list[index];
              return SongCompletedItem(
                songCollection: song,
                onTap: () {
                  onTapItem.call(song);
                },
              );
            }
        ),
      )
    ],
  );
}