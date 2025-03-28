import 'package:drumpad_flutter/core/res/drawer/image.dart';
import 'package:drumpad_flutter/src/mvvm/models/lesson_model.dart';
import 'package:drumpad_flutter/src/mvvm/view_model/drum_learn_provider.dart';
import 'package:drumpad_flutter/src/mvvm/views/drum_learn/widget/item_category_song.dart';
import 'package:drumpad_flutter/src/mvvm/views/drum_learn/widget/list_category_song_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class LearnCategoryDetails extends StatefulWidget {
  final String category;
  final bool isChooseSong;
  const LearnCategoryDetails({super.key, required this.category, required this.isChooseSong});

  @override
  State<LearnCategoryDetails> createState() => _LearnCategoryDetailsState();
}

class _LearnCategoryDetailsState extends State<LearnCategoryDetails> {
  TextEditingController _textEditingController = TextEditingController();
  List<SongCollection> _allSongs = [];
  List<SongCollection> _filteredSongs = [];

  @override
  void initState() {
    super.initState();
    _loadSongs();
  }

  void _loadSongs() {
    final provider = context.read<DrumLearnProvider>();
    _allSongs = provider.data;
    _filteredSongs = List.from(_allSongs);
  }

  void _onSearch(String query) {
    setState(() {
      _filteredSongs = _allSongs.where((song) =>
      (song.name!.toLowerCase().trim().contains(query.toLowerCase()) ||
          song.author!.toLowerCase().trim().contains(query.toLowerCase()))
      ).toList();
    });
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leadingWidth: 100,
        toolbarHeight: 50,
        backgroundColor: Colors.transparent,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Row(
              children: [
                Icon(Icons.arrow_back_ios, color: Colors.white, size: 22),
                Text('Back', style: TextStyle(color: Colors.white, fontSize: 17)),
              ],
            ),
          ),
        ),
        title: Text(widget.category,
            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage(ResImage.imgBG), fit: BoxFit.cover)),
        child: SafeArea(
          child: Column(
            children: [
              searchBar(),
              SizedBox(height: 24),
              Expanded(child: ListCategorySongWidget(isChooseSong: widget.isChooseSong, songs: _filteredSongs))
            ],
          ),
        ),
      ),
    );
  }

  Widget searchBar() {
    return Container(
      alignment: Alignment.center,
      height: 50,
      margin: EdgeInsets.symmetric(horizontal: 24),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Color(0xFFFFFFFF).withOpacity(0.2),
      ),
      child: Row(
        children: [
          Icon(CupertinoIcons.search, color: Colors.white),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _textEditingController,
              onChanged: _onSearch, // Gọi hàm lọc khi nhập text
              maxLength: 30,
              expands: false,
              maxLines: 1,
              maxLengthEnforcement: MaxLengthEnforcement.none,
              style: const TextStyle(color: Colors.white70),
              decoration: InputDecoration(
                maintainHintHeight: true,
                hintText: "Find your song here",
                hintStyle: TextStyle(color: Colors.white54),
                border: InputBorder.none,
                counterText: "",
                contentPadding: EdgeInsets.symmetric(vertical: 7),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
