// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'study_session_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StudySessionModelAdapter extends TypeAdapter<StudySessionModel> {
  @override
  final int typeId = 1;

  @override
  StudySessionModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StudySessionModel(
      subjectName: fields[0] as String,
      date: fields[2] as DateTime,
      duration: Duration(seconds: fields[1]),
      uniqueKey: fields[3] as int,
      iconData: (fields[4] as List).cast<dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, StudySessionModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.subjectName)
      ..writeByte(1)
      ..write(obj.duration.inSeconds)
      ..writeByte(2)
      ..write(obj.date)
      ..writeByte(3)
      ..write(obj.uniqueKey)
      ..writeByte(4)
      ..write(obj.iconData);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StudySessionModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
