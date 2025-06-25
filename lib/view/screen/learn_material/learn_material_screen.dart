import 'package:and_drum_pad_flutter/core/res/drawer/icon.dart';
import 'package:and_drum_pad_flutter/core/utils/locator_support.dart';
import 'package:and_drum_pad_flutter/view/screen/beat_learn_category_detail/beat_learn_category_detail_screen.dart';
import 'package:and_drum_pad_flutter/view/screen/beat_runner/widget/recommend_list_song.dart';
import 'package:and_drum_pad_flutter/view/widget/app_bar/custom_app_bar.dart';
import 'package:and_drum_pad_flutter/view/widget/list_view/mood_and_genres.dart';
import 'package:and_drum_pad_flutter/view/widget/scaffold/custom_scaffold.dart';
import 'package:and_drum_pad_flutter/view_model/category_provider.dart';
import 'package:and_drum_pad_flutter/view_model/drum_learn_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LearnMaterialScreen extends StatefulWidget {
  const LearnMaterialScreen({super.key});

  @override
  State<LearnMaterialScreen> createState() => _LearnMaterialScreenState();
}

class _LearnMaterialScreenState extends State<LearnMaterialScreen> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _loadRecommend();
    },);
  }

  Future<void> _loadRecommend() async {
    final drumLearnProvider = Provider.of<DrumLearnProvider>(context, listen: false);
    final categoryProvider = Provider.of<CategoryProvider>(context, listen: false);
    if(drumLearnProvider.listRecommend.isEmpty) {
      await drumLearnProvider.getRecommend();
    }
    if(categoryProvider.categories.isEmpty) {
      await categoryProvider.fetchCategories();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: CustomAppBar(
        iconLeading: ResIcon.icBack,
        onTapLeading: () {
          Navigator.pop(context);
        },
        title: context.locale.learn_material,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0).copyWith(right: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Consumer<DrumLearnProvider>(
                builder: (context, drumLearnProvider, _) {
                  return drumLearnProvider.listRecommend.isEmpty ? Container() : Flexible(
                    child: RecommendListSong(
                      title: context.locale.recommend_list_songs,
                      listSongs: drumLearnProvider.listRecommend,
                      onTapItem: (song) {

                      },
                    )
                  );
                }
              ),
              MoodAndGenres(
                onTapCategory: (category) {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => BeatLearnCategoryDetailScreen(category: category,),));
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
