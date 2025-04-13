// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bowel_record.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BowelRecordAdapter extends TypeAdapter<BowelRecord> {
  @override
  final int typeId = 2;

  @override
  BowelRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BowelRecord(
      dateTime: fields[0] as DateTime,
      duration: fields[1] as Duration,
      type: fields[2] as BristolType,
      isStraining: fields[3] as bool,
      hasBlood: fields[4] as bool,
      hasMucus: fields[5] as bool,
      feeling: fields[6] as PostFeeling?,
      notes: fields[7] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, BowelRecord obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.dateTime)
      ..writeByte(1)
      ..write(obj.duration)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.isStraining)
      ..writeByte(4)
      ..write(obj.hasBlood)
      ..writeByte(5)
      ..write(obj.hasMucus)
      ..writeByte(6)
      ..write(obj.feeling)
      ..writeByte(7)
      ..write(obj.notes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BowelRecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class BristolTypeAdapter extends TypeAdapter<BristolType> {
  @override
  final int typeId = 0;

  @override
  BristolType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return BristolType.type1;
      case 1:
        return BristolType.type2;
      case 2:
        return BristolType.type3;
      case 3:
        return BristolType.type4;
      case 4:
        return BristolType.type5;
      case 5:
        return BristolType.type6;
      case 6:
        return BristolType.type7;
      default:
        return BristolType.type1;
    }
  }

  @override
  void write(BinaryWriter writer, BristolType obj) {
    switch (obj) {
      case BristolType.type1:
        writer.writeByte(0);
        break;
      case BristolType.type2:
        writer.writeByte(1);
        break;
      case BristolType.type3:
        writer.writeByte(2);
        break;
      case BristolType.type4:
        writer.writeByte(3);
        break;
      case BristolType.type5:
        writer.writeByte(4);
        break;
      case BristolType.type6:
        writer.writeByte(5);
        break;
      case BristolType.type7:
        writer.writeByte(6);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BristolTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PostFeelingAdapter extends TypeAdapter<PostFeeling> {
  @override
  final int typeId = 1;

  @override
  PostFeeling read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return PostFeeling.relaxed;
      case 1:
        return PostFeeling.bloated;
      case 2:
        return PostFeeling.incomplete;
      case 3:
        return PostFeeling.pain;
      default:
        return PostFeeling.relaxed;
    }
  }

  @override
  void write(BinaryWriter writer, PostFeeling obj) {
    switch (obj) {
      case PostFeeling.relaxed:
        writer.writeByte(0);
        break;
      case PostFeeling.bloated:
        writer.writeByte(1);
        break;
      case PostFeeling.incomplete:
        writer.writeByte(2);
        break;
      case PostFeeling.pain:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PostFeelingAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
