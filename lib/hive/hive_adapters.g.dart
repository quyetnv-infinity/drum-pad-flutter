// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_adapters.dart';

// **************************************************************************
// AdaptersGenerator
// **************************************************************************

class SongCollectionAdapter extends TypeAdapter<SongCollection> {
  @override
  final typeId = 0;

  @override
  SongCollection read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SongCollection(
      id: fields[0] as String?,
      lessons: (fields[1] as List?)?.cast<LessonSequence>(),
      beatRunnerLessons: (fields[2] as List?)?.cast<LessonSequence>(),
      stepQuantity: fields[3] == null ? 0 : (fields[3] as num).toInt(),
      author: fields[4] == null ? 'Unknown' : fields[4] as String,
      name: fields[5] == null ? 'Unknown' : fields[5] as String,
      pathZipFile: fields[6] == null ? '' : fields[6] as String,
      difficulty:
          fields[7] == null ? DifficultyMode.unknown : fields[7] as String,
      image: fields[9] == null ? '' : fields[9] as String,
      campaignStar: fields[8] == null ? 0 : (fields[8] as num).toDouble(),
      campaignScore: fields[10] == null ? 0 : (fields[10] as num).toDouble(),
    );
  }

  @override
  void write(BinaryWriter writer, SongCollection obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.lessons)
      ..writeByte(2)
      ..write(obj.beatRunnerLessons)
      ..writeByte(3)
      ..write(obj.stepQuantity)
      ..writeByte(4)
      ..write(obj.author)
      ..writeByte(5)
      ..write(obj.name)
      ..writeByte(6)
      ..write(obj.pathZipFile)
      ..writeByte(7)
      ..write(obj.difficulty)
      ..writeByte(8)
      ..write(obj.campaignStar)
      ..writeByte(9)
      ..write(obj.image)
      ..writeByte(10)
      ..write(obj.campaignScore);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SongCollectionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class LessonSequenceAdapter extends TypeAdapter<LessonSequence> {
  @override
  final typeId = 1;

  @override
  LessonSequence read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LessonSequence(
      level: (fields[0] as num?)?.toInt(),
      events: (fields[1] as List).cast<NoteEvent>(),
      perfectScore: (fields[2] as num?)?.toDouble(),
      goodScore: (fields[3] as num?)?.toDouble(),
      earlyScore: (fields[4] as num?)?.toDouble(),
      lateScore: (fields[5] as num?)?.toDouble(),
      missedScore: (fields[6] as num?)?.toDouble(),
      star: fields[7] == null ? 0 : (fields[7] as num).toDouble(),
      isCompleted: fields[8] == null ? false : fields[8] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, LessonSequence obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.level)
      ..writeByte(1)
      ..write(obj.events)
      ..writeByte(2)
      ..write(obj.perfectScore)
      ..writeByte(3)
      ..write(obj.goodScore)
      ..writeByte(4)
      ..write(obj.earlyScore)
      ..writeByte(5)
      ..write(obj.lateScore)
      ..writeByte(6)
      ..write(obj.missedScore)
      ..writeByte(7)
      ..write(obj.star)
      ..writeByte(8)
      ..write(obj.isCompleted);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LessonSequenceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class NoteEventAdapter extends TypeAdapter<NoteEvent> {
  @override
  final typeId = 2;

  @override
  NoteEvent read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NoteEvent(
      notes: (fields[0] as List).cast<String>(),
      time: (fields[1] as num).toDouble(),
    );
  }

  @override
  void write(BinaryWriter writer, NoteEvent obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.notes)
      ..writeByte(1)
      ..write(obj.time);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NoteEventAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CategoryAdapter extends TypeAdapter<Category> {
  @override
  final typeId = 3;

  @override
  Category read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Category(
      name: fields[0] as String,
      code: fields[1] as String,
      items: fields[2] == null
          ? const []
          : (fields[2] as List?)?.cast<SongCollection>(),
    );
  }

  @override
  void write(BinaryWriter writer, Category obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.code)
      ..writeByte(2)
      ..write(obj.items);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CategoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
