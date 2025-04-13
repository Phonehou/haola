// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pet_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PetDataAdapter extends TypeAdapter<PetData> {
  @override
  final int typeId = 10;

  @override
  PetData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PetData(
      level: fields[0] as int,
      experience: fields[1] as int,
    );
  }

  @override
  void write(BinaryWriter writer, PetData obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.level)
      ..writeByte(1)
      ..write(obj.experience);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PetDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
