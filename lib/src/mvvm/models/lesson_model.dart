class NoteEvent {
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

class LessonSequence {
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

class SongCollection {
  List<LessonSequence> lessons;
  String? author;
  String? name;
  String difficulty;
  String? image;

  SongCollection({
    required this.lessons,
    this.author,
    this.name,
    this.difficulty = 'Easy',
    this.image,
  });

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
}
