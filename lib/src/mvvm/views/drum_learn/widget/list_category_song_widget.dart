import 'package:drumpad_flutter/core/res/drawer/image.dart';
import 'package:drumpad_flutter/src/mvvm/views/drum_learn/widget/item_category_song.dart';
import 'package:flutter/material.dart';

class ListCategorySongWidget extends StatelessWidget {
  const ListCategorySongWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: 10,
      itemBuilder: (context, index) {
      return ItemCategorySong(asset: ResImage.imgRose,);
      },
    );
  }
}
