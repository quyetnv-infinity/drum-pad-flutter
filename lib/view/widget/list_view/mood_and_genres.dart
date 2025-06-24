import 'package:and_drum_pad_flutter/view/widget/item/mood_and_genres_item.dart';
import 'package:flutter/material.dart';

class MoodAndGenres extends StatelessWidget {
  const MoodAndGenres({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 2),
      itemBuilder: (context, index) {
        return MoodAndGenresItem();
      },
    );
  }
}
