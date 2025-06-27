import 'package:and_drum_pad_flutter/core/res/drawer/icon.dart';
import 'package:and_drum_pad_flutter/core/res/drawer/image.dart';
import 'package:and_drum_pad_flutter/core/utils/locator_support.dart';
import 'package:and_drum_pad_flutter/data/model/lesson_model.dart';
import 'package:and_drum_pad_flutter/view/screen/completed_songs/widget/completed_song_item.dart';
import 'package:and_drum_pad_flutter/view/screen/lessons/lessons_screen.dart';
import 'package:and_drum_pad_flutter/view/widget/app_bar/custom_app_bar.dart';
import 'package:and_drum_pad_flutter/view/widget/app_bar/search_bar.dart';
import 'package:and_drum_pad_flutter/view/widget/loading_dialog/loading_dialog.dart';
import 'package:and_drum_pad_flutter/view/widget/scaffold/custom_scaffold.dart';
import 'package:flutter/material.dart';

class CompletedSongsScreen extends StatefulWidget {
  final List<SongCollection> songs;
  const CompletedSongsScreen({super.key, required this.songs});

  @override
  State<CompletedSongsScreen> createState() => _CompletedSongsScreenState();
}

class _CompletedSongsScreenState extends State<CompletedSongsScreen> {
  final TextEditingController _textEditingController = TextEditingController();
  List<SongCollection> _allSongs = [];
  List<SongCollection> _filteredSongs = [];
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _loadSongs();
    },);
  }

  Future<void> _loadSongs() async {
    _allSongs = widget.songs;

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
    return AppScaffold(
      appBar: CustomAppBar(
        iconLeading: ResIcon.icBack,
        onTapLeading: () {
          Navigator.pop(context);
        },
        title: context.locale.completed_songs,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SearchBarCustom(onSearch: _onSearch, textEditingController: _textEditingController,),
          Expanded(
            child: _filteredSongs.isNotEmpty ? ListView.builder(
              itemCount: _filteredSongs.length,
              itemBuilder: (context, index) {
                final song = _filteredSongs[index];
                return CompletedSongItem(
                  songCollection: song,
                  onTap: () {
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
                );
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
    );
  }
}