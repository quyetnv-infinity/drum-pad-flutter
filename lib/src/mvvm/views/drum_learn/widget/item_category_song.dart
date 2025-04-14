import 'package:drumpad_flutter/core/res/drawer/image.dart';
import 'package:drumpad_flutter/src/mvvm/models/lesson_model.dart';
import 'package:drumpad_flutter/src/mvvm/views/lessons/lessons_screen.dart';
import 'package:drumpad_flutter/src/widgets/blur_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ItemCategorySong extends StatelessWidget {
  final SongCollection model;
  const ItemCategorySong({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).width * 0.17;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        spacing: 12,
        children: [
          Container(
            height: height,
            width: height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(image: AssetImage(model.image ?? ResImage.imgRose), fit: BoxFit.cover))
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 4,
              children: [
                Text("Nuqi bwnuorhavwns97rhacwiunrhaciowurghawnibryagwryouiabesngrvsyjiaduvgawioraw7ragbwsonjrhkgsaoiuyrawegeull", maxLines: 1,overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w600)),
                Text(model.author ?? "Null", style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w400)),
                IntrinsicWidth(
                  child: BlurWidget(text: model.difficulty,)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
