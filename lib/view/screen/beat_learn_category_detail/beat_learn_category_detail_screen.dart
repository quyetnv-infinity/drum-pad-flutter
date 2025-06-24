import 'package:and_drum_pad_flutter/core/res/drawer/icon.dart';
import 'package:and_drum_pad_flutter/core/utils/locator_support.dart';
import 'package:and_drum_pad_flutter/data/model/category_model.dart';
import 'package:and_drum_pad_flutter/view/screen/beat_runner/widget/recommend_list_song.dart';
import 'package:and_drum_pad_flutter/view/widget/app_bar/custom_app_bar.dart';
import 'package:and_drum_pad_flutter/view/widget/scaffold/custom_scaffold.dart';
import 'package:and_drum_pad_flutter/view_model/drum_learn_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BeatLearnCategoryDetailScreen extends StatefulWidget {
  final Category category;
  const BeatLearnCategoryDetailScreen({super.key, required this.category});

  @override
  State<BeatLearnCategoryDetailScreen> createState() => _BeatLearnCategoryDetailScreenState();
}

class _BeatLearnCategoryDetailScreenState extends State<BeatLearnCategoryDetailScreen> {

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: CustomAppBar(
        title: widget.category.name,
        iconLeading: ResIcon.icBack,
        onTapLeading: () {
          Navigator.pop(context);
        },
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Consumer<DrumLearnProvider>(
                builder: (context, drumLearnProvider, _) {
                  return drumLearnProvider.listRecommend.isEmpty ? Container() : RecommendListSong(
                    title: context.locale.recommend_list_songs,
                    listSongs: drumLearnProvider.listRecommend,
                    onTapItem: (song) {
                    },
                  );
                }
            ),
          ),

        ],
      ),
    );
  }
}
