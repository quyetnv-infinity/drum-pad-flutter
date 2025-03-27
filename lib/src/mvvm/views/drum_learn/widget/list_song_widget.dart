import 'package:drumpad_flutter/core/res/drawer/image.dart';
import 'package:drumpad_flutter/src/mvvm/models/lesson_model.dart';
import 'package:drumpad_flutter/src/mvvm/view_model/drum_learn_provider.dart';
import 'package:drumpad_flutter/src/mvvm/views/drum_learn/learn_category_details.dart';
import 'package:drumpad_flutter/src/mvvm/views/drum_learn/widget/song_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListSongWidget extends StatefulWidget {
  final String title;
  final bool isMore;
  final bool isChooseSong;
  const ListSongWidget({super.key, required this.title, required this.isMore, required this.isChooseSong});

  @override
  State<ListSongWidget> createState() => _ListSongWidgetState();
}

class _ListSongWidgetState extends State<ListSongWidget> {
  SongCollection? _currentSongSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget.title, style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),),
                if(widget.isMore)InkWell(
                  onTap: () async {
                    final result = await Navigator.push(context, CupertinoPageRoute(builder: (context) => LearnCategoryDetails(category: widget.title, isChooseSong: widget.isChooseSong,),));
                    if(result != null && widget.isChooseSong){
                      setState(() {
                        _currentSongSelected = result;
                      });
                      Navigator.pop(context, _currentSongSelected);
                    }
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
                final song = context.read<DrumLearnProvider>().data[index];
                return GestureDetector(
                  onTap: (){
                    if(widget.isChooseSong){
                      Navigator.pop(context, song);
                    }
                  },
                  child: SongItem(
                  height: MediaQuery.sizeOf(context).width * 0.55,
                  isFromLearnFromSong: false,
                  model: song),
                );
              })
          ),
        ]
    );
  }
}
