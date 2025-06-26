import 'package:and_drum_pad_flutter/core/utils/locator_support.dart';
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
  List<LessonSequence> beatRunnerLessons;
  int stepQuantity;
  String author;
  String name;
  String pathZipFile;
  String difficulty;
  double campaignStar;
  double campaignScore;
  String image;

  SongCollection({
    String? id,
    List<LessonSequence>? lessons,
    List<LessonSequence>? beatRunnerLessons,
    this.stepQuantity = 0,
    this.author = 'Unknown',
    this.name = 'Unknown',
    this.pathZipFile = '',
    this.difficulty = DifficultyMode.unknown,
    this.image = '',
    this.campaignStar = 0,
    this.campaignScore = 0,
  }) :  id = id ?? const Uuid().v4(),
        lessons = lessons ?? [],
        beatRunnerLessons = beatRunnerLessons ?? [];

  /// factory to get lessons and beatRunnerLessons
  factory SongCollection.fromJson(List<dynamic> jsonLessons, List<dynamic> jsonBeatRunnerLessons) {
    final List<LessonSequence> lessons = [];
    final List<LessonSequence> beatRunnerLessons = [];

    for (int i = 0; i < jsonLessons.length; i++) {
      var lessonJson = jsonLessons[i];
      var lesson = LessonSequence.fromJson(lessonJson);

      if (i == 0) {
        lesson.isCompleted = true;
        lesson.star = 0.0;
      }

      lesson.level = i + 1;

      lessons.add(lesson);
    }

    for (int i = 0; i < jsonBeatRunnerLessons.length; i++) {
      var lessonJson = jsonBeatRunnerLessons[i];
      var lesson = LessonSequence.fromJson(lessonJson);

      if (i == 0) {
        lesson.isCompleted = true;
        lesson.star = 0.0;
      }

      lesson.level = i + 1;

      beatRunnerLessons.add(lesson);
    }

    return SongCollection(
      lessons: lessons,
      beatRunnerLessons: beatRunnerLessons
    );
  }

  factory SongCollection.fromJsonRoot(Map<String, dynamic> json) {
    return SongCollection(
      id: json['id'],
      name: json['name'],
      stepQuantity: json['step_quantity'],
      pathZipFile: json['media'],
      author: json['author'],
      image: json['thumbnail'],
      difficulty: json['difficulty'],
    );
  }

  SongCollection copyWith({
    String? id,
    List<LessonSequence>? lessons,
    List<LessonSequence>? beatRunnerLessons,
    int? stepQuantity,
    String? author,
    String? name,
    String? pathZipFile,
    String? difficulty,
    double? campaignStar,
    String? image,
  }) {
    return SongCollection(
      id: id ?? this.id,
      lessons: lessons ?? this.lessons,
      beatRunnerLessons: beatRunnerLessons ?? this.beatRunnerLessons,
      stepQuantity: stepQuantity ?? this.stepQuantity,
      author: author ?? this.author,
      name: name ?? this.name,
      pathZipFile: pathZipFile ?? this.pathZipFile,
      difficulty: difficulty ?? this.difficulty,
      campaignStar: campaignStar ?? this.campaignStar,
      image: image ?? this.image,
    );
  }


  @override
  String toString() {
    return 'SongCollection{id: $id, lessons: $lessons, beatRunnerLessons: $beatRunnerLessons, stepQuantity: $stepQuantity, author: $author, name: $name, pathZipFile: $pathZipFile, difficulty: $difficulty, campaignStar: $campaignStar, campaignScore: $campaignScore, image: $image}';
  }

  double getTotalStars() {
    return lessons.fold(0.0, (total, lesson) => total + lesson.star);
  }
}


class DifficultyMode {
  static const String easy = 'Easy';
  static const String medium = 'Medium';
  static const String hard = 'Hard';
  static const String demonic = 'Demonic';
  static const String unknown = 'Unknown';

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

  static String getCampaignName(BuildContext context, String mode) {
    switch (mode) {
      case DifficultyMode.easy:
        return context.locale.easy_campaign;
      case DifficultyMode.medium:
        return context.locale.medium_campaign;
      case DifficultyMode.hard:
        return context.locale.hard_campaign;
      case DifficultyMode.demonic:
        return context.locale.demonic_campaign;
      default:
        return "";
    }
  }
}
