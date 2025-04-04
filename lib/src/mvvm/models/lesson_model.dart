import 'package:drumpad_flutter/core/utils/locator_support.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive_ce/hive.dart';
import 'package:uuid/uuid.dart';

class NoteEvent extends HiveObject{
  List<String> notes;
  double time;

  NoteEvent({
    required this.notes,
    required this.time,
  });

  factory NoteEvent.fromJson(Map<String, dynamic> json) {
    final List<String> notes = (json['notes'] as List<dynamic>)
        .map((note) => note.toString())
        .toList();
    return NoteEvent(
      notes: notes,
      time:
          json['time'] is int ? (json['time'] as int).toDouble() : json['time'],
    );
  }
}

class LessonSequence extends HiveObject{
  int? level;
  List<NoteEvent> events;
  double? perfectScore;
  double? goodScore;
  double? earlyScore;
  double? lateScore;
  double? missedScore;
  double star;
  bool isCompleted;

  LessonSequence({
    this.level,
    required this.events,
    this.perfectScore,
    this.goodScore,
    this.earlyScore,
    this.lateScore,
    this.missedScore,
    this.star = 0,
    this.isCompleted = false,
  });

  factory LessonSequence.fromJson(Map<String, dynamic> json) {
    final List<NoteEvent> events = (json['events'] as List<dynamic>)
        .map((eventJson) => NoteEvent.fromJson(eventJson))
        .toList();

    return LessonSequence(
      events: events,
    );
  }
}

class SongCollection extends HiveObject{
  String id;
  List<LessonSequence> lessons;
  String? author;
  String? name;
  String difficulty;
  double campaignStar;
  String? image;

  SongCollection({
    String? id,
    required this.lessons,
    this.author,
    this.name,
    this.difficulty = DifficultyMode.unknown,
    this.image,
    this.campaignStar = 0
  }) : id = id ?? const Uuid().v4();

  factory SongCollection.fromJson(List<dynamic> json) {
    final List<LessonSequence> lessons = [];

    for (int i = 0; i < json.length; i++) {
      var lessonJson = json[i];
      var lesson = LessonSequence.fromJson(lessonJson);

      if (i == 0) {
        lesson.isCompleted = true;
        lesson.star = 0.0;
      }

      lesson.level = i + 1;

      lessons.add(lesson);
    }

    return SongCollection(
      lessons: lessons,
    );
  }

  SongCollection copyWith({
    String? id,
    List<LessonSequence>? lessons,
    String? author,
    String? name,
    String? difficulty,
    double? campaignStar,
    String? image,
  }) {
    return SongCollection(
      id: id ?? this.id,
      lessons: lessons ?? this.lessons,
      author: author ?? this.author,
      name: name ?? this.name,
      difficulty: difficulty ?? this.difficulty,
      campaignStar: campaignStar ?? this.campaignStar,
      image: image ?? this.image,
    );
  }

}


class DifficultyMode {
  static const String easy = 'easy';
  static const String medium = 'medium';
  static const String hard = 'hard';
  static const String demonic = 'demonic';
  static const String unknown = 'unknown';

  static String getString(BuildContext context, String mode){
    switch(mode){
      case DifficultyMode.easy:
        return context.locale.easy;
      case DifficultyMode.medium:
        return context.locale.medium;
      case DifficultyMode.hard:
        return context.locale.hard;
      case DifficultyMode.demonic:
        return context.locale.demonic;
      default:
        return context.locale.unknown;
    }
  }
}
