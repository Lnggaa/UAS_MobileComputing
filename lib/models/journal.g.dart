// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'journal.dart';

class JournalAdapter extends TypeAdapter<Journal> {
  @override
  final int typeId = 0;

  @override
  Journal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Journal(
      id: fields[0] as String,
      title: fields[1] as String,
      location: fields[2] as String,
      travelDate: fields[3] as DateTime,
      story: fields[4] as String,
      imagePath: fields[5] as String?,
      createdAt: fields[6] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Journal obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.location)
      ..writeByte(3)
      ..write(obj.travelDate)
      ..writeByte(4)
      ..write(obj.story)
      ..writeByte(5)
      ..write(obj.imagePath)
      ..writeByte(6)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JournalAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
