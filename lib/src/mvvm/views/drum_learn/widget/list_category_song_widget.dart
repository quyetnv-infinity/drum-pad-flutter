import 'package:drumpad_flutter/core/res/drawer/image.dart';
import 'package:drumpad_flutter/src/mvvm/view_model/drum_learn_provider.dart';
import 'package:drumpad_flutter/src/mvvm/views/drum_learn/widget/item_category_song.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListCategorySongWidget extends StatelessWidget {
  const ListCategorySongWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: 10,
      itemBuilder: (context, index) {
        final song = context.read<DrumLearnProvider>().data[index];
      return ItemCategorySong(model: song);
      },
    );
  }
}
