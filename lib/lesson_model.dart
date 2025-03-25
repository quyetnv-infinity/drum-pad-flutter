class  LessonModel {

  List<String> notes;
  double time;
  double? perfectScore;
  double? goodScore;
  double? earlyScore;
  double? lateScore;
  double? missedScore;
  double star;
  bool isCompleted;

  LessonModel({
    required this.notes,
    required this.time,
    this.perfectScore,
    this.goodScore,
    this.earlyScore,
    this.lateScore,
    this.missedScore,
    this.star = 0,
    this.isCompleted = false,
  });

}

class SongsModel{

  List<LessonModel> lessons;
  String nameSong;
  String author;
  String image;
  String difficultyLevel;

  SongsModel({
    required this.lessons,
    required this.nameSong,
    required this.author,
    required this.image,
    required this.difficultyLevel,
  });

}