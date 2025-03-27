import 'package:drumpad_flutter/core/res/drawer/image.dart';
import 'package:drumpad_flutter/src/mvvm/views/drum_learn/widget/item_category_song.dart';
import 'package:drumpad_flutter/src/mvvm/views/drum_learn/widget/list_category_song_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LearnCategoryDetails extends StatelessWidget {
  final String category;
  const LearnCategoryDetails({super.key, required this.category});

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
                Text('Back', style: TextStyle(color: Colors.white, fontSize: 17),)
              ],
            ),
          ),
        ),
        title: Text(category, style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),)
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(image: DecorationImage(image: AssetImage(ResImage.imgBG),fit: BoxFit.cover)),
        child: SafeArea(
          child: Column(
            children: [
              searchBar(),
              SizedBox(height: 24),
              Expanded(child: ListCategorySongWidget())
            ],
          ),
        ),
      ),
    );
  }
  Widget searchBar(){
    return Container(
      alignment: Alignment.center,
      height: 50,
      margin: EdgeInsets.symmetric(horizontal: 24),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Color(0xFFFFFFFF).withValues(alpha: 0.2)
      ),
      child: Row(
        children: [
          Icon(CupertinoIcons.search),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
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
