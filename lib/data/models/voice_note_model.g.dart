// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'voice_note_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VoiceNoteModelAdapter extends TypeAdapter<VoiceNoteModel> {
  @override
  final int typeId = 3;

  @override
  VoiceNoteModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return VoiceNoteModel(
      id: fields[0] as String,
      downloadUrl: fields[1] as String,
      durationSeconds: fields[2] as int,
      recordedAt: fields[3] as DateTime,
      localPath: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, VoiceNoteModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.downloadUrl)
      ..writeByte(2)
      ..write(obj.durationSeconds)
      ..writeByte(3)
      ..write(obj.recordedAt)
      ..writeByte(4)
      ..write(obj.localPath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VoiceNoteModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
