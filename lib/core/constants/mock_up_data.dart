import 'package:drumpad_flutter/src/mvvm/models/lesson_model.dart';

final List<SongCollection> dataSongCollections = [
  SongCollection(
      id: 'where_we_started',
      pathZipFile: 'https://github.com/hoanglm6201/zip_archive/raw/refs/heads/main/Lost%20Sky%20-%20Where%20We%20Started%20.zip',
      lessons: [],
      beatRunnerLessons: [],
      stepQuantity: 13,
      difficulty: DifficultyMode.hard,
      image: "/uploads/Heart_of_light_023ec8535f.jpg",
      author: "Lost Anh Tùng Lúi",
      name: "Lost Sky - Where We Started"),
  SongCollection(
      id: 'heroes_tonight',
      pathZipFile: 'https://github.com/hoanglm6201/zip_archive/raw/refs/heads/main/Heroes_Tonight.zip',
      lessons: [],
      beatRunnerLessons: [],
      stepQuantity: 14,
      difficulty: DifficultyMode.hard,
      image: "/uploads/Heart_of_light_023ec8535f.jpg",
      author: "Janji",
      name: "Heroes Tonight"),
];