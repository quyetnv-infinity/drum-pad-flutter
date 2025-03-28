import 'dart:convert';

import 'package:drumpad_flutter/core/res/drawer/image.dart';
import 'package:drumpad_flutter/src/mvvm/models/lesson_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
class DrumLearnProvider extends ChangeNotifier {
  final List<SongCollection> data = [
    SongCollection(
        lessons: [],
        image: "assets/images/music_99%.png",
        author: "MCK",
        name: "99%"),
    SongCollection(
        lessons: [],
        image: "assets/images/lactroi.png",
        author: "Sơn Tùng M-TP",
        name: "Lạc Trôi"),
    SongCollection(
        lessons: [],
        image: "assets/images/lactroi.png",
        author: "Sơn Tùng M-TP",
        name: "Lạc Trôi"),
    SongCollection(
        lessons: [],
        image: "assets/images/lactroi.png",
        author: "Sơn Tùng M-TP",
        name: "Lạc Trôi"),
    SongCollection(
        lessons: [],
        image: "assets/images/lactroi.png",
        author: "Sơn Tùng M-TP",
        name: "Lạc Trôi"),
    SongCollection(
        lessons: [],
        image: "assets/images/lactroi.png",
        author: "Sơn Tùng M-TP",
        name: "Lạc Trôi"),
    SongCollection(
        lessons: [],
        image: "assets/images/lactroi.png",
        author: "Sơn Tùng M-TP",
        name: "Lạc Trôi"),
    SongCollection(
        lessons: [],
        image: "assets/images/lactroi.png",
        author: "Sơn Tùng M-TP",
        name: "Lạc Trôi"),
    SongCollection(
        lessons: [],
        image: "assets/images/lactroi.png",
        author: "Sơn Tùng M-TP",
        name: "Lạc Trôi"),
    SongCollection(
        lessons: [],
        image: "assets/images/lactroi.png",
        author: "Sơn Tùng M-TP",
        name: "Lạc Trôi"),
  ];
}
