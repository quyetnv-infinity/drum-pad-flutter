import 'package:and_drum_pad_flutter/core/res/drawer/image.dart';
import 'package:and_drum_pad_flutter/core/utils/locator_support.dart';
import 'package:and_drum_pad_flutter/data/model/lesson_model.dart';
import 'package:and_drum_pad_flutter/view/screen/drum_pad_play/free_style/free_style_play_screen.dart';
import 'package:and_drum_pad_flutter/view/widget/app_bar/search_bar.dart';
import 'package:and_drum_pad_flutter/view/widget/item/song_category_item.dart';
import 'package:and_drum_pad_flutter/view/widget/loading_dialog/loading_dialog.dart';
import 'package:and_drum_pad_flutter/view/widget/scaffold/custom_scaffold.dart';
import 'package:and_drum_pad_flutter/view_model/category_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PickSongScreen extends StatefulWidget {
  final SongCollection? songCollection;
  const PickSongScreen({super.key, this.songCollection});

  @override
  State<PickSongScreen> createState() => _PickSongScreenState();
}

class _PickSongScreenState extends State<PickSongScreen> {
  final TextEditingController _textEditingController = TextEditingController();
  List<SongCollection> _allSongs = [];
  List<SongCollection> _filteredSongs = [];
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Future.delayed(Duration(milliseconds: 300), () {
        _loadSongs();
      },);
    },);
  }

  Future<void> _loadSongs() async {
    final categoryProvider = Provider.of<CategoryProvider>(context, listen: false);
    // Lấy tất cả các bài hát từ tất cả category
    _allSongs = widget.songCollection != null ? categoryProvider.getAllSongsByDifficulty(widget.songCollection?.difficulty ?? '') : categoryProvider.getAllSong();

    _filteredSongs = List.from(_allSongs);

    setState(() {});
  }

  void _onSearch(String query) {
    if (query.trim().isEmpty) {
      setState(() {
        _filteredSongs = List.from(_allSongs);
      });
      return;
    }

    setState(() {
      _filteredSongs = _allSongs.where((song) =>
      song.name.toLowerCase().trim().contains(query.toLowerCase()) ||
          song.author.toLowerCase().trim().contains(query.toLowerCase())
      ).toList();
    });

    if (query.length >= 50) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.black.withValues(alpha: 0.7),
            ),
            child: Text(
              '${context.locale.maximum_length_reached} (50/50)',
              style: TextStyle(color: Colors.white, fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.transparent,
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          width: MediaQuery.of(context).size.width * 0.6,
        ),
      );
    }
  }


  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Container(
      clipBehavior: Clip.antiAlias,
      height: screenHeight * 0.94,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(topRight: Radius.circular(12), topLeft: Radius.circular(12))
      ),
      child: AppScaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 6),
            Container(
              width: 70,
              height: 6,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(20)
              ),
            ),
            SizedBox(height: 16),
            SearchBarCustom(onSearch: _onSearch, textEditingController: _textEditingController,),
            Expanded(
              child: _filteredSongs.isNotEmpty ? ListView.builder(
                itemCount: _filteredSongs.length,
                itemBuilder: (context, index) {
                  final song = _filteredSongs[index];
                  return SongCategoryItem(key: ValueKey(song.id), songCollection: song, onTap: () {
                    showDialog(context: context, builder: (context) => LoadingDataScreen(
                      callbackLoadingCompleted: (song) {
                        Navigator.pop(context);
                        Navigator.pop(context, song);
                      },
                      callbackLoadingFailed: () {
                        Navigator.pop(context);
                      },
                      song: song,
                    ),);
                    // Navigator.pop(context, song);
                  },);
                },
              ) : Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 100),
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
                      Text(
                        textAlign: TextAlign.center,
                        context.locale.no_song_found_des,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                          color: Colors.white.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

