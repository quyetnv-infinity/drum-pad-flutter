import 'package:drumpad_flutter/src/mvvm/views/drum_learn/learn_category_details.dart';
import 'package:drumpad_flutter/src/mvvm/views/drum_learn/widget/song_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ListSongWidget extends StatelessWidget {
  final String title;
  final bool isMore;
  const ListSongWidget({super.key, required this.title, required this.isMore});

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),),
                if(isMore)InkWell(
                  onTap: () {
                    Navigator.push(context, CupertinoPageRoute(builder: (context) => LearnCategoryDetails(category: title,),));
                  },
                  child: Row(
                    children: [
                      Text('More', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),),
                      Icon(Icons.chevron_right_rounded, size: 22)
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12),
          SizedBox(
            height: MediaQuery.sizeOf(context).width * 0.67,
            child: ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(horizontal: 16),
              itemCount: 4,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return SongItem(height: MediaQuery.sizeOf(context).width * 0.55, isFromLearnFromSong: true,);
              },),
          ),
        ]
    );
  }
}
