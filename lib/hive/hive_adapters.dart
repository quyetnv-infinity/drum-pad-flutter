import 'package:drumpad_flutter/src/mvvm/models/category_model.dart';
import 'package:drumpad_flutter/src/mvvm/models/lesson_model.dart';
import 'package:hive_ce/hive.dart';

part 'hive_adapters.g.dart';

@GenerateAdapters([AdapterSpec<SongCollection>(), AdapterSpec<LessonSequence>(), AdapterSpec<NoteEvent>(), AdapterSpec<Category>()])
// Annotations must be on some element
// ignore: unused_element
void _() {}