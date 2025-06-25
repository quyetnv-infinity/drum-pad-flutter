import 'package:and_drum_pad_flutter/core/res/drawer/icon.dart';
import 'package:and_drum_pad_flutter/core/utils/locator_support.dart';
import 'package:and_drum_pad_flutter/data/model/category_model.dart';
import 'package:and_drum_pad_flutter/view/screen/beat_runner/widget/recommend_list_song.dart';
import 'package:and_drum_pad_flutter/view/screen/lessons/lessons_screen.dart';
import 'package:and_drum_pad_flutter/view/widget/app_bar/custom_app_bar.dart';
import 'package:and_drum_pad_flutter/view/widget/list_view/list_category_details.dart';
import 'package:and_drum_pad_flutter/view/widget/loading_dialog/loading_dialog.dart';
import 'package:and_drum_pad_flutter/view/widget/scaffold/custom_scaffold.dart';
import 'package:and_drum_pad_flutter/view_model/category_provider.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _loadCategory();
    },);
  }

  Future<void> _loadCategory() async {
    final categoryProvider = Provider.of<CategoryProvider>(context, listen: false);
    final category = categoryProvider.categories.firstWhere((element) => element.code == widget.category.code,);
    if(category.items != null && category.items!.length > 5) return;
    await categoryProvider.fetchItemByCategory(categoryCode: widget.category.code);
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
        crossAxisAlignment: CrossAxisAlignment.start,
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0).copyWith(top: 16),
            child: Text(context.locale.list_songs, style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 14, fontWeight: FontWeight.w600),),
          ),
          Expanded(
            child: Consumer<CategoryProvider>(
              builder: (context, categoryProvider, _) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0).copyWith(top: 4),
                  child: ListCategoryDetails(
                    category: categoryProvider.categories.firstWhere((element) => element.code == widget.category.code,),
                    onTapItem: (song) {
                      showDialog(
                        context: context,
                        builder: (context) => LoadingDataScreen(
                          callbackLoadingCompleted: (songResult) {
                            Navigator.pop(context);
                            Navigator.push(context, MaterialPageRoute(builder: (context) => LessonsScreen(song: songResult),));
                          },
                          callbackLoadingFailed: () {
                            Navigator.pop(context);
                          },
                          song: song
                        ),
                      );
                    },
                  ),
                );
              }
            )
          )
        ],
      ),
    );
  }
}
