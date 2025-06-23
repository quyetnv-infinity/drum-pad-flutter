import 'package:and_drum_pad_flutter/data/model/category_model.dart';
import 'package:and_drum_pad_flutter/data/model/lesson_model.dart';
import 'package:hive_ce/hive.dart';

part 'hive_adapters.g.dart';

@GenerateAdapters([AdapterSpec<SongCollection>(), AdapterSpec<LessonSequence>(), AdapterSpec<NoteEvent>(), AdapterSpec<Category>()])
// Annotations must be on some element
// ignore: unused_element
void _() {}