import 'package:and_drum_pad_flutter/core/res/drawer/image.dart';
import 'package:and_drum_pad_flutter/core/utils/locator_support.dart';
import 'package:and_drum_pad_flutter/data/model/category_model.dart';
import 'package:and_drum_pad_flutter/data/model/lesson_model.dart';
import 'package:and_drum_pad_flutter/view/screen/drum_pad_play/drum_pad_play_screen.dart';
import 'package:and_drum_pad_flutter/view/widget/item/song_category_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ListCategoryDetails extends StatelessWidget {
  final Category category;
  final Function(SongCollection song) onTapItem;

  const ListCategoryDetails({super.key, required this.category, required this.onTapItem});

  @override
  Widget build(BuildContext context) {
    if (category.items == null || category.items!.isEmpty) {
      return Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(ResImage.iconEmpty),
            Text(
              context.locale.no_song_found,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: category.items!.length,
      itemBuilder: (context, index) {
        final song = category.items![index];
        return SongCategoryItem(songCollection: song, onTap: () {
          onTapItem(song);
        },);
      },
    );
  }
}
