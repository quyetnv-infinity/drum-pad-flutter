import 'package:drumpad_flutter/core/constants/hive_table.dart';
import 'package:drumpad_flutter/src/mvvm/models/lesson_model.dart';
import 'package:hive_ce/hive.dart';

class SongCollectionService {
  static final _box = Hive.box<SongCollection>(HiveTable.songCollectionTable);

  static Future<void> addSong(SongCollection song) async {
    if (!_box.isOpen) {
      await Hive.openBox<SongCollection>(HiveTable.songCollectionTable);
    }
    await _box.add(song);
  }

  static Future<SongCollection?> getSongById(String id) async {
    if (!_box.isOpen) {
      await Hive.openBox<SongCollection>(HiveTable.songCollectionTable);
    }
    final list = _box.values.toList();
    final index = list.indexWhere((element) => element.id == id);
    if(index != -1) {
      return _box.getAt(index);
    } else {
      return null;
    }
  }

  static Future<List<SongCollection>> getListSongByDifficultyMode(String difficult) async {
    if (!_box.isOpen) {
      await Hive.openBox<SongCollection>(HiveTable.songCollectionTable);
    }
    final list = _box.values.toList();
    return list.where((element) => element.difficulty == difficult,).toList();
  }

  static Future<void> updateSong(String id, SongCollection newSong) async {
    if (!_box.isOpen) {
      await Hive.openBox<SongCollection>(HiveTable.songCollectionTable);
    }
    final list = _box.values.toList();
    final index = list.indexWhere((element) => element.id == id);

    if (index != -1) {
      SongCollection updatedSong = list[index];
      updatedSong = newSong;
      print('updated');
      await _box.putAt(index, updatedSong);
    } else {
      print('added');
      await addSong(newSong);
    }
  }
  static Future<double> getTotalStarsOfAllSongCollections() async {
    if (!_box.isOpen) {
      await Hive.openBox<SongCollection>(HiveTable.songCollectionTable);
    }

    final list = _box.values.toList();

    double totalStars = 0.0;
    for (var songCollection in list) {
      totalStars += songCollection.getTotalStars();
    }

    return totalStars;
  }

  static Future<double> getLessonStarsByIndexFromAllSongCollections(int lessonIndex) async {
    if (!_box.isOpen) {
      await Hive.openBox<SongCollection>(HiveTable.songCollectionTable);
    }

    final list = _box.values.toList();
    double totalStars = 0.0;

    for (var songCollection in list) {
      if (songCollection.lessons.length > lessonIndex) {
        totalStars += songCollection.lessons[lessonIndex].star.toDouble() ?? 0.0;
      }
    }

    return totalStars;
  }

}