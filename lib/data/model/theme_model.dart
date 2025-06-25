import 'package:and_drum_pad_flutter/core/res/drawer/icon.dart';
import 'package:flutter/material.dart';

class ThemeModel {
  final String id;
  final Gradient gradient;
  final String? assetIcon;
  final Color blurColor;
  final Color activeIconColor;

  ThemeModel({
    required this.id,
    required this.gradient,
    this.assetIcon,
    required this.blurColor,
    required this.activeIconColor
  });
}

List<ThemeModel> listThemes = [
  ThemeModel(id: 'default', gradient: RadialGradient(colors: [Color(0xFFE099FF), Color(0xFFC84BFF)],), activeIconColor: Color(0xFF91C6FF), blurColor: Color(0xFFF461FF)),
  ThemeModel(id: 'flash', gradient: RadialGradient(colors: [Colors.white, Color(0xFF38ADD1)],), assetIcon: ResIcon.icFlash, activeIconColor: Color(0xFF91C6FF), blurColor: Color(0xFF4DF3FF)),
  ThemeModel(id: 'flower', gradient: RadialGradient(colors: [Colors.white, Color(0xFFFF6FB5)],), assetIcon: ResIcon.icFlower, activeIconColor: Color(0xFFFFD7D7), blurColor: Color(0xFFFFBDDD)),
  ThemeModel(id: 'star', gradient: RadialGradient(colors: [Color(0xFFFFF6D7), Color(0xFFFFE56F)],), assetIcon: ResIcon.icStar, activeIconColor: Color(0xFFFBC129), blurColor: Color(0xFFFFED94)),
  ThemeModel(id: 'cloud', gradient: RadialGradient(colors: [Color(0xFF4FAAFF), Color(0xFF6FF8FF)],), assetIcon: ResIcon.icCloud, activeIconColor: Color(0xFF73DAFF), blurColor: Color(0xFF0ACEFF)),
  ThemeModel(id: 'sun', gradient: RadialGradient(colors: [Color(0xFFFF994F), Color(0xFFFFFF6F)],), assetIcon: ResIcon.icSun, activeIconColor: Color(0xFFFFD781), blurColor: Color(0xFFF4F066)),
  ThemeModel(id: 'pan_flower', gradient: RadialGradient(colors: [Color(0xFFFF4FD0), Color(0xFFDB6FFF)],), assetIcon: ResIcon.icPanFlower, activeIconColor: Color(0xFFD77CFF), blurColor: Color(0xFFFF7AFB)),
  ThemeModel(id: 'flower_tree', gradient: RadialGradient(colors: [Color(0xFFFFBBDB), Color(0xFFFF6F9F)],), assetIcon: ResIcon.icFlowerTree, activeIconColor: Color(0xFFFFB2D7), blurColor: Color(0xFFFFB2D8)),
  ThemeModel(id: 'music_note', gradient: RadialGradient(colors: [Color(0xFFAFFCFF), Color(0xFF008EFB)],), assetIcon: ResIcon.icMusicNote, activeIconColor: Color(0xFF3DE8FF), blurColor: Color(0xFF85F1FF)),
  ThemeModel(id: 'ghost', gradient: RadialGradient(colors: [Color(0xFFF5C6FF), Color(0xFFE552FF)],), assetIcon: ResIcon.icGhost, activeIconColor: Color(0xFFFD97FF), blurColor: Color(0xFFCA07C3)),
];