import 'package:drumpad_flutter/core/res/drawer/image.dart';
import 'package:drumpad_flutter/core/utils/locator_support.dart';
import 'package:drumpad_flutter/src/mvvm/models/lesson_model.dart';
import 'package:drumpad_flutter/src/mvvm/view_model/drum_learn_provider.dart';
import 'package:drumpad_flutter/src/mvvm/views/drum_learn/widget/item_category_song.dart';
import 'package:drumpad_flutter/src/mvvm/views/drum_learn/widget/list_category_song_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class LearnCategoryDetails extends StatefulWidget {
  final String category;
  final bool isChooseSong;
  const LearnCategoryDetails({super.key, required this.category, required this.isChooseSong});

  @override
  State<LearnCategoryDetails> createState() => _LearnCategoryDetailsState();
}

class _LearnCategoryDetailsState extends State<LearnCategoryDetails> {
  final TextEditingController _textEditingController = TextEditingController();
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
    if(query.length >= 50) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.black.withValues(alpha: 0.7)
              ),
              child: Text('${context.locale.maximum_length_reached} (50/50)', style: TextStyle(color: Colors.white, fontSize: 18), textAlign: TextAlign.center,)
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
                Text(context.locale.back, style: TextStyle(color: Colors.white, fontSize: 17)),
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
              Expanded(
                child: _filteredSongs.isNotEmpty ? ListCategorySongWidget(
                  isChooseSong: widget.isChooseSong,
                  songs: _filteredSongs
                )
                :
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset('assets/icons/ic_no_song.svg', width: MediaQuery.of(context).size.width*0.5,),
                    Text(context.locale.no_song_similar_found, style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontWeight: FontWeight.w400, fontSize: 20),),
                    SizedBox(height: 200,)
                  ],
                )
              )
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
        color: Color(0xFFFFFFFF).withValues(alpha: 0.2),
      ),
      child: Row(
        children: [
          Icon(CupertinoIcons.search, color: Colors.white),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _textEditingController,
              onChanged: _onSearch, // Gọi hàm lọc khi nhập text
              maxLength: 50,
              maxLines: 1,
              style: const TextStyle(color: Colors.white70),
              decoration: InputDecoration(
                maintainHintHeight: true,
                hintText: context.locale.find_your_song_here,
                hintStyle: TextStyle(color: Colors.white54),
                border: InputBorder.none,
                counterText: "",
                contentPadding: EdgeInsets.zero,
                isDense: true
              ),
            ),
          ),
        ],
      ),
    );
  }
}
