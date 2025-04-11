// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_adapters.dart';

// **************************************************************************
// AdaptersGenerator
// **************************************************************************

class SongCollectionAdapter extends TypeAdapter<SongCollection> {
  @override
  final int typeId = 0;

  @override
  SongCollection read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SongCollection(
      id: fields[5] as String?,
      lessons: (fields[0] as List?)?.cast<LessonSequence>(),
      beatRunnerLessons: (fields[7] as List?)?.cast<LessonSequence>(),
      author: fields[1] as String?,
      name: fields[2] as String?,
      pathZipFile: fields[8] as String?,
      difficulty:
          fields[3] == null ? DifficultyMode.unknown : fields[3] as String,
      image: fields[4] as String?,
      campaignStar: fields[6] == null ? 0 : (fields[6] as num).toDouble(),
    );
  }

  @override
  void write(BinaryWriter writer, SongCollection obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.lessons)
      ..writeByte(1)
      ..write(obj.author)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.difficulty)
      ..writeByte(4)
      ..write(obj.image)
      ..writeByte(5)
      ..write(obj.id)
      ..writeByte(6)
      ..write(obj.campaignStar)
      ..writeByte(7)
      ..write(obj.beatRunnerLessons)
      ..writeByte(8)
      ..write(obj.pathZipFile);
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
  final int typeId = 1;

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
  final int typeId = 2;

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
